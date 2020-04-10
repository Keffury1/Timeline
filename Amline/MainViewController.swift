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
    
    var isZoomed: Bool = true
    
    //MARK: - Outlets
    
    //Views
    @IBOutlet weak var updatesTableView: UITableView!
    @IBOutlet weak var changeColorView: UIView!
    @IBOutlet weak var toolsView: UIView!
    @IBOutlet weak var cellStyleView: UIView!
    
    @IBOutlet weak var allThreeCell: UIView!
    @IBOutlet weak var allThreeTitle: UILabel!
    @IBOutlet weak var allThreeDate: UILabel!
    @IBOutlet weak var allThreeTime: UILabel!
    
    @IBOutlet weak var titleDateCell: UIView!
    @IBOutlet weak var titleDateTitle: UILabel!
    @IBOutlet weak var titleDateDate: UILabel!
    
    @IBOutlet weak var titleCell: UIView!
    @IBOutlet weak var titleCellTitle: UILabel!
    
    @IBOutlet weak var imageCell: UIView!
    @IBOutlet weak var imageCellImageView: UIImageView!
    
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
    @IBOutlet weak var editCellButton: UIButton!
    @IBOutlet weak var zoomButton: UIButton!
    
    //Misc
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet var allThreeTapRecognizer: UITapGestureRecognizer!
    @IBOutlet var titleDateTapRecognizer: UITapGestureRecognizer!
    @IBOutlet var titleTapRecognizer: UITapGestureRecognizer!
    @IBOutlet var imageTapRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var cellStyleLabel: UILabel!
    
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
        
        editCellButton.layer.cornerRadius = 10.0
        editCellButton.layer.borderWidth = 2.0
        editCellButton.addShadow()
        
        changeColorButton.layer.cornerRadius = 10.0
        changeColorButton.layer.borderWidth = 2.0
        changeColorButton.addShadow()
        
        titleTextField.layer.cornerRadius = 10.0
        
        cellStyleView.layer.cornerRadius = 20.0
        allThreeCell.layer.cornerRadius = 10.0
        allThreeCell.addShadow()
        titleDateCell.layer.cornerRadius = 10.0
        titleDateCell.addShadow()
        titleCell.layer.cornerRadius = 10.0
        titleCell.addShadow()
        imageCell.layer.cornerRadius = 10.0
        imageCell.addShadow()
    }
    
    func setupTableVeiw() {
        updatesTableView.delegate = self
        updatesTableView.dataSource = self
        
        updatesTableView.showsVerticalScrollIndicator = false
        updatesTableView.zoomScale = 0
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
        
        self.editCellButton.backgroundColor = color
        self.editCellButton.layer.borderColor = UIColor.black.cgColor
        self.editCellButton.tintColor = .black
        self.editCellButton.layer.shadowColor = UIColor.white.cgColor
        
        self.zoomButton.tintColor = .black
        
        self.titleTextField.textColor = .white
        self.titleTextField.backgroundColor = .black
        
        self.toolsView.backgroundColor = .black
        
        self.cellStyleView.backgroundColor = .white
        self.cellStyleLabel.textColor = .black
        self.allThreeCell.backgroundColor = .black
        self.titleDateCell.backgroundColor = .black
        self.titleCell.backgroundColor = .black
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
        
        self.editCellButton.backgroundColor = color
        self.editCellButton.layer.borderColor = UIColor.white.cgColor
        self.editCellButton.tintColor = .white
        self.editCellButton.layer.shadowColor = UIColor.lightGray.cgColor
        
        self.zoomButton.tintColor = .white
        
        self.titleTextField.textColor = color
        self.titleTextField.backgroundColor = .white
        
        self.toolsView.backgroundColor = .white
        
        self.cellStyleView.backgroundColor = .white
        self.cellStyleLabel.textColor = color
        self.allThreeCell.backgroundColor = color
        self.titleDateCell.backgroundColor = color
        self.titleCell.backgroundColor = color
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
    
    func zoom() {
        if isZoomed {
            isZoomed = false
            updatesTableView.reloadData()
        } else {
            isZoomed = true
            updatesTableView.reloadData()
        }
    }
    
    func editCellOn() {
        cellStyleView.alpha = 1
        allThreeTapRecognizer.isEnabled = true
        titleDateTapRecognizer.isEnabled = true
        titleTapRecognizer.isEnabled = true
        imageTapRecognizer.isEnabled = true
    }
    
    func editCellOff() {
        cellStyleView.alpha = 0
        allThreeTapRecognizer.isEnabled = false
        titleDateTapRecognizer.isEnabled = false
        titleTapRecognizer.isEnabled = false
        imageTapRecognizer.isEnabled = false
        updatesTableView.reloadData()
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
    
    @IBAction func zoomButtonTapped(_ sender: Any) {
        zoom()
    }
    
    @IBAction func editCellButtonTapped(_ sender: Any) {
        if cellStyleView.alpha == 0 {
            editCellOn()
        } else {
            editCellOff()
        }
    }
    
    @IBAction func allThreeTapped(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "1")
        UserDefaults.standard.set(false, forKey: "2")
        UserDefaults.standard.set(false, forKey: "3")
        UserDefaults.standard.set(false, forKey: "4")
        editCellOff()
    }
    
    @IBAction func titleDateTapped(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "1")
        UserDefaults.standard.set(true, forKey: "2")
        UserDefaults.standard.set(false, forKey: "3")
        UserDefaults.standard.set(false, forKey: "4")
        editCellOff()
    }
    
    @IBAction func titleTapped(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "1")
        UserDefaults.standard.set(false, forKey: "2")
        UserDefaults.standard.set(true, forKey: "3")
        UserDefaults.standard.set(false, forKey: "4")
       editCellOff()
    }
    
    @IBAction func imageViewTapped(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "1")
        UserDefaults.standard.set(false, forKey: "2")
        UserDefaults.standard.set(false, forKey: "3")
        UserDefaults.standard.set(true, forKey: "4")
       editCellOff()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isZoomed {
            return 625
        } else {
            return 250
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeline?.updates.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "updateCell", for: indexPath) as? UpdatesTableViewCell else { return UITableViewCell() }
        
        guard let timeline = timeline, var updates = Array(timeline.updates) as? [Update] else { return UITableViewCell() }
        
        updates.sort(by: { $0.date! > $1.date! })
        
        let update = updates[indexPath.row]
        
        let color = timeline.color as? UIColor
        
        if color == .white {
            cell.topStripe.backgroundColor = .black
            cell.bottomStripe.backgroundColor = .black
            cell.contentView.backgroundColor = .white
            cell.stackViewView.backgroundColor = .white
        } else {
            cell.topStripe.backgroundColor = .white
            cell.bottomStripe.backgroundColor = .white
            cell.contentView.backgroundColor = color
            cell.stackViewView.backgroundColor = color
        }
        
        let totalRows = tableView.numberOfRows(inSection: indexPath.section)
        if indexPath.row == totalRows - 1 {
            cell.bottomStripe.alpha = 0
        } else {
            cell.bottomStripe.alpha = 1
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        let date = update.date
        let dateString = dateFormatter.string(from: date!)
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        let time = update.date
        let timeString = timeFormatter.string(from: time!)
        
        if self.isZoomed {
            cell.ImageView.layer.cornerRadius = 30
        } else {
            cell.ImageView.layer.cornerRadius = 15
        }
        
        if UserDefaults.standard.bool(forKey: "1") == true {
            cell.updateLabel.text = update.title
            cell.dateLabel.text = dateString
            cell.timeLabel.text = timeString
        } else if UserDefaults.standard.bool(forKey: "2") == true {
            cell.updateLabel.text = update.title
            cell.dateLabel.text = dateString
            cell.timeLabel.text = ""
        } else if UserDefaults.standard.bool(forKey: "3") == true {
            cell.updateLabel.text = update.title
            cell.dateLabel.text = ""
            cell.timeLabel.text = ""
        } else if UserDefaults.standard.bool(forKey: "4") == true {
            cell.updateLabel.text = ""
            cell.dateLabel.text = ""
            cell.timeLabel.text = ""
        } else {
            cell.updateLabel.text = update.title
            cell.dateLabel.text = dateString
            cell.timeLabel.text = timeString
        }
        
        cell.ImageView.image = update.image as? UIImage
        
        cell.ImageView.layer.masksToBounds = false
        cell.ImageView.clipsToBounds = true
        cell.ImageView.contentMode = .scaleAspectFill
        
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

