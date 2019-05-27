//
//  UploadViewController.swift
//  Photobook
//
//  Created by Fabian de Moel on 04/03/2019.
//  Copyright © 2019 Fabian de Moel. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    ////////////////////// View Preperation /////////////////////
    // Variables
    var currentUser: User!
    var picture: Picture!
    var image: UIImage!
    let imagePicker = UIImagePickerController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Outlets and Actions
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextView!
    @IBOutlet var submitPostButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var ChoosePictureButton: UIButton!
    @IBAction func textEditingChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    @IBAction func returnPressed(_ sender: Any) {
        titleTextField.resignFirstResponder()
    }
    
    // View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentUser = appDelegate.globalUser
        
        if let post = picture {
            loadPost(with: post)
        }
        updateSaveButtonState()
        imagePicker.delegate = self
    }
    
    /////////////////////// Functions //////////////////////////////
    
    // Load Picture
    func loadPost(with picture: Picture) {
        
        // Set Text Fields
        title = picture.title
        titleTextField.text = picture.title
        descriptionTextField.text = picture.description
        ChoosePictureButton.isEnabled = false
        ChoosePictureButton.tintColor = .white
        
        // Set Image
        let pictureController = PictureController.shared
        pictureController.fetchPicture(url: picture.url) { (image) in
            guard let image = image else { return }
            self.image = image
        }
        self.imageView.image = self.image
    }
    
    // Update Save Button
    func updateSaveButtonState() {
        let text = titleTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    // Choose Image from library
    @IBAction func loadImageButtonTapped(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            self.image = pickedImage
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }

    func uploadImage() {
        let imageFile = self.image.jpegData(compressionQuality: 1)
        
        if imageFile == nil { return }
        PictureController.shared.uploadImage(forPicture: imageFile!) {_ in
            print("image: \(imageFile!)")
        }
        if let title = titleTextField.text {
            if let description = descriptionTextField.text {
                let url = "https://ide50-a10778403.legacy.cs50.io:8080/uploads/\(title).jpg"
                let picture: [String: String] = ["title": title, "description": description, "url": url]
                PictureController.shared.addPictureData(forUser: currentUser.name, forPicture: picture) {_ in}
            }
        }
    }
    
    
    // Unwind function
    @IBAction func unwindToMyContent(segue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveUnwind" else { return }
        picture.title = titleTextField.text!
        picture.description = descriptionTextField.text
        if let post = picture {
            // edit post with Put message
            PictureController.shared.editPictureData(forValues: ["title": post.title, "description": post.description], forPicture: post.id, forUser: currentUser!.name) {_ in}
        } else {
            uploadImage()
        }
    }
    
}
