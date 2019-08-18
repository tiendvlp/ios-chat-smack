//
//  ChannelVC.swift
//  Smack
//
//  Created by Đặng Tiến on 8/9/19.
//  Copyright © 2019 Đặng Tiến. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {
    @IBOutlet weak var btnLogIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController()?.rearViewRevealWidth = view.frame.size.width - 40
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLoginOnClickedListener(_ sender: Any) {
        performSegue(withIdentifier: GOTO_LOGIN, sender: nil)
    }
    
    @IBAction func prepareForUnwind (segue : UIStoryboardSegue) {
        
    }
    
}
