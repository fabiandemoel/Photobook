//
//  UploadViewController.swift
//  Photobook
//
//  Created by Fabian de Moel on 04/03/2019.
//  Copyright © 2019 Fabian de Moel. All rights reserved.
//

import Foundation
import UIKit

class NewPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    ////////////////////// View Preperation /////////////////////
    // Variables
    var currentUser: User!
    var picture: Picture!
    var image: UIImage!
    let imagePicker = UIImagePickerController()
    let pictureController = PictureController.shared
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Outlets and Actions
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextView!
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
        pictureController.fetchImage(user: currentUser.name, title: title!) { (image) in
            print(image)
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
        dismiss(animated: true, completion: nil)
        }
    }

    func uploadImage() {
//        let imageFile = self.image.jpegData(compressionQuality: 1)
        let imageFile = self.image
        
        
        

        if let title = titleTextField.text {
            if imageFile == nil { return }
            pictureController.uploadImage(forUser: currentUser.name, forImage: imageFile!, forPictureTitle: title) {_ in
                print("image: \(imageFile!)")
            }
            if let description = descriptionTextField.text {
                let url = "https://ide50-a10778403.legacy.cs50.io:8080/uploads/\(title).jpg"
                let picture: [String: String] = ["title": title, "description": description, "url": url]
                let Url = URL(string: "https://ide50-a10778403.legacy.cs50.io:8080/uploads/")!
                self.picture = Picture(id: 0, title: title, description: description, url: Url)
                pictureController.addPictureData(forUser: currentUser.name, forPicture: picture) {_ in}
            }
        }
    }

    // Unwind function
    @IBAction func unwindToMyContent(segue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveUnwind" else { return }
        
        if var post = picture {
            // edit post with Put message
            post.title = titleTextField.text!
            post.description = descriptionTextField.text
            pictureController.editPictureData(forValues: ["title": post.title, "description": post.description], forPicture: post.id, forUser: currentUser!.name) {_ in}
        } else {
            uploadImage()
        }
    }
}


//              Code for adding URL input functionality
//
//    var lastChosen = ""
//    @IBOutlet var URLTextField: UITextField!
//
//    // Use image url
//    @IBAction func fetchImageButtonPressed(_ sender: Any) {
//        if let url = URL(string: URLTextField.text!) {
//            pictureController.fetchPicture(url: url) {(image) in
//                self.image = image
//                self.lastChosen = "URL"
//            }}
//        self.imageView.image = self.image
//    }
//
//    func uploadImageWithURL() {
//        if let title = titleTextField.text {
//            if let description = descriptionTextField.text {
//                let url = URLTextField.text!
//                let picture: [String: String] = ["title": title, "description": description, "url": url]
//                pictureController.addPictureData(forUser: currentUser.name, forPicture: picture) {_ in}
//            }
//        }
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if URLTextField.text!.isEmpty {
//            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//                imageView.contentMode = .scaleAspectFit
//                self.image = pickedImage
//                imageView.image = pickedImage
//                lastChosen = "imagePicker"
//            }
//            dismiss(animated: true, completion: nil)
//        }
//    }
//
//    if lastChosen == "imagePicker" {
//        uploadImage()
//    } else if lastChosen == "URL" {
//        uploadImageWithURL()
//    }
