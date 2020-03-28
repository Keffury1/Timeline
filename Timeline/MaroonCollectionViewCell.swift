//
//  MaroonCollectionViewCell.swift
//  Timeline
//
//  Created by Bobby Keffury on 3/28/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class MaroonCollectionViewCell: UICollectionViewCell, UICollectionViewDataSource {
    
    @IBOutlet weak var maroonCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath) as? MaroonCollectionViewCell else {
            return UICollectionViewCell() }
        
        return cell
    }
}
