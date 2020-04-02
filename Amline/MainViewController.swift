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
        }
    }
    
    var archivesVC: ArchivesViewController?
    
    //MARK: - Outlets
    
    @IBOutlet weak var updatesCollectionView: UICollectionView!
    @IBOutlet weak var stripeView: UIView!
    @IBOutlet weak var changeColorView: UIView!
    @IBOutlet weak var changeColorButton: UIButton!
    @IBOutlet weak var addUpdateButton: UIButton!
    
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var whiteButton: UIButton!
    @IBOutlet weak var blackButton: UIButton!
    

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    
    @IBOutlet weak var toolsView: UIView!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    
    //MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        updateViews()
        setupCollectionVeiw()
        updatesCollectionView.reloadData()
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.updatesCollectionView.collectionViewLayout = layout
        
        titleTextField.delegate = self
        titleTextField.autocorrectionType = .no
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        guard let color = self.view.backgroundColor, let title = titleTextField.text else { return }
        
        if let timeline = timeline {
            timeline.color = color
            timeline.title = title
        } else {
            timeline = Timeline(color: color, title: title)
        }
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
            
        } catch {
            print("Error saving timeline: \(error)")
        }
    }
    
    //MARK: - Methods
    
    func setupSubviews() {
        
        setupButton(button: blackButton)
        setupButton(button: blueButton)
        setupButton(button: purpleButton)
        setupButton(button: orangeButton)
        setupButton(button: yellowButton)
        setupButton(button: greenButton)
        setupButton(button: redButton)
        setupButton(button: whiteButton)
        
        addUpdateButton.layer.cornerRadius = 10.0
        addUpdateButton.layer.borderWidth = 2.0
        addUpdateButton.addShadow()
        
        saveButton.layer.cornerRadius = 10.0
        saveButton.layer.borderWidth = 2.0
        saveButton.addShadow()
        
        trashButton.layer.cornerRadius = 10.0
        trashButton.layer.borderWidth = 2.0
        trashButton.addShadow()
        
        changeColorButton.layer.cornerRadius = 10.0
        changeColorButton.layer.borderWidth = 2.0
        changeColorButton.addShadow()
        
        titleTextField.layer.cornerRadius = 10.0
    }
    
    func setupCollectionVeiw() {
        updatesCollectionView.delegate = self
        updatesCollectionView.dataSource = self
        
        updatesCollectionView.showsVerticalScrollIndicator = false
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        if let timeline = timeline {
            titleTextField.text = timeline.title
            let color = timeline.color as? UIColor
            if color == .white {
                self.view.backgroundColor = color
                self.changeColorView.backgroundColor = color
                
                self.changeColorButton.backgroundColor = color
                self.changeColorButton.layer.borderColor = UIColor.black.cgColor
                self.changeColorButton.tintColor = .black
                
                self.addUpdateButton.backgroundColor = color
                self.addUpdateButton.layer.borderColor = UIColor.black.cgColor
                self.addUpdateButton.tintColor = .black
                
                self.saveButton.backgroundColor = color
                self.saveButton.layer.borderColor = UIColor.black.cgColor
                self.saveButton.tintColor = .black
                
                self.trashButton.backgroundColor = color
                self.trashButton.layer.borderColor = UIColor.black.cgColor
                self.trashButton.tintColor = .black
                
                self.titleTextField.textColor = .white
                self.titleTextField.backgroundColor = .black
                
                self.toolsView.backgroundColor = .black
                
                self.stripeView.backgroundColor = .black
            } else {
                self.view.backgroundColor = color
                self.changeColorView.backgroundColor = color
                
                self.changeColorButton.backgroundColor = color
                self.changeColorButton.layer.borderColor = UIColor.white.cgColor
                self.changeColorButton.tintColor = .white
                
                self.addUpdateButton.backgroundColor = color
                self.addUpdateButton.layer.borderColor = UIColor.white.cgColor
                self.addUpdateButton.tintColor = .white
                
                self.saveButton.backgroundColor = color
                self.saveButton.layer.borderColor = UIColor.white.cgColor
                self.saveButton.tintColor = .white
                
                self.trashButton.backgroundColor = color
                self.trashButton.layer.borderColor = UIColor.white.cgColor
                self.trashButton.tintColor = .white
                
                self.titleTextField.textColor = color
                self.titleTextField.backgroundColor = .white
                
                self.toolsView.backgroundColor = .white
                
                self.stripeView.backgroundColor = .white
            }
        } else {
            titleTextField.text = "Timeline"
            self.view.backgroundColor = .black
            self.changeColorView.backgroundColor = .black
            self.changeColorButton.backgroundColor = .black
            self.addUpdateButton.backgroundColor = .black
            self.saveButton.backgroundColor = .black
            self.trashButton.backgroundColor = .black
            self.titleTextField.textColor = .black
        }
        updatesCollectionView.reloadData()
    }
    
    func setupButton(button: UIButton) {
        button.layer.cornerRadius = 3.0
    }
    
    func changeColor(for button: UIButton) {
        self.view.backgroundColor = button.backgroundColor
        titleTextField.textColor = button.backgroundColor
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
    
    @IBAction func redButtonTapped(_ sender: Any) {
        changeColor(for: redButton)
        setupSubviews()
        updatesCollectionView.reloadData()
    }
    
    @IBAction func orangeButtonTapped(_ sender: Any) {
        changeColor(for: orangeButton)
        setupSubviews()
        updatesCollectionView.reloadData()
    }
    
    @IBAction func yellowButtonTapped(_ sender: Any) {
        changeColor(for: yellowButton)
        setupSubviews()
        updatesCollectionView.reloadData()
    }
    
    @IBAction func greenButtonTapped(_ sender: Any) {
        changeColor(for: greenButton)
        setupSubviews()
        updatesCollectionView.reloadData()
    }
    
    @IBAction func blueButtonTapped(_ sender: Any) {
        changeColor(for: blueButton)
        setupSubviews()
        updatesCollectionView.reloadData()
    }
    
    @IBAction func purpleButtonTapped(_ sender: Any) {
        changeColor(for: purpleButton)
        setupSubviews()
        updatesCollectionView.reloadData()
    }
    
    @IBAction func whiteButtonTapped(_ sender: Any) {
        changeColor(for: whiteButton)
        setupSubviews()
        updatesCollectionView.reloadData()
    }
    
    @IBAction func blackButtonTapped(_ sender: Any) {
        changeColor(for: blackButton)
        setupSubviews()
        updatesCollectionView.reloadData()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
       //Upload the timeline to messages, mail, notes, etc.
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
            if let addUpdateVC = segue.destination as? AddUpdateViewController, let indexPath = updatesCollectionView.indexPathForItem(at: updatesCollectionView.convert(CGPoint(), to: updatesCollectionView)) {
                addUpdateVC.color = self.view.backgroundColor
                addUpdateVC.mainVC = self
                guard let timeline = timeline, let updates = Array(timeline.updates) as? [Update] else { return }
                addUpdateVC.update = updates[indexPath.row]
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
        return CGSize(width: 200, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeline?.updates.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "updateCell", for: indexPath) as? UpdateCollectionViewCell else { return UICollectionViewCell() }
        
        guard let timeline = timeline, var updates = Array(timeline.updates) as? [Update] else { return UICollectionViewCell() }
       
        updates.sort(by: { $0.date! > $1.date! })
        
        let update = updates[indexPath.row]
        
        DispatchQueue.main.async {
            cell.updateLabel.text = update.title
            cell.imageView.image = update.image as? UIImage
            
            cell.imageView.layer.masksToBounds = false
            cell.imageView.clipsToBounds = true
            cell.imageView.contentMode = .scaleAspectFill
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        let date = update.date
        let dateString = dateFormatter.string(from: date!)
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        let time = update.date
        let timeString = timeFormatter.string(from: time!)
        
        DispatchQueue.main.async {
            cell.dateLabel.text = dateString
            cell.timeLabel.text = timeString
            
            cell.layer.cornerRadius = 100.0
            
            if cell.imageView.image == nil {
                if self.view.backgroundColor == .white {
                    cell.backgroundColor = .black
                    cell.updateLabel.textColor = .white
                    cell.dateLabel.textColor = .white
                    cell.timeLabel.textColor = .white
                } else {
                    cell.backgroundColor = .white
                    cell.updateLabel.textColor = self.view.backgroundColor
                    cell.dateLabel.textColor = self.view.backgroundColor
                    cell.timeLabel.textColor = self.view.backgroundColor
                }
            } else {
                cell.updateLabel.textColor = .white
                cell.dateLabel.textColor = .white
                cell.timeLabel.textColor = .white
            }
            
        }
        
        return cell
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            self.view.endEditing(true)
            return false
        } else {
            self.view.endEditing(true)
            return false
        }
    }
}

