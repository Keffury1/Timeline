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
    
    var archivesVC: ArchivesViewController?
    
    var timeline: Timeline? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Outlets
    
    //Views
    @IBOutlet weak var updatesTableView: UITableView!
    @IBOutlet weak var changeColorView: UIView!
    @IBOutlet weak var toolsView: UIView!
    
    //Buttons
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
    
    //Misc
    @IBOutlet weak var titleTextField: UITextField!
    
    //MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        updateViews()
        setupTableVeiw()
        updatesTableView.reloadData()
        
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
    
    //Views
    
    func setupSubviews() {
        
        setupButton(button: redButton)
        setupButton(button: orangeButton)
        setupButton(button: yellowButton)
        setupButton(button: greenButton)
        setupButton(button: blueButton)
        setupButton(button: purpleButton)
        setupButton(button: whiteButton)
        setupButton(button: blackButton)
        
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
    
    func setupTableVeiw() {
        updatesTableView.delegate = self
        updatesTableView.dataSource = self
        
        updatesTableView.showsVerticalScrollIndicator = false
    }
    
    func setupIfWhite(color: UIColor?) {
        self.view.backgroundColor = color
        self.updatesTableView.backgroundColor = color
        self.changeColorView.backgroundColor = color
        
        self.changeColorButton.backgroundColor = color
        self.changeColorButton.layer.borderColor = UIColor.black.cgColor
        self.changeColorButton.tintColor = .black
        self.changeColorButton.layer.shadowColor = UIColor.white.cgColor
        
        self.addUpdateButton.backgroundColor = color
        self.addUpdateButton.layer.borderColor = UIColor.black.cgColor
        self.addUpdateButton.tintColor = .black
        self.addUpdateButton.layer.shadowColor = UIColor.white.cgColor
        
        self.saveButton.backgroundColor = color
        self.saveButton.layer.borderColor = UIColor.black.cgColor
        self.saveButton.tintColor = .black
        self.saveButton.layer.shadowColor = UIColor.white.cgColor
        
        self.trashButton.backgroundColor = color
        self.trashButton.layer.borderColor = UIColor.black.cgColor
        self.trashButton.tintColor = .black
        self.trashButton.layer.shadowColor = UIColor.white.cgColor
        
        self.titleTextField.textColor = .white
        self.titleTextField.backgroundColor = .black
        
        self.toolsView.backgroundColor = .black
    }
    
    func setupIfOther(color: UIColor?) {
        self.view.backgroundColor = color
        self.updatesTableView.backgroundColor = color
        self.changeColorView.backgroundColor = color
        
        self.changeColorButton.backgroundColor = color
        self.changeColorButton.layer.borderColor = UIColor.white.cgColor
        self.changeColorButton.tintColor = .white
        self.changeColorButton.layer.shadowColor = UIColor.lightGray.cgColor
        
        self.addUpdateButton.backgroundColor = color
        self.addUpdateButton.layer.borderColor = UIColor.white.cgColor
        self.addUpdateButton.tintColor = .white
        self.addUpdateButton.layer.shadowColor = UIColor.lightGray.cgColor
        
        self.saveButton.backgroundColor = color
        self.saveButton.layer.borderColor = UIColor.white.cgColor
        self.saveButton.tintColor = .white
        self.saveButton.layer.shadowColor = UIColor.lightGray.cgColor
        
        self.trashButton.backgroundColor = color
        self.trashButton.layer.borderColor = UIColor.white.cgColor
        self.trashButton.tintColor = .white
        self.trashButton.layer.shadowColor = UIColor.lightGray.cgColor
        
        self.titleTextField.textColor = color
        self.titleTextField.backgroundColor = .white
        
        self.toolsView.backgroundColor = .white
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        if let timeline = timeline {
            titleTextField.text = timeline.title
            let color = timeline.color as? UIColor
            if color == .white {
                self.setupIfWhite(color: color)
            } else {
                self.setupIfOther(color: color)
            }
        } else {
            titleTextField.text = "Timeline"
            let color = self.view.backgroundColor
            if color == .white {
                setupIfWhite(color: color)
            } else {
                setupIfOther(color: color)
            }
        }
        updatesTableView.reloadData()
    }
    
    func setupButton(button: UIButton) {
        button.layer.cornerRadius = 3.0
    }
    
    func changeColor(for button: UIButton) {
        self.view.backgroundColor = button.backgroundColor
        titleTextField.textColor = button.backgroundColor
    }
    
    //Alerts
    
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
            } else if self.view.backgroundColor == .white {
                alertController.view.tintColor = .black
                
                let saveTimelineAlertString = NSAttributedString(string: string, attributes: [
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: size),
                    NSAttributedString.Key.foregroundColor : self.view.backgroundColor!
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
                
                self.archivesVC?.archivesTableView.reloadData()
                self.dismiss(animated: true, completion: nil)
            }
        }))
        deleteTimelineAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        setupAlertColor(alertController: deleteTimelineAlert, string: "Delete Timeline", size: CGFloat(integerLiteral: 22))
        
        deleteTimelineAlert.view.layer.cornerRadius = 10.0
        
        self.present(deleteTimelineAlert, animated: true, completion: nil)
    }
    
    //Misc
    
    func saveColor(color: UIColor) {
        if let timeline = timeline {
            timeline.color = color
            
            updateViews()
            
            do {
                let moc = CoreDataStack.shared.mainContext
                try moc.save()
            } catch {
                print("Error saving color: \(error)")
            }
        } else {
            
        }
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
        saveColor(color: redButton.backgroundColor!)
        updateViews()
        updatesTableView.reloadData()
    }
    
    @IBAction func orangeButtonTapped(_ sender: Any) {
        changeColor(for: orangeButton)
        saveColor(color: orangeButton.backgroundColor!)
        updateViews()
        updatesTableView.reloadData()
    }
    
    @IBAction func yellowButtonTapped(_ sender: Any) {
        changeColor(for: yellowButton)
        saveColor(color: yellowButton.backgroundColor!)
        updateViews()
        updatesTableView.reloadData()
    }
    
    @IBAction func greenButtonTapped(_ sender: Any) {
        changeColor(for: greenButton)
        saveColor(color: greenButton.backgroundColor!)
        updateViews()
        updatesTableView.reloadData()
    }
    
    @IBAction func blueButtonTapped(_ sender: Any) {
        changeColor(for: blueButton)
        saveColor(color: blueButton.backgroundColor!)
        updateViews()
        updatesTableView.reloadData()
    }
    
    @IBAction func purpleButtonTapped(_ sender: Any) {
        changeColor(for: purpleButton)
        saveColor(color: purpleButton.backgroundColor!)
        updateViews()
        updatesTableView.reloadData()
    }
    
    @IBAction func whiteButtonTapped(_ sender: Any) {
        changeColor(for: whiteButton)
        saveColor(color: whiteButton.backgroundColor!)
        updateViews()
        updatesTableView.reloadData()
    }
    
    @IBAction func blackButtonTapped(_ sender: Any) {
        changeColor(for: blackButton)
        saveColor(color: blackButton.backgroundColor!)
        updateViews()
        updatesTableView.reloadData()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
       //Upload the timeline to messages, mail, notes, etc.
    }
    
    @IBAction func trashButtonTapped(_ sender: Any) {
        if timeline == nil {
            return
        } else {
            deleteTimelineAlert()
        }
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addUpdateSegue" {
            if let addUpdateVC = segue.destination as? AddUpdateViewController {
                addUpdateVC.color = self.view.backgroundColor
                addUpdateVC.mainVC = self
                addUpdateVC.timelineTitle = self.titleTextField.text
                changeColorView.alpha = 0
            }
        } else if segue.identifier == "updateSegue" {
            if let addUpdateVC = segue.destination as? AddUpdateViewController, let indexPath = updatesTableView.indexPathForSelectedRow, let timeline = timeline {
                addUpdateVC.color = self.view.backgroundColor
                addUpdateVC.mainVC = self
                var updates = Array(timeline.updates) as? [Update]
                updates?.sort(by: { $0.date! > $1.date! })
                addUpdateVC.update = updates?[indexPath.row]
                addUpdateVC.timelineTitle = self.titleTextField.text
                changeColorView.alpha = 0
            }
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeline?.updates.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "updateCell", for: indexPath) as? UpdatesTableViewCell else { return UITableViewCell() }
        
        guard let timeline = timeline, var updates = Array(timeline.updates) as? [Update] else { return UITableViewCell() }
        
        updates.sort(by: { $0.date! > $1.date! })
        
        let update = updates[indexPath.row]
        
        DispatchQueue.main.async {
            cell.updateLabel.text = update.title
            cell.ImageView.image = update.image as? UIImage
            
            cell.ImageView.layer.masksToBounds = false
            cell.ImageView.clipsToBounds = true
            cell.ImageView.contentMode = .scaleAspectFill
            cell.ImageView.layer.cornerRadius = 75.0
            
            let color = timeline.color as? UIColor
            
            if color == .white {
                cell.topStripe.backgroundColor = .black
                cell.bottomStripe.backgroundColor = .black
                cell.contentView.backgroundColor = .white
            } else {
                cell.topStripe.backgroundColor = .white
                cell.bottomStripe.backgroundColor = .white
                cell.contentView.backgroundColor = color
            }
            
            let totalRows = tableView.numberOfRows(inSection: indexPath.section)
            if indexPath.row == totalRows - 1 {
                cell.bottomStripe.alpha = 0
            }
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
            
            if cell.ImageView.image == nil {
                if self.view.backgroundColor == .white {
                    cell.backgroundColor = .black
                    cell.updateLabel.textColor = .white
                    cell.dateLabel.textColor = .white
                    cell.timeLabel.textColor = .white
                    cell.ImageView.backgroundColor = .black
                } else {
                    cell.backgroundColor = .white
                    cell.updateLabel.textColor = self.view.backgroundColor
                    cell.dateLabel.textColor = self.view.backgroundColor
                    cell.timeLabel.textColor = self.view.backgroundColor
                    cell.ImageView.backgroundColor = .white
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

