//
//  ArchivesViewController.swift
//  Timeline
//
//  Created by Bobby Keffury on 3/28/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit
import CoreData

class ArchivesViewController: UIViewController, NSFetchedResultsControllerDelegate {

    //MARK: - Properties
    
    private var fetchTimelinesController: NSFetchedResultsController<Timeline> {
        
        let fetchRequest: NSFetchRequest<Timeline> = Timeline.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "color", ascending: false)]
        let moc = CoreDataStack.shared.mainContext
        
        let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchResultsController.delegate = self
        
        do {
            try fetchResultsController.performFetch()
        } catch {
            fatalError("Failed to fetch timelines: \(error)")
        }
        return fetchResultsController
    }
    
    //MARK: - Outlets
    
    @IBOutlet weak var archivesCollectionView: UICollectionView!
    
    //MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    
    //MARK: - Methods
    
    func setupSubviews() {
        
    }
    
    //MARK: - Actions
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

extension ArchivesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.cellForItem(at: indexPath) as? BlackCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
}
