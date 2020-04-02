//
//  TimelineCollectionViewCell.swift
//  Timeline
//
//  Created by Bobby Keffury on 3/28/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class TimelineTableViewCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var stripeView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - Views
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        
        view.addShadow()
    }
}
