//
//  SettingsTableViewController.swift
//  Photobook
//
//  Created by Fabian de Moel on 05/05/2019.
//  Copyright © 2019 Fabian de Moel. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UITabBarControllerDelegate {

    ////////////////////// View Preperation /////////////////////
    
    var currentUser: User!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    // Outlets
    @IBOutlet var UserNameLabel: UILabel!
    @IBOutlet var PassWordTextField: UITextField!
    @IBOutlet var SimpleModeSwitch: UISwitch!
    @IBOutlet var ShowPassWordButton: UIButton!
    
    
    @IBAction func ShowPassWordButtonPressed(_ sender: Any) {
        if PassWordTextField.isSecureTextEntry {
            ShowPassWordButton.setTitle("Hide Password", for: .normal)
        } else {
            ShowPassWordButton.setTitle("Show Password", for: .normal)        }
        PassWordTextField.isSecureTextEntry = !PassWordTextField.isSecureTextEntry
    }
    
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
        // Get Current user
        let user = appDelegate.globalUser
        
        // Set parameters
        UserNameLabel.text = user.name
        PassWordTextField.isSecureTextEntry = true
        PassWordTextField.text = user.passWord
        if user.type == "simple" {
            SimpleModeSwitch.isOn = true
        } else {
            SimpleModeSwitch.isOn = false
        }
        
        // Assign to variable
        self.currentUser = user
        
        tableView.reloadData()
    }
    
    // Reload data when switched to Tab bar with new user
    override func viewWillAppear(_ animated: Bool) {
        if currentUser.name != appDelegate.globalUser.name {
            viewDidLoad()
        }
    }
    
    ///////////////////// Function //////////////////////
    
    // Save Settings Button
    @IBAction func SaveSettingsButtonPressed(_ sender: Any) {
        if var user = currentUser {
            
            var changedParameters = [String: String]()
            
            // Password
            if let password = PassWordTextField.text {
                user.passWord = password
                changedParameters["passWord"] = password
            }
            
            // Simple mode
            if SimpleModeSwitch.isOn {
                user.type = "simple"
            } else {
                user.type = "normal"
            }
            changedParameters["type"] = user.type
            
            // Upload and Save user
            let userController = UserController.shared
            userController.editUser(forValues: changedParameters, forUser: user.id) {_ in}
            appDelegate.globalUser = user
            
            
            // Feedback for user
            let alert = UIAlertController(title: "Settings Saved!", message: "Your settings have been saved", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel))
            present(alert, animated: true, completion: nil)
        }
    }
}
