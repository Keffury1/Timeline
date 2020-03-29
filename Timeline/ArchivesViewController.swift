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
    
    let colors: [[Timeline]] = []
    var storedOffsets = [Int: CGFloat]()
    
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
    
    @IBOutlet weak var timelinesTableView: UITableView!
    
    //MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    
    //MARK: - Methods
    
    func setupSubviews() {
        timelinesTableView.dataSource = self
    }
    
    //MARK: - Actions
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

extension ArchivesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell", for: indexPath)
        
        return cell
    }
    
    private func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let tableViewCell = cell as? ColorTableViewCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    private func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

        guard let tableViewCell = cell as? ColorTableViewCell else { return }

        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
}

extension ArchivesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timelineCell", for: indexPath) as? TimelineCollectionViewCell else { return UICollectionViewCell() }

        let timeline = fetchTimelinesController.object(at: indexPath)
        
        let color = UIColor(named: timeline.color!)
        cell.colorView.backgroundColor = color
        cell.titleLabel.text = timeline.title!
        
        if color == .white {
            cell.stripeView.backgroundColor = .black
        } else {
            cell.stripeView.backgroundColor = .white
        }

        return cell
    }
}
