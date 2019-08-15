//
//  SwRevealViewControllerExtension.swift
//  Smack
//
//  Created by Đặng Tiến on 8/9/19.
//  Copyright © 2019 Đặng Tiến. All rights reserved.
//

import Foundation
import SWRevealViewController

extension SWRevealViewController {
    static func getRevealToggle () -> Selector {
        return #selector(self.revealToggle(_:))
    }
}
