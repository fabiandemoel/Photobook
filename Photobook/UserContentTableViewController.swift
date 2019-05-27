//
//  ContactTableViewController.swift
//  Photobook
//
//  Created by Fabian de Moel on 29/04/2019.
//  Copyright © 2019 Fabian de Moel. All rights reserved.
//

import UIKit

class UserContentTableViewController: UITableViewController {
    
    ////////////////////// View Preperation /////////////////////
    
    // Variables
    var user: User!
    var content = [Picture]()
    var images = [UIImage]()
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = user.name
        
        // Fetch pictureInfo
        PictureController.shared.fetchPictures(forUser: user.name) { (pictures) in
            guard let pictures = pictures else { return }
            self.updateUI(with: pictures)
        }
    }
    
    
    func updateUI(with content: [Picture]) {
        
        DispatchQueue.main.async {
            self.content = content
            self.tableView.reloadData()
        }
    }

    
    
    /////////////////// Table view data source //////////////////////


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
                self.images.append(image)
                cell.setNeedsLayout()
            }
        }
    }
    
    
    /////////////////////// Functions //////////////////////////////
    
    // Segue prep
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewPostSegue" {
            let postViewController = segue.destination as! PostViewController
            let index = tableView.indexPathForSelectedRow!.row
            postViewController.picture = content[index]
            postViewController.image = images[index]
        }
    }
}
