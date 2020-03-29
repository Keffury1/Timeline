//
//  CustomTabBar.swift
//  Timeline
//
//  Created by Bobby Keffury on 3/29/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class CustomTabBar: UITabBarController {
    
    //MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
    }
}
