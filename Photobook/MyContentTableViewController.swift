//
//  MyContentTableViewController.swift
//  Photobook
//
//  Created by Fabian de Moel on 29/04/2019.
//  Copyright © 2019 Fabian de Moel. All rights reserved.
//

import UIKit

class MyContentTableViewController: UITableViewController, UITabBarControllerDelegate {
    
    // Variables
    var user: User!
    var content: [Picture]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        
        user = User.loadSampleUser()
//        checkType()
        
        // Load Pictures
        if let pictures = Picture.loadPictures() {
            content = pictures
        } else {
//            content = Picture.loadSamplePictures()
        }
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    
    // Switch tab bar for simple accounts
    // Source: https://stackoverflow.com/questions/33837475/detect-when-a-tab-bar-item-is-pressed
    // Source: https://stackoverflow.com/questions/28099148/switch-tab-bar-programmatically-in-swift
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 1 {
            checkType()
        }
    }
    
    // Check Account Type
    func checkType() {
        if user.type == "simple" {
            let alert = UIAlertController(title: "Simple Mode", message: "This section is a little bit more challenging, you can enable it in the settings screen by switching simple mode off", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Contacts", style: .default) { action in
                self.switchToContactTab()
            })
            alert.addAction(UIAlertAction(title: "Settings", style: .default) { action in
                self.switchToSettingsTab()
            })
            present(alert, animated: true, completion: nil)
        }
    }
    
    // Tab Switch
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
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Send delete request to server
            content.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let userContent = content{
            return userContent.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCellIdentifier", for: indexPath)
        configure(cell, forItemAt: indexPath)
        return cell
    }
    
    func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let picture = content[indexPath.row]
        cell.textLabel?.text = picture.title
//        PictureController.shared.fetchImage(url: picture.imageURL) { (image) in
//            guard let image = image else { return }
//            DispatchQueue.main.async {
//                if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath != indexPath {return}
//                cell.imageView?.image = image
//                cell.setNeedsLayout()
//            }
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let uploadViewController = segue.destination as! UploadViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedPost = content[indexPath.row]
            uploadViewController.picture = selectedPost
            uploadViewController.image = tableView.cellForRow(at: indexPath)?.imageView!.image
        }
        if segue.identifier == "ContactsSegue" {
            let contactsTableViewController = segue.destination as! ContactsTableViewController
        }
        if segue.identifier == "SettingsSegue" {
            let settingTableViewController = segue.destination as! SettingsTableViewController
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
//        ToDo.saveToDos(todos)
    }
}
