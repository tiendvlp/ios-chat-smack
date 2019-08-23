//
//  RoundedButton.swift
//  Smack
//
//  Created by Đặng Tiến on 8/21/19.
//  Copyright © 2019 Đặng Tiến. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    @IBInspectable var cornerRadius : CGFloat = 5.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
    
    override func awakeFromNib() {
        self.setupView()
    }
    
    func setupView () {
        self.layer.cornerRadius = cornerRadius
    }
}
