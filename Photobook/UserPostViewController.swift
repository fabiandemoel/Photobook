//
//  PostViewController.swift
//  Photobook
//
//  Created by Fabian de Moel on 23/05/2019.
//  Copyright © 2019 Fabian de Moel. All rights reserved.
//

import UIKit

class UserPostViewController: UIViewController {
    
    ////////////// View Preperation ////////////////////
    
    // Variables
    var picture: Picture!
    var image: UIImage!
    
    // Outlets
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        title = picture.title
        self.updateUI(with: picture, with: image)
    }
    
    // Load Post
    func updateUI(with picture: Picture, with image: UIImage) {
        
        // Set Text Fields
        descriptionLabel.text = picture.description
        imageView.image = image
    }
}
