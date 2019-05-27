//
//  MyContentTableViewController.swift
//  Photobook
//
//  Created by Fabian de Moel on 29/04/2019.
//  Copyright © 2019 Fabian de Moel. All rights reserved.
//

import Foundation
import UIKit

class MyContentTableViewController: UITableViewController, UITabBarControllerDelegate {
    
    ////////////////////// View Preperation /////////////////////
    
    // Variables
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var user: User!
    var content = [Picture]()
    
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        
        user = appDelegate.globalUser
        checkType()
        
        // Load Pictures
        PictureController.shared.fetchPictures(forUser: user!.name) { (pictures) in
            guard let pictures = pictures else { return }
            self.updateUI(with: pictures)
        }
        
        // Load Images
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    func updateUI(with content: [Picture]) {
        
        DispatchQueue.main.async {
            self.content = content
            self.tableView.reloadData()
        }
    }

    
    /////////////////// Table view data source //////////////////////
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Send delete request to server
            let picture = content[indexPath.row]
            PictureController.shared.deletePictureData(forPicture: picture.id, forUser: user.name) {_ in
            }
            self.content.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCellIdentifier", for: indexPath)
        configure(cell, forItemAt: indexPath)
        return cell
    }
    
    func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let picture = content[indexPath.row]
        cell.textLabel?.text = picture.title
        PictureController.shared.fetchPicture(url: picture.url) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath != indexPath {return}
                cell.imageView?.image = image
                cell.setNeedsLayout()
            }
        }
    }
    
    
    ///////////////////// Switch tab bar for simple accounts ///////////////////////
    
    // Source: https://stackoverflow.com/questions/33837475/detect-when-a-tab-bar-item-is-pressed
    // Source: https://stackoverflow.com/questions/28099148/switch-tab-bar-programmatically-in-swift
    
    // Check Account Type
    func checkType() {
        if user.type == "simple" {
            let alert = UIAlertController(title: "Simple Mode", message: "This section is a little bit more challenging, so it's disabled in simple mode. You can enable it in the settings screen by switching simple mode off and saving your settings.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Contacts", style: .default) { action in
                self.switchToContactTab()
            })
            alert.addAction(UIAlertAction(title: "Settings", style: .default) { action in
                self.switchToSettingsTab()
            })
            present(alert, animated: true, completion: nil)
        }
    }
    
    // Tab Switches
    func switchToContactTab() {
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(switchToContactTabCont), userInfo: nil, repeats: false)
    }
    
    @objc func switchToContactTabCont(){
        tabBarController!.selectedIndex = 0
    }
    
    func switchToSettingsTab() {
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(switchToSettingsTabCont), userInfo: nil, repeats: false)
    }
    
    @objc func switchToSettingsTabCont(){
        tabBarController!.selectedIndex = 2
    }
    
    // Recheck user data when switched to Tab bar
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 1 {
            if user.name != appDelegate.globalUser.name {
                viewDidLoad()
            } else {
                user = appDelegate.globalUser
                checkType()
            }
        }
    }
    
    
    /////////////////////// Functions //////////////////////////////
    
    // Segue Function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let uploadViewController = segue.destination as! UploadViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedPost = content[indexPath.row]
            uploadViewController.picture = selectedPost
            uploadViewController.image = tableView.cellForRow(at: indexPath)?.imageView!.image
        }
        if segue.identifier == "ContactsSegue" {
            _ = segue.destination as! ContactsTableViewController
        }
        if segue.identifier == "SettingsSegue" {
            _ = segue.destination as! SettingsTableViewController
        }
    }
    
    // Dismiss current view
    @IBAction func unwindToMyContent(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        
        let sourceViewController = segue.source as! UploadViewController
        if let picture = sourceViewController.picture {
    
            // Check if a cell was edited or needs to be added
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                content[selectedIndexPath.row] = picture
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: content.count, section: 0)
                content.append(picture)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
}
