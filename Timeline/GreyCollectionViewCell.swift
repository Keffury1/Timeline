//
//  GreyCollectionViewCell.swift
//  Timeline
//
//  Created by Bobby Keffury on 3/28/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class GreyCollectionViewCell: UICollectionViewCell, UICollectionViewDataSource {
    
    @IBOutlet weak var greyCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath) as? GreyTLCollectionViewCell else {
            return UICollectionViewCell() }
        
        return cell
    }
}
