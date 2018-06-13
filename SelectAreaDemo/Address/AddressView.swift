//
//  AddressView.swift
//  SelectAreaDemo
//
//  Created by Lucas on 2018/6/11.
//  Copyright © 2018年 Lucas. All rights reserved.
//

import UIKit

struct Address: Codable {
    let children: [Address]?
    let code: String?
    let name: String?
}

class AddressView: UIView {

    private var selectScrollView = UIView()
    private var contentScrollView = UIScrollView()
    private var lineView: UIView = UIView()
    
    private var provinceTableView = UITableView()
    private var cityTableView = UITableView()
    private var areaTableView = UITableView()
    
    private var buttonsArray: [AddressButton] = []
    private var provinceArray: [Address] = [] //省份
    private var cityArray: [Address] = []  //城市
    private var areaArray: [Address] = []  //地区
    
    private var buttonsLastLeft: CGFloat = 20  //最后一个按钮的 X
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showAdress() {
        
        UIView.beginAnimations("", context: nil)
        UIView.setAnimationDuration(0.2)
        var rect = self.frame
        rect.origin.y = UIScreen.main.bounds.height - rect.height
        self.frame = rect
        UIView.commitAnimations()
    }
    
    /// 初始化UI
    private func setup() {
        selectScrollView = setupScrollView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: frame.width,
                                                         height: 45))
        addSubview(selectScrollView)
        buttonsArray = []
        setupSelectButton(title: "请选择", index: 1)
        
        lineView = UIView(frame: CGRect(x: 19,
                                        y: selectScrollView.bounds.height - 2,
                                        width: 45,
                                        height: 2))
        lineView.backgroundColor = UIColor.red
        addSubview(lineView)
        
        let line = UIView.init(frame: CGRect.init(x: 0,
                                                  y: 45,
                                                  width: frame.width,
                                                  height: 2))
        line.backgroundColor = UIColor.black
        addSubview(line)
       
        contentScrollView = setupScrollView(frame: CGRect(x: 0,
                                                          y: 45,
                                                          width: frame.width,
                                                          height: frame.height - 35))
        addSubview(contentScrollView)
        
        provinceTableView = setupTableView(index: 1)
        contentScrollView.addSubview(provinceTableView)
        
        cityTableView = setupTableView(index: 2)
        contentScrollView.addSubview(cityTableView)
        
        areaTableView = setupTableView(index: 3)
        contentScrollView.addSubview(areaTableView)
        
        contentScrollView.isPagingEnabled = true
        
        getLocalAreaArray {[weak self] (dataArray) in
            self?.provinceArray = dataArray
            self?.provinceTableView.reloadData()
        }
        
    }
    
    private func setupScrollView(frame: CGRect) -> UIScrollView {
        let scrollView = UIScrollView(frame: frame)
        scrollView.contentSize = frame.size
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.backgroundColor = .clear
        return scrollView
    }
    
    private func tableViewToContentScrollView(tableView: UITableView, index: Int) {
        
        contentScrollView.contentSize = CGSize(width: CGFloat(index) * contentScrollView.bounds.width, height: contentScrollView.bounds.height)
        contentScrollView.setContentOffset(CGPoint(x:CGFloat(index - 1) * contentScrollView.bounds.width, y: 0), animated: true)
        tableView.reloadData()
    }
    
    private func setupTableView(index: Int) -> UITableView {
        let tableView = UITableView(frame: CGRect(
            x: UIScreen.main.bounds.width * CGFloat(index - 1),
            y: 0, width: contentScrollView.bounds.width,
            height: contentScrollView.bounds.height), style: .plain)
        tableView.register(UINib(nibName: "AddressTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "AddressTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        return tableView
    }
    
    private func setupSelectButton(title: String, index: Int) {
        if index < buttonsArray.count {
            
            for (i, button) in buttonsArray.enumerated() {
                if i >= index {
                    button.removeFromSuperview()
                }
            }
            buttonsArray.removeLast(buttonsArray.count - index)
            let button = buttonsArray.last
            button?.setAddressName(name: "请选择")
            setupSelectButton(title: title, index: index)
        } else if index == buttonsArray.count {
            let proButton = buttonsArray[index - 1]
           
            let button = AddressButton()
            button.frame = proButton.frame
            button.setAddressName(name: title)
            button.addTarget(self, action: #selector(addAddressTitle(button:)), for: .touchUpInside)
            buttonsArray.insert(button, at: index - 1)
            selectScrollView.addSubview(button)
            buttonsLastLeft = button.frame.origin.x + button.frame.width + 20
            
            UIView.animate(withDuration: 0.1) {
                var rect = proButton.frame
                rect.origin.x = self.buttonsLastLeft
                proButton.frame = rect
                
                var lineRect = self.lineView.frame
                lineRect.size.width = index == 3 ? button.frame.width : rect.width
                if index != 3 { lineRect.origin.x = rect.origin.x }
                self.lineView.frame = lineRect
            }
            
        } else {
            let button = AddressButton()
            button.frame = CGRect(x: buttonsLastLeft,
                                  y: 0, width: 20.0, height: selectScrollView.bounds.height)
            button.setAddressName(name: title)
            button.addTarget(self, action: #selector(addAddressTitle(button:)), for: .touchUpInside)
            selectScrollView.addSubview(button)
            buttonsArray.append(button)
            buttonsLastLeft += button.frame.width + 20
        }
        
        if index == 3 {
            let button = buttonsArray[index]
            button.removeFromSuperview()
        }
    }
    
    /// 点击按钮滚动 contentScrollView
    ///
    /// - Parameter button: AddressButton
    @objc private func addAddressTitle(button: AddressButton) {
        guard let index = buttonsArray.index(of: button) else {
            return
        }
        let point = CGPoint(x: CGFloat(index) * contentScrollView.frame.width, y: 0)
        contentScrollView.setContentOffset(point, animated: true)
    }
    
}

extension AddressView {
    
    /// 异步读取城市信息
    ///
    /// - Parameter completion: 读取完成
    func getLocalAreaArray(completion: @escaping ([Address]) -> Void) {
        guard
            let path = Bundle.main.url(forResource: "citydata", withExtension: "json")
        else {
            return
        }
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: path, options: .alwaysMapped)
                let model = try JSONDecoder().decode([Address].self, from: data)
                DispatchQueue.main.async {
                    completion(model)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
}

// MARK: - scrollView delegate

extension AddressView {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == contentScrollView {
            let index = lroundf(Float(contentScrollView.contentOffset.x / contentScrollView.frame.width))
            
            let button = buttonsArray[index]
            UIView.animate(withDuration: 0.2) {
                var rect = self.lineView.frame
                rect.origin.x = button.frame.origin.x
                rect.size.width = button.frame.width
                self.lineView.frame = rect
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndDecelerating(scrollView)
    }
}



// MARK: - UITableViewDataSource

extension AddressView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == provinceTableView {
            return provinceArray.count
        } else if tableView == cityTableView {
            return cityArray.count
        } else {
            return areaArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"AddressTableViewCell") as! AddressTableViewCell
        cell.selectionStyle = .none
        if tableView == provinceTableView {
            cell.set(title: provinceArray[indexPath.row].name ?? "")
            
        } else if tableView == cityTableView {
            cell.set(title: cityArray[indexPath.row].name ?? "")
            
        } else {
            cell.set(title: areaArray[indexPath.row].name ?? "")
        }
        
        return cell
    }
}

extension AddressView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == provinceTableView {
            
            cityArray = provinceArray[indexPath.row].children ?? []
            tableViewToContentScrollView(tableView: cityTableView, index: 2)
            setupSelectButton(title: provinceArray[indexPath.row].name ?? "", index: 1)
            
        } else if tableView == cityTableView {
            
            areaArray = cityArray[indexPath.row].children ?? []
            tableViewToContentScrollView(tableView: areaTableView, index: 3)
            setupSelectButton(title: cityArray[indexPath.row].name ?? "", index: 2)
            
        } else {
            setupSelectButton(title: areaArray[indexPath.row].name ?? "", index: 3)
        }
    }
}











