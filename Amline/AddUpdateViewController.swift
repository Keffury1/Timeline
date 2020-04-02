//
//  AddUpdateViewController.swift
//  Timeline
//
//  Created by Bobby Keffury on 3/27/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import Photos
import CoreImage
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
    
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var enterDateButton: UIButton!
    
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    //MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
        setupSubviews()
        
        dateTextField.delegate = self
        titleTextField.delegate = self
        
        updateTextView.autocorrectionType = .no
        titleTextField.autocorrectionType = .no
        
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
            imageView.backgroundColor = .black
            deleteButton.backgroundColor = .black
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
            imageView.backgroundColor = color
            deleteButton.backgroundColor = color
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
        if imageView.image == nil {
            imageView.image = UIImage(systemName: "photo")
            imageView.contentMode = .scaleAspectFit
        } else {
            imageView.contentMode = .scaleToFill
        }
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.layer.cornerRadius = imageView.frame.size.height/3.0
        
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
    
    func setupAlertColor(alertController: UIAlertController, string: String?, size: CGFloat) {
        if self.traitCollection.userInterfaceStyle == .light {
            if self.view.backgroundColor == .white {
                alertController.view.backgroundColor = .white
                alertController.view.tintColor = .black
                
                let saveTimelineAlertString = NSAttributedString(string: string ?? "", attributes: [
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: size),
                    NSAttributedString.Key.foregroundColor : UIColor.black
                ])
                alertController.setValue(saveTimelineAlertString, forKey: "attributedTitle")
            } else {
                alertController.view.backgroundColor = .white
                alertController.view.tintColor = self.view.backgroundColor
                
                let saveTimelineAlertString = NSAttributedString(string: string ?? "", attributes: [
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: size),
                    NSAttributedString.Key.foregroundColor : self.view.backgroundColor!
                ])
                alertController.setValue(saveTimelineAlertString, forKey: "attributedTitle")
            }
        } else {
            alertController.view.backgroundColor = .black
            
            if self.view.backgroundColor == .black {
                alertController.view.tintColor = .white
                
                let saveTimelineAlertString = NSAttributedString(string: string ?? "", attributes: [
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: size),
                    NSAttributedString.Key.foregroundColor : UIColor.white
                ])
                alertController.setValue(saveTimelineAlertString, forKey: "attributedTitle")
            } else if self.view.backgroundColor == .white {
                alertController.view.tintColor = .black
                
                let saveTimelineAlertString = NSAttributedString(string: string ?? "", attributes: [
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: size),
                    NSAttributedString.Key.foregroundColor : self.view.backgroundColor!
                ])
                alertController.setValue(saveTimelineAlertString, forKey: "attributedTitle")
            } else {
                alertController.view.tintColor = self.view.backgroundColor
                
                let saveTimelineAlertString = NSAttributedString(string: string ?? "", attributes: [
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
    
    func addImageAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
            
            switch authorizationStatus {
            case .authorized:
                self.camera()
            case .notDetermined:
                
                PHPhotoLibrary.requestAuthorization { (status) in
                    
                    guard status == .authorized else {
                        NSLog("User did not authorize access to the camera")
                        self.presentInformationalAlertController(title: "Error", message: "In order to access the camera, you must allow this application access to it.")
                        return
                    }
                    
                    self.camera()
                }
                
            case .denied:
                self.presentInformationalAlertController(title: "Error", message: "In order to access the camera, you must allow this application access to it.")
            case .restricted:
                self.presentInformationalAlertController(title: "Error", message: "Unable to access the camera. Your device's restrictions do not allow access.")
                
            @unknown default:
                fatalError()
            }
            self.camera()
        }))
        
        alertController.addAction(UIAlertAction(title: "Upload Photo", style: .default, handler: { (_) in
            let authorizationStatus = PHPhotoLibrary.authorizationStatus()
            
            switch authorizationStatus {
            case .authorized:
                self.presentImagePickerController()
            case .notDetermined:
                
                PHPhotoLibrary.requestAuthorization { (status) in
                    
                    guard status == .authorized else {
                        NSLog("User did not authorize access to the photo library")
                        self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
                        return
                    }
                    
                    self.presentImagePickerController()
                }
                
            case .denied:
                self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
            case .restricted:
                self.presentInformationalAlertController(title: "Error", message: "Unable to access the photo library. Your device's restrictions do not allow access.")
                
            @unknown default:
                fatalError()
            }
            self.presentImagePickerController()
        }))
        
        if self.traitCollection.userInterfaceStyle == .light {
            if self.view.backgroundColor == .white {
                alertController.view.backgroundColor = .white
                alertController.view.tintColor = .black
            } else {
                alertController.view.backgroundColor = .white
                alertController.view.tintColor = self.view.backgroundColor
            }
        } else {
            alertController.view.backgroundColor = .black
            
            if self.view.backgroundColor == .black {
                alertController.view.tintColor = .white
                
            } else if self.view.backgroundColor == .white {
                alertController.view.tintColor = .black

            } else {
                alertController.view.tintColor = self.view.backgroundColor
            }
        }
        alertController.view.layer.cornerRadius = 10.0
        let height: NSLayoutConstraint = NSLayoutConstraint(item: alertController.view!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300.0)
        alertController.view.addConstraint(height)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    private func presentImagePickerController() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            presentInformationalAlertController(title: "Error", message: "The photo library is unavailable")
            return
        }
        
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            
            imagePicker.sourceType = .photoLibrary

            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if titleTextField.isEditing == true {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height/2.0
                }
            } else if updateTextView.isFirstResponder == true {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height/1.5
                }
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
                update.image = image as NSObject
            }
            
            mainVC.updatesCollectionView.reloadData()
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.long
            dateFormatter.timeStyle = .short
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
    
    @IBAction func enterDateTapped(_ sender: Any) {
        let date = datePicker.date
        
        if let update = update {
            update.date = date
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeStyle = .short
        dateTextField.text = dateFormatter.string(from: date)
        removeDatePicker()
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        guard tapGestureRecognizer.view != nil else { return }
             
        if tapGestureRecognizer.state == .ended {
             addImageAlert()
        }
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dateTextField {
            UIView.animate(withDuration: 0.5, animations: {
                self.enterDateButton.isEnabled = true
                self.datePickerView.alpha = 1
            })
        }
    }
}

extension AddUpdateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }

        imageView.image = image
        imageView.contentMode = .scaleToFill
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

