//
//  SaveAlertViewController.swift
//  Timeline
//
//  Created by Bobby Keffury on 3/29/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class SaveAlertViewController: UIViewController {

    //MARK: - Properties
    
    //MARK: - Outlets
    
    @IBOutlet weak var timelineView: UIView!
    @IBOutlet weak var timelineLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    
    //MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Methods
    
    //MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
    }
    
}
