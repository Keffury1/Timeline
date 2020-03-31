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
    
    var timeline: Timeline? {
        didSet {
            updateViews()
            setupSubviews()
        }
    }
    
    var archivesVC: ArchivesViewController?
    
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
        
        setupSubviews()
        setupTimeline()
        setupCollectionVeiw()
        updatesCollectionView.reloadData()
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.updatesCollectionView.collectionViewLayout = layout
    }
    
    //MARK: - Methods
    
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
    
    func setupCollectionVeiw() {
        updatesCollectionView.delegate = self
        updatesCollectionView.dataSource = self
        
        updatesCollectionView.showsVerticalScrollIndicator = false
    }
    
    func setupButton(button: UIButton) {
        button.layer.cornerRadius = 3.0
    }
    
    func setupTimeline() {
        if self.timeline == nil {
            self.timeline = Timeline(color: UIColor.black, title: "Timeline")
        }
        
        DispatchQueue.main.async {
            let moc = CoreDataStack.shared.mainContext
            do {
                try moc.save()
            } catch {
                print("Error Saving Empty Timeline: \(error)")
            }
        }
    }
    
    func changeColor(for button: UIButton) {
        self.view.backgroundColor = button.backgroundColor
    }
    
    func setupAlertColor(alertController: UIAlertController, string: String, size: CGFloat) {
        if self.traitCollection.userInterfaceStyle == .light {
            if self.view.backgroundColor == .white {
                alertController.view.backgroundColor = .white
                alertController.view.tintColor = .black
                
                let saveTimelineAlertString = NSAttributedString(string: string, attributes: [
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: size),
                    NSAttributedString.Key.foregroundColor : UIColor.black
                ])
                alertController.setValue(saveTimelineAlertString, forKey: "attributedTitle")
            } else {
                alertController.view.backgroundColor = .white
                alertController.view.tintColor = self.view.backgroundColor
                
                let saveTimelineAlertString = NSAttributedString(string: string, attributes: [
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: size),
                    NSAttributedString.Key.foregroundColor : self.view.backgroundColor!
                ])
                alertController.setValue(saveTimelineAlertString, forKey: "attributedTitle")
            }
        } else {
            alertController.view.backgroundColor = .black
            
            if self.view.backgroundColor == .black {
                alertController.view.tintColor = .white
                
                let saveTimelineAlertString = NSAttributedString(string: string, attributes: [
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: size),
                    NSAttributedString.Key.foregroundColor : UIColor.white
                ])
                alertController.setValue(saveTimelineAlertString, forKey: "attributedTitle")
            } else {
                alertController.view.tintColor = self.view.backgroundColor
                
                let saveTimelineAlertString = NSAttributedString(string: string, attributes: [
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: size),
                    NSAttributedString.Key.foregroundColor : self.view.backgroundColor!
                ])
                alertController.setValue(saveTimelineAlertString, forKey: "attributedTitle")
            }
        }
    }
    
    func saveTimelineAlert() {
        
        let saveTimelineAlert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        saveTimelineAlert.addTextField { (textField) in
            textField.textAlignment = .center
            if self.traitCollection.userInterfaceStyle == .dark {
                if self.view.backgroundColor == .black {
                    textField.textColor = .white
                } else {
                    textField.textColor = self.view.backgroundColor
                }
            } else {
                textField.textColor = self.view.backgroundColor
            }
            textField.placeholder = "Title:"
            if self.timeline?.title == "Timeline" {
                textField.text = nil
            } else {
                textField.text = self.timeline?.title
            }
        }
        
        saveTimelineAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        saveTimelineAlert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { (_) in
            guard let title = saveTimelineAlert.textFields?.first?.text, let color = self.view.backgroundColor else { return }
            
            if let timeline = self.timeline {
                timeline.color = color
                timeline.title = title
            } else {
                _ = Timeline(color: color, title: title)
            }
            
            DispatchQueue.main.async {
                do {
                    let moc = CoreDataStack.shared.mainContext
                    try moc.save()
                    
                    self.timelineSavedAlert()
                } catch {
                    print("Error saving Timeline: \(error)")
                    return
                }
            }
            
        }))
        
        self.setupAlertColor(alertController: saveTimelineAlert, string: "Timeline", size: CGFloat(integerLiteral: 30))
        
        saveTimelineAlert.view.layer.cornerRadius = 10.0
        
        self.present(saveTimelineAlert, animated: true, completion: nil)
    }
    
    func timelineSavedAlert() {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
            DispatchQueue.main.async {
                self.archivesVC?.archivesTableView.reloadData()
            }
            self.dismiss(animated: true, completion: nil)
        }))
        
        
        self.setupAlertColor(alertController: alertController, string: "Timeline Saved!", size: CGFloat(integerLiteral: 22))
        
        alertController.view.layer.cornerRadius = 10.0
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteTimelineAlert() {
        let deleteTimelineAlert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        deleteTimelineAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            guard let timeline = self.timeline else { return }
            DispatchQueue.main.async {
                let moc = CoreDataStack.shared.mainContext
                moc.delete(timeline)
                
                do {
                    try moc.save()
                    self.timelineDeletedAlert()
                } catch {
                    print("Error Deleting Timeline: \(error)")
                    return
                }
            }
        }))
        deleteTimelineAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        setupAlertColor(alertController: deleteTimelineAlert, string: "Delete Timeline", size: CGFloat(integerLiteral: 22))
        
        deleteTimelineAlert.view.layer.cornerRadius = 10.0
        
        self.present(deleteTimelineAlert, animated: true, completion: nil)
    }
    
    func timelineDeletedAlert() {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
            DispatchQueue.main.async {
                self.archivesVC?.archivesTableView.reloadData()
            }
            self.dismiss(animated: true, completion: nil)
        }))
        
        
        self.setupAlertColor(alertController: alertController, string: "Timeline Deleted!", size: CGFloat(integerLiteral: 22))
        
        alertController.view.layer.cornerRadius = 10.0
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func updateViews() {
        let color = timeline?.color as? UIColor
        
        self.view.backgroundColor = color
        self.changeColorView.backgroundColor = color
        self.changeColorButton.backgroundColor = color
        self.addUpdateButton.backgroundColor = color
        self.saveButton.backgroundColor = color
        self.trashButton.backgroundColor = color
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
        saveTimelineAlert()
    }
    
    @IBAction func trashButtonTapped(_ sender: Any) {
        deleteTimelineAlert()
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
                guard let timeline = timeline, let updates = Array(timeline.updates) as? [Update] else { return }
                addUpdateVC.update = updates[first.row]
                changeColorView.alpha = 0
            }
        }
    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 325
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 300, right: 0)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 175, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeline?.updates.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "updateCell", for: indexPath) as? UpdateCollectionViewCell else { return UICollectionViewCell() }
        
        guard let timeline = timeline, var updates = Array(timeline.updates) as? [Update] else { return UICollectionViewCell() }
       
        updates.sort(by: { $0.date! > $1.date! })
        
        let update = updates[indexPath.row]
        
        cell.updateLabel.text = update.update
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        let date = update.date
        let dateString = dateFormatter.string(from: date!)
        cell.dateLabel.text = dateString
        
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
