//
//  MainViewController.swift
//  Timeline
//
//  Created by Bobby Keffury on 3/27/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, NSFetchedResultsControllerDelegate {

    //MARK: - Properties
    
    private let spacing: CGFloat = 100.0
    
    var fetchUpdatesController: NSFetchedResultsController<Update> {
        
        let fetchRequest: NSFetchRequest<Update> = Update.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        let moc = CoreDataStack.shared.mainContext
        
        let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchResultsController.delegate = self
        
        do {
            try fetchResultsController.performFetch()
        } catch {
            fatalError("Failed to fetch updates: \(error)")
        }
        return fetchResultsController
    }
    
    var timeline: Timeline?
    
    //MARK: - Outlets
    
    @IBOutlet weak var updatesCollectionView: UICollectionView!
    @IBOutlet weak var stripeView: UIView!
    @IBOutlet weak var changeColorView: UIView!
    @IBOutlet weak var changeColorButton: UIButton!
    @IBOutlet weak var addUpdateButton: UIButton!
    
    //Colors
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var goldButton: UIButton!
    @IBOutlet weak var mintButton: UIButton!
    @IBOutlet weak var navyButton: UIButton!
    @IBOutlet weak var maroonButton: UIButton!
    @IBOutlet weak var oliveButton: UIButton!
    @IBOutlet weak var pinkButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var greyButton: UIButton!
    @IBOutlet weak var whiteButton: UIButton!
    

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    
    //MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionVeiw()
        setupSubviews()
        updatesCollectionView.reloadData()
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.updatesCollectionView.collectionViewLayout = layout
    }
    
    //MARK: - Methods
    
    func setupCollectionVeiw() {
        updatesCollectionView.delegate = self
        updatesCollectionView.dataSource = self
        
        updatesCollectionView.showsVerticalScrollIndicator = false
    }
    
    func setupButton(button: UIButton) {
        button.layer.cornerRadius = 3.0
    }
    
    func setupSubviews() {
        
        if view.backgroundColor == .white {
            stripeView.backgroundColor = .black
            
            blackButton.layer.borderColor = UIColor.white.cgColor
            blackButton.layer.borderWidth = 0.5
            
            changeColorButton.backgroundColor = .black
            addUpdateButton.backgroundColor = .black
            saveButton.backgroundColor = .black
            trashButton.backgroundColor = .black
            
            
            changeColorButton.layer.borderColor = UIColor.black.cgColor
            changeColorButton.layer.borderWidth = 2.0
        } else {
            stripeView.backgroundColor = .white
            
            whiteButton.layer.borderColor = UIColor.black.cgColor
            whiteButton.layer.borderWidth = 0.5
            
            changeColorButton.backgroundColor = self.view.backgroundColor
            addUpdateButton.backgroundColor = self.view.backgroundColor
            saveButton.backgroundColor = self.view.backgroundColor
            trashButton.backgroundColor = self.view.backgroundColor
            
            changeColorButton.layer.borderColor = UIColor.white.cgColor
            changeColorButton.layer.borderWidth = 2.0
        }
        
        setupButton(button: blackButton)
        setupButton(button: goldButton)
        setupButton(button: mintButton)
        setupButton(button: navyButton)
        setupButton(button: maroonButton)
        setupButton(button: oliveButton)
        setupButton(button: pinkButton)
        setupButton(button: purpleButton)
        setupButton(button: greyButton)
        setupButton(button: whiteButton)
        setupButton(button: changeColorButton)
        
        addUpdateButton.layer.cornerRadius = 10.0
        addUpdateButton.layer.borderColor = UIColor.white.cgColor
        addUpdateButton.layer.borderWidth = 2.0
        
        saveButton.layer.cornerRadius = 10.0
        saveButton.layer.borderColor = UIColor.white.cgColor
        saveButton.layer.borderWidth = 2.0
        
        trashButton.layer.cornerRadius = 10.0
        trashButton.layer.borderColor = UIColor.white.cgColor
        trashButton.layer.borderWidth = 2.0
        
        changeColorView.backgroundColor = self.view.backgroundColor
    }
    
    func changeColor(for button: UIButton) {
        self.view.backgroundColor = button.backgroundColor
    }
    
    //MARK: - Actions
    
    @IBAction func changeColorButtonTapped(_ sender: Any) {
        if self.changeColorView.alpha == 0 {
            UIView.animate(withDuration: 1.0) {
                self.changeColorView.alpha = 1
            }
        } else if self.changeColorView.alpha == 1 {
            UIView.animate(withDuration: 0.5) {
                self.changeColorView.alpha = 0
            }
        }
    }
    
    @IBAction func blackButtonTapped(_ sender: Any) {
        changeColor(for: blackButton)
        setupSubviews()
        updatesCollectionView.reloadData()
    }
    
    @IBAction func goldButtonTapped(_ sender: Any) {
        changeColor(for: goldButton)
        setupSubviews()
        updatesCollectionView.reloadData()
    }
    
    @IBAction func mintButtonTapped(_ sender: Any) {
        changeColor(for: mintButton)
        setupSubviews()
        updatesCollectionView.reloadData()
    }
    
    @IBAction func navyButtonTapped(_ sender: Any) {
        changeColor(for: navyButton)
        setupSubviews()
        updatesCollectionView.reloadData()
    }
    
    @IBAction func maroonButtonTapped(_ sender: Any) {
        changeColor(for: maroonButton)
        setupSubviews()
        updatesCollectionView.reloadData()
    }
    
    @IBAction func oliveButtonTapped(_ sender: Any) {
        changeColor(for: oliveButton)
        setupSubviews()
        updatesCollectionView.reloadData()
    }
    
    @IBAction func pinkButtonTapped(_ sender: Any) {
        changeColor(for: pinkButton)
        setupSubviews()
        updatesCollectionView.reloadData()
    }
    
    @IBAction func purpleButtonTapped(_ sender: Any) {
        changeColor(for: purpleButton)
        setupSubviews()
        updatesCollectionView.reloadData()
    }
    
    @IBAction func greyButtonTapped(_ sender: Any) {
        changeColor(for: greyButton)
        setupSubviews()
        updatesCollectionView.reloadData()
    }
    
    @IBAction func whiteButtonTapped(_ sender: Any) {
        changeColor(for: whiteButton)
        setupSubviews()
        updatesCollectionView.reloadData()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    
    @IBAction func trashButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete This Timeline?", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes, Delete", style: .destructive, handler: { (_) in
            guard let timeline = self.timeline else { return }

            DispatchQueue.main.async {
                let moc = CoreDataStack.shared.mainContext
                moc.delete(timeline)

                do {
                    try moc.save()
                    self.updatesCollectionView.reloadData()
                } catch {
                    moc.reset()
                    print("Error saving managed object context: \(error)")
                }
            }
            
            self.dismiss(animated: true, completion: nil)
        }))
        
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        alertController.view.tintColor = .white
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addUpdateSegue" {
            if let addUpdateVC = segue.destination as? AddUpdateViewController {
                addUpdateVC.color = self.view.backgroundColor
                addUpdateVC.mainVC = self
                changeColorView.alpha = 0
            }
        } else if segue.identifier == "detailSegue" {
            if let addUpdateVC = segue.destination as? AddUpdateViewController, let indexPath = updatesCollectionView.indexPathsForSelectedItems, let first = indexPath.first {
                addUpdateVC.color = self.view.backgroundColor
                addUpdateVC.mainVC = self
                addUpdateVC.update = fetchUpdatesController.object(at: first)
                changeColorView.alpha = 0
            }
        }
    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 400
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 400, right: 0)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 175, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchUpdatesController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "updateCell", for: indexPath) as? UpdateCollectionViewCell else { return UICollectionViewCell() }
        
        let update = fetchUpdatesController.object(at: indexPath)
        
        cell.updateLabel.text = update.update
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        if let date = update.date {
            let dateString = dateFormatter.string(from: date)
            cell.dateLabel.text = dateString
        }
        cell.layer.cornerRadius = 10.0
        
        if view.backgroundColor == .white {
            cell.backgroundColor = .black
            cell.updateLabel.textColor = .white
            cell.dateLabel.textColor = .white
        } else {
            cell.backgroundColor = .white
            cell.updateLabel.textColor = view.backgroundColor
            cell.dateLabel.textColor = view.backgroundColor
        }
        
        return cell
    }
}

