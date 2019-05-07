//
//  ContactTableViewController.swift
//  Photobook
//
//  Created by Fabian de Moel on 29/04/2019.
//  Copyright © 2019 Fabian de Moel. All rights reserved.
//

import UIKit

class UserContentTableViewController: UITableViewController {
    var user: User!
    var content = [Picture]()
    
    // Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // fetch pictureInfo
        
//        if let content = user.content {
//            self.updateUI(with: content)
//        }
    }
    
    func updateUI(with content: [Picture]) {
        DispatchQueue.main.async {
            self.content = content
            self.tableView.reloadData()
            
            // set picture and description, most recent first
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
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
        if segue.identifier == "ViewPostSegue" {
            let postViewController = segue.destination as! PostViewController
            let index = tableView.indexPathForSelectedRow!.row
            postViewController.picture = content[index]
        }
    }
}
