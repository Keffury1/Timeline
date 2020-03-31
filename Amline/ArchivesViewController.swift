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
    @IBOutlet weak var editTableViewButton: UIButton!
    
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
        addTimelineButton.layer.borderWidth = 2.0
        addTimelineButton.layer.cornerRadius = 10.0
        
        editTableViewButton.layer.borderColor = UIColor.black.cgColor
        editTableViewButton.layer.borderWidth = 2.0
        editTableViewButton.layer.cornerRadius = 10.0
    
        archivesTableView.backgroundColor = .white
    }
    
    //MARK: - Actions
    
    @IBAction func editTableViewButtonTapped(_ sender: Any) {
        if archivesTableView.isEditing == true {
            archivesTableView.isEditing = false
        } else {
            archivesTableView.isEditing = true
        }
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
        let numberOfObjects = fetchedResultsController.sections?[section].numberOfObjects
        if numberOfObjects == 0 {
            editTableViewButton.alpha = 0
            editTableViewButton.isEnabled = false
        } else {
            editTableViewButton.alpha = 1
            editTableViewButton.isEnabled = true
        }
        return  numberOfObjects ?? 0
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
        cell.colorView.layer.borderWidth = 1.5
        
        cell.colorView.layer.cornerRadius = 10.0

        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let timeline = fetchedResultsController.object(at: indexPath)
            let moc = CoreDataStack.shared.mainContext
            moc.delete(timeline)
            
            do {
                try moc.save()
                archivesTableView.reloadData()
            } catch {
                print("Error deleting timeline from tableView: \(error)")
                return
            }
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard var timelines = self.fetchedResultsController.fetchedObjects else { return }
        let movedObject = timelines[sourceIndexPath.row]
        timelines.remove(at: sourceIndexPath.row)
        timelines.insert(movedObject, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
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

