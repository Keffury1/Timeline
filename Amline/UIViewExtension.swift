//
//  UIViewExtension.swift
//  Amline
//
//  Created by Bobby Keffury on 4/1/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addShadow(){
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 3.0
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
    }
}
