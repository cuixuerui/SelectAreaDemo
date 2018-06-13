//
//  ViewController.swift
//  SelectAreaDemo
//
//  Created by Lucas on 2018/6/11.
//  Copyright © 2018年 Lucas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var showView: AddressView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonAction(_ sender: Any) {
        showView = AddressView(frame:CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 380)
        )
        self.view.addSubview(showView!)
        showView?.backgroundColor = UIColor(white: 0.9, alpha: 1)
        showView?.showAdress()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        showView?.removeFromSuperview()
    }
    
}

