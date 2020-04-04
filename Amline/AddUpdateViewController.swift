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
    
    var update: Update? {
        didSet {
            updateViews()
        }
    }
    var timelineTitle: String?
    
    //MARK: - Outlets
    
    //Views
    @IBOutlet weak var updateView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateView: UIView!
    
    //Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    
    //Buttons
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var enterDateButton: UIButton!
    
    //TextFields/Views
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var updateTextView: UITextView!
    
    
    //Misc
    @IBOutlet var dateTapRecognizer: UITapGestureRecognizer!
    @IBOutlet var imageTapRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    
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
    
    //Views
    func setupSubviews() {
        
        if color == UIColor.white {
            updateView.backgroundColor = .black
            
            saveButton.layer.borderColor = UIColor.white.cgColor
            saveButton.backgroundColor = .black
            saveButton.tintColor = .white
            
            deleteButton.layer.borderColor = UIColor.white.cgColor
            deleteButton.backgroundColor = .black
            deleteButton.tintColor = .white
            
            titleTextField.textColor = .black
            dateTextField.textColor = .black
            updateTextView.textColor = .black
            imageView.backgroundColor = .black
            dateView.backgroundColor = .white
            
            datePicker.setValue(UIColor.black, forKeyPath: "textColor")
            datePicker.setValue(false, forKeyPath: "highlightsToday")
            datePicker.subviews[0].subviews[1].isHidden = true
            datePicker.subviews[0].subviews[2].isHidden = true
            
            timePicker.setValue(UIColor.black, forKeyPath: "textColor")
            timePicker.setValue(false, forKeyPath: "highlightsToday")
            timePicker.subviews[0].subviews[1].isHidden = true
            timePicker.subviews[0].subviews[2].isHidden = true
            
            enterDateButton.tintColor = .black
        } else {
            updateView.backgroundColor = color
            
            saveButton.layer.borderColor = UIColor.white.cgColor
            saveButton.backgroundColor = color
            saveButton.tintColor = .white
            
            deleteButton.layer.borderColor = UIColor.white.cgColor
            deleteButton.backgroundColor = color
            deleteButton.tintColor = .white
            
            titleTextField.textColor = color
            dateTextField.textColor = color
            updateTextView.textColor = color
            imageView.backgroundColor = color
            dateView.backgroundColor = color
            
            datePicker.setValue(UIColor.white, forKeyPath: "textColor")
            datePicker.setValue(false, forKeyPath: "highlightsToday")
            datePicker.subviews[0].subviews[1].isHidden = true
            datePicker.subviews[0].subviews[2].isHidden = true
            
            timePicker.setValue(UIColor.white, forKeyPath: "textColor")
            timePicker.setValue(false, forKeyPath: "highlightsToday")
            timePicker.subviews[0].subviews[1].isHidden = true
            timePicker.subviews[0].subviews[2].isHidden = true
            
            enterDateButton.tintColor = .white
        }
        
        view.backgroundColor = color
        
        updateView.layer.borderColor = UIColor.white.cgColor
        updateView.layer.borderWidth = 3.0
        updateView.layer.cornerRadius = 10.0
        updateView.addShadow()
        
        titleLabel.textColor = .white
        titleTextField.backgroundColor = .white
        
        dateLabel.textColor = .white
        dateTextField.backgroundColor = .white
        dateTextField.layer.cornerRadius = 10.0
        
        updateLabel.textColor = .white
        updateTextView.backgroundColor = .white
        updateTextView.layer.cornerRadius = 10.0
        
        imageView.tintColor = .white
        if imageView.image == nil {
            imageView.image = UIImage(systemName: "photo")
            imageView.contentMode = .scaleAspectFit
        } else {
            imageView.contentMode = .scaleToFill
        }
        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        imageView.layer.cornerRadius = 20.0
        
        saveButton.layer.borderWidth = 2.0
        saveButton.layer.cornerRadius = 10.0
        saveButton.addShadow()
        
        deleteButton.layer.borderWidth = 2.0
        deleteButton.layer.cornerRadius = 10.0
        deleteButton.addShadow()
        
        dateView.layer.cornerRadius = 10.0
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        titleTextField.text = update?.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeStyle = .short
        if let date = update?.date {
            let dateString = dateFormatter.string(from: date)
            dateTextField.text = dateString
        }
        
        updateTextView.text = update?.update
        
        imageView.image = update?.image as? UIImage
    }
    
    //Alerts
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
    
    func enterInformationAlert() {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        
        self.setupAlertColor(alertController: alertController, string: "Please Enter Information", size: CGFloat(integerLiteral: 22))
        
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
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Pickers
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
    
    private func checkDatePicker() {
        UIView.animate(withDuration: 1.0, animations: {
            if self.dateView.alpha == 0 {
                self.dateView.alpha = 1
                self.enterDateButton.isEnabled = true
            } else {
                self.dateView.alpha = 0
                self.enterDateButton.isEnabled = false
            }
        })
    }
    
    //Misc
    func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func combineDateAndTime(date: Date, time: Date) -> Date {

        let calendar = NSCalendar.current

        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)

        var components = DateComponents()
        components.year = dateComponents.year
        components.month = dateComponents.month
        components.day = dateComponents.day
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute
        components.second = timeComponents.second

        return calendar.date(from: components)!
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if titleTextField.isEditing == true {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= 0
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
        guard let mainVC = mainVC, let date = dateTextField.text, !date.isEmpty, let updateText = updateTextView.text, !updateText.isEmpty, let titleText = titleTextField.text, !titleText.isEmpty, let image = imageView.image, let timelineTitle = self.timelineTitle else {
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
            
            mainVC.updatesTableView.reloadData()
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.long
            dateFormatter.timeStyle = .short
            if let date = dateFormatter.date(from: date) {
                if image == UIImage(systemName: "photo") {
                    let update = Update(title: titleText, date: date, update: updateText, image: nil)
                    if mainVC.timeline == nil {
                        let timeline = Timeline(color: self.view.backgroundColor!, title: timelineTitle)
                        timeline.addToUpdates(update)
                        mainVC.timeline = timeline
                    } else {
                        mainVC.timeline?.addToUpdates(update)
                    }
                } else {
                    let update = Update(title: titleText, date: date, update: updateText, image: image)
                    if mainVC.timeline == nil {
                        let timeline = Timeline(color: self.view.backgroundColor!, title: timelineTitle)
                        timeline.addToUpdates(update)
                        mainVC.timeline = timeline
                    } else {
                        mainVC.timeline?.addToUpdates(update)
                    }
                }
            }
        }
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
            mainVC.updatesTableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        guard let update = self.update else { return }
        
        self.mainVC?.timeline?.removeFromUpdates(update)
        self.mainVC?.updatesTableView.reloadData()
        
        DispatchQueue.main.async {
            let moc = CoreDataStack.shared.mainContext
            do {
                try moc.save()
                self.dismiss(animated: true, completion: nil)
            } catch {
                print("Error Deleting Entry : \(error)")
                return
            }
        }
    }
    
    @IBAction func dateTextFieldTapped(_ sender: UITapGestureRecognizer) {
        checkDatePicker()
    }

    @IBAction func enterDateTapped(_ sender: Any) {
        let date = datePicker.date
        let time = timePicker.date
        
        let realDate = combineDateAndTime(date: date, time: time)
        
        if let update = update {
            update.date = realDate
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeStyle = .short
        dateTextField.text = dateFormatter.string(from: date)
        
        checkDatePicker()
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        guard imageTapRecognizer.view != nil else { return }
             
        if imageTapRecognizer.state == .ended {
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

