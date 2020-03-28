//
//  PinkCollectionViewCell.swift
//  Timeline
//
//  Created by Bobby Keffury on 3/28/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class PinkCollectionViewCell: UICollectionViewCell, UICollectionViewDataSource {
    
    @IBOutlet weak var pinkCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath) as? PinkCollectionViewCell else {
            return UICollectionViewCell() }
        
        return cell
    }
}
