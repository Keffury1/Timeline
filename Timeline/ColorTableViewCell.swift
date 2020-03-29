//
//  ColorTableViewCell.swift
//  Timeline
//
//  Created by Bobby Keffury on 3/28/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class ColorTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var timelineCollectionView: UICollectionView!
    
    var collectionViewOffset: CGFloat {
        get {
            return timelineCollectionView.contentOffset.x
        }
        set {
            timelineCollectionView.contentOffset.x = newValue
        }
    }
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        timelineCollectionView.delegate = dataSourceDelegate
        timelineCollectionView.dataSource = dataSourceDelegate
        timelineCollectionView.tag = row
        timelineCollectionView.reloadData()
    }
}
