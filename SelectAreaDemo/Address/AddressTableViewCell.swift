//
//  AddressTableViewCell.swift
//  SelectAreaDemo
//
//  Created by Lucas on 2018/6/13.
//  Copyright © 2018年 Lucas. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func set(title: String) {
        titleLabel.text = title
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        titleLabel.textColor = selected ? UIColor.red : UIColor.black
        iconImageView.isHidden = !selected
    }
    
}
