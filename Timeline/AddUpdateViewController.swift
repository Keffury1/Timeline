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
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var updateTextView: UITextView!
    
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Methods
    
    func setupSubviews() {
        
        if color == UIColor.white {
            updateView.backgroundColor = .black
            saveButton.layer.borderColor = UIColor.black.cgColor
            saveButton.backgroundColor = .black
            
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
        
        dateLabel.textColor = .white
        
        dateTextField.backgroundColor = .white
        
        
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        if let date = update?.date {
            let dateString = dateFormatter.string(from: date)
            dateTextField.text = dateString
        }
        
        updateTextView.text = update?.update
    }
    
    func infoAlert() {
        let alertController = UIAlertController(title: "Please Enter Information", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
    
    func enterInformationAlert() {
        let alertController = UIAlertController(title: "Please Enter Information", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        if view.backgroundColor == .white {
            alertController.view.backgroundColor = .black
            alertController.view.tintColor = .white
        } else {
            alertController.view.backgroundColor = .white
            alertController.view.tintColor = self.view.backgroundColor
        }
    }
    
    func entryDeletedAlert() {
        let alertController = UIAlertController(title: "Entry Deleted", message: "✓", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        if view.backgroundColor == .white {
            alertController.view.backgroundColor = .black
            alertController.view.tintColor = .white
        } else {
            alertController.view.backgroundColor = .white
            alertController.view.tintColor = self.view.backgroundColor
        }
    }
    
    func deleteEntryAlert() {
        let alertController = UIAlertController(title: "Delete Entry", message: "Are you sure?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            guard let number = self.number else { return }
            self.mainVC?.timeline?.updates?.remove(at: number)
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
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if view.backgroundColor == .white {
            alertController.view.backgroundColor = .black
            alertController.view.tintColor = .white
        } else {
            alertController.view.backgroundColor = .white
            alertController.view.tintColor = self.view.backgroundColor
        }
    }
    
    func saveEntryAlert() {
        let alertController = UIAlertController(title: "Entry Saved", message: "✓", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        if view.backgroundColor == .white {
            alertController.view.backgroundColor = .black
            alertController.view.tintColor = .white
        } else {
            alertController.view.backgroundColor = .white
            alertController.view.tintColor = self.view.backgroundColor
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/1.955
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
        guard let mainVC = mainVC, let date = dateTextField.text, !date.isEmpty, let updateText = updateTextView.text, !updateText.isEmpty else {
            enterInformationAlert()
            return
        }
        
        if let update = update {
            update.update = updateText
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            if let date = dateFormatter.date(from: date) {
                let update = Update(date: date, update: updateText)
                mainVC.timeline?.updates?.append(update)
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
        
        self.dismiss(animated: true, completion: nil)
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
        self.view.endEditing(true)
        return false
    }
}
