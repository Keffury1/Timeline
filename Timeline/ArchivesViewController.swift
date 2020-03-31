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
    
    lazy var fetchedResultsController: NSFetchedResultsController<Timeline> = {
        let fetchRequest: NSFetchRequest<Timeline> = Timeline.fetchRequest()
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "color", ascending: false) ]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "color", cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()

    //MARK: - Outlets
    
    @IBOutlet weak var archivesCollectionView: UICollectionView!
    
    @IBOutlet weak var addTimelineButton: UIButton!
    
    //MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        archivesCollectionView.delegate = self
        archivesCollectionView.dataSource = self
        setupSubviews()
    }
    
    //MARK: - Methods
    
    func setupSubviews() {
        addTimelineButton.layer.borderColor = UIColor.black.cgColor
        addTimelineButton.layer.borderWidth = 3.0
        addTimelineButton.layer.cornerRadius = 10.0
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTimelineSegue" {
            if let mainVC = segue.destination as? MainViewController {
                mainVC.archivesVC = self
            }
        } else if segue.identifier == "timelineSegue" {
            if let mainVC = segue.destination as? MainViewController, let indexPath = archivesCollectionView.indexPathsForSelectedItems {
                mainVC.archivesVC = self
                mainVC.timeline = fetchedResultsController.fetchedObjects![indexPath.first!.row]
            }
        }
    }
}

extension ArchivesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timelineCell", for: indexPath) as? TimelineCollectionViewCell else { return UICollectionViewCell() }

        let timeline = fetchedResultsController.object(at: indexPath)
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
