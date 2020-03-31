//
//  ArchivesViewController.swift
//  Timeline
//
//  Created by Bobby Keffury on 3/28/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit
import CoreData

class ArchivesViewController: UIViewController {

    //MARK: - Properties
    
    lazy var fetchedResultsController: NSFetchedResultsController<Timeline> = {
        let fetchRequest: NSFetchRequest<Timeline> = Timeline.fetchRequest()
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "title", ascending: true) ]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "title", cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()

    //MARK: - Outlets
    
    @IBOutlet weak var archivesTableView: UITableView!
    
    
    @IBOutlet weak var addTimelineButton: UIButton!
    
    //MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        archivesTableView.delegate = self
        archivesTableView.dataSource = self
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
            if let mainVC = segue.destination as? MainViewController, let indexPath = archivesTableView.indexPathForSelectedRow {
                mainVC.archivesVC = self
                mainVC.timeline = fetchedResultsController.object(at: indexPath)
            }
        }
    }
}

extension ArchivesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "timelineCell", for: indexPath) as? TimelineTableViewCell else { return UITableViewCell() }
        
        let timeline = fetchedResultsController.object(at: indexPath)
        let color = timeline.color as? UIColor
        cell.colorView.backgroundColor = color
        cell.titleLabel.text = timeline.title
        
        if color == .white {
                cell.stripeView.backgroundColor = .black
        } else {
                cell.stripeView.backgroundColor = .white
        }
        
        cell.colorView.layer.borderColor = UIColor.black.cgColor
        cell.colorView.layer.borderWidth = 3.0
        
        cell.colorView.layer.cornerRadius = 10.0

        return cell
    }
}

extension ArchivesViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        archivesTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        archivesTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            archivesTableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            archivesTableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            archivesTableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            archivesTableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            archivesTableView.moveRow(at: oldIndexPath, to: newIndexPath)
        case .delete:
            guard let indexPath = indexPath else { return }
            archivesTableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
    
}

