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
        
        archivesCollectionView.delegate = self
        archivesCollectionView.dataSource = self
    }
}

extension ArchivesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchTimelinesController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timelineCell", for: indexPath) as? TimelineCollectionViewCell else { return UICollectionViewCell() }

        let timeline = fetchTimelinesController.object(at: indexPath)
        let color = UIColor(named: timeline.color!)
        cell.colorView.backgroundColor = color
        cell.titleLabel.text = timeline.title
        
        if color == .white {
            cell.stripeView.backgroundColor = .black
        } else {
            cell.stripeView.backgroundColor = .white
        }

        return cell
    }
}
