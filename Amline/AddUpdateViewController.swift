//
//  AddUpdateViewController.swift
//  Timeline
//
//  Created by Bobby Keffury on 3/27/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddUpdateViewController: UIViewController {

    //MARK: - Properties
    
    var mainVC: MainViewController?
    var color: UIColor?
    var number: Int?
    
    var update: Update? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Outlets
    
    @IBOutlet weak var updateView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var updateTextView: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var calendarButton: UIButton!
    
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var enterDateButton: UIButton!
    
    //MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
        setupSubviews()
        dateTextField.delegate = self
        
        titleTextField.delegate = self
        updateTextView.autocorrectionType = .no
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Methods
    
    func setupSubviews() {
        
        if color == UIColor.white {
            updateView.backgroundColor = .black
            saveButton.layer.borderColor = UIColor.black.cgColor
            saveButton.backgroundColor = .black
            
            titleTextField.textColor = .black
            dateTextField.textColor = .black
            updateTextView.textColor = .black
            deleteButton.backgroundColor = .black
            calendarButton.backgroundColor = .clear
            calendarButton.tintColor = .black
            enterDateButton.backgroundColor = .black
            datePickerView.backgroundColor = color
            datePicker.setValue(UIColor.black, forKeyPath: "textColor")
            datePicker.setValue(false, forKeyPath: "highlightsToday")
        } else {
            updateView.backgroundColor = color
            saveButton.titleLabel?.textColor = color
            saveButton.layer.borderColor = UIColor.white.cgColor
            
            titleTextField.textColor = color
            dateTextField.textColor = color
            updateTextView.textColor = color
            deleteButton.backgroundColor = color
            calendarButton.backgroundColor = color
            calendarButton.tintColor = .white
            enterDateButton.backgroundColor = color
            datePickerView.backgroundColor = color
            datePicker.setValue(UIColor.white, forKeyPath: "textColor")
            datePicker.setValue(false, forKeyPath: "highlightsToday")
        }
        
        updateView.layer.borderColor = UIColor.white.cgColor
        
        titleLabel.textColor = .white
        titleTextField.backgroundColor = .white
        
        dateLabel.textColor = .white
        dateTextField.backgroundColor = .white
        
        imageView.tintColor = .white
        imageView.backgroundColor = color
        imageView.image = UIImage(systemName: "photo")
        
        updateLabel.textColor = .white
        updateTextView.backgroundColor = .white
        
        view.backgroundColor = color
        
        updateView.layer.borderWidth = 3.0
        updateView.layer.cornerRadius = 10.0
       
        dateTextField.layer.cornerRadius = 10.0
        
        updateTextView.layer.cornerRadius = 10.0
        
        saveButton.layer.borderWidth = 3.0
        saveButton.layer.cornerRadius = 10.0
        
        deleteButton.layer.cornerRadius = 10.0
        if update == nil {
            deleteButton.alpha = 0
        } else {
            deleteButton.alpha = 1
        }
        
        datePickerView.layer.cornerRadius = 10.0
        enterDateButton.layer.cornerRadius = 5.0
        calendarButton.layer.cornerRadius = 5.0
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        titleTextField.text = update?.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        if let date = update?.date {
            let dateString = dateFormatter.string(from: date)
            dateTextField.text = dateString
        }
        
        updateTextView.text = update?.update
        
        imageView.image = update?.image as? UIImage
    }
    
    func presentDatePicker() {
        UIView.animate(withDuration: 0.5, animations: {
            self.datePickerView.alpha = 1
        })
        enterDateButton.isEnabled = true
    }
    
    func removeDatePicker() {
        UIView.animate(withDuration: 0.5, animations: {
            self.datePickerView.alpha = 0
        })
        enterDateButton.isEnabled = false
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
    
    func saveEntryAlert() {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        
        self.setupAlertColor(alertController: alertController, string: "Entry Saved!", size: CGFloat(integerLiteral: 22))
        
        alertController.view.layer.cornerRadius = 10.0
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func enterInformationAlert() {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        
        self.setupAlertColor(alertController: alertController, string: "Please Enter Information", size: CGFloat(integerLiteral: 22))
        
        alertController.view.layer.cornerRadius = 10.0
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteEntryAlert() {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            guard let update = self.update else { return }
            self.mainVC?.timeline?.removeFromUpdates(update)
            DispatchQueue.main.async {
                let moc = CoreDataStack.shared.mainContext
                do {
                    try moc.save()
                    self.entryDeletedAlert()
                } catch {
                    print("Error Deleting Entry : \(error)")
                    return
                }
            }
            self.mainVC?.updatesCollectionView.reloadData()
        }))
        
        
        self.setupAlertColor(alertController: alertController, string: "Delete Entry", size: CGFloat(integerLiteral: 22))
        
        alertController.view.layer.cornerRadius = 10.0
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func entryDeletedAlert() {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.setupAlertColor(alertController: alertController, string: "Entry Deleted!", size: CGFloat(integerLiteral: 22))
        
        alertController.view.layer.cornerRadius = 10.0
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/1.5
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    //MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let mainVC = mainVC, let date = dateTextField.text, !date.isEmpty, let updateText = updateTextView.text, !updateText.isEmpty, let titleText = titleTextField.text, !titleText.isEmpty, let image = imageView.image else {
            enterInformationAlert()
            return
        }
        
        if let update = update {
            update.title = titleText
            update.update = updateText
            
            if image == UIImage(systemName: "photo") {
                update.image = nil
            } else {
                update.image = image
            }
            
            mainVC.updatesCollectionView.reloadData()
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            if let date = dateFormatter.date(from: date) {
                if image == UIImage(systemName: "photo") {
                    let update = Update(title: titleText, date: date, update: updateText, image: nil)
                    mainVC.timeline?.addToUpdates(update)
                } else {
                    let update = Update(title: titleText, date: date, update: updateText, image: image)
                    mainVC.timeline?.addToUpdates(update)
                }
                
                mainVC.updatesCollectionView.reloadData()
            }
        }
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
            saveEntryAlert()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        deleteEntryAlert()
    }
    
    @IBAction func calendarButtonTapped(_ sender: Any) {
        if datePickerView.alpha == 0 {
            presentDatePicker()
        } else {
            removeDatePicker()
        }
    }
    
    @IBAction func enterDateTapped(_ sender: Any) {
        let date = datePicker.date
        
        if let update = update {
            update.date = date
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateTextField.text = dateFormatter.string(from: date)
        removeDatePicker()
    }
    
}

extension AddUpdateViewController: UITextFieldDelegate {
    
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
