//
//  AddressButton.swift
//  SelectAreaDemo
//
//  Created by Lucas on 2018/6/11.
//  Copyright © 2018年 Lucas. All rights reserved.
//

import UIKit

class AddressButton: UIButton {
    
    func setAddressName(name: String) {
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.setTitleColor(.black, for: .normal)
        contentMode = .center
        setTitle(name, for: .normal)
        sizeToFit()
    }

}

