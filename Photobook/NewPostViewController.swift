//
//  UploadViewController.swift
//  Photobook
//
//  Created by Fabian de Moel on 04/03/2019.
//  Copyright © 2019 Fabian de Moel. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

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
    
    // Load Post
    func loadPost(with picture: Picture) {
        
        // Set Text Fields
        title = picture.title
        titleTextField.text = picture.title
        descriptionTextField.text = picture.description
        ChoosePictureButton.isEnabled = false
        ChoosePictureButton.tintColor = .white
        
        // Set Image
        pictureController.fetchImageString(user: currentUser.name, title: title!) { (image) in
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
            let image = resizeImage(image: pickedImage, newWidth: 400.0)
            self.image = image
//            let base64 = convertImageToBase64(image: pickedImage)
//            let convertedimage = convertBase64ToImage(imageString: base64)
            imageView.image = image // convertedImage
        dismiss(animated: true, completion: nil)
        }
    }
    
    
    // Convert UIImage to a base64 representation
    func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.jpegData(compressionQuality: 0.1)!
        let imageString = imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
        return imageString
    }
    
    
    // Convert a base64 representation to a UIImage
    func convertBase64ToImage(imageString: String) -> UIImage? {
        if let dataDecoded = Data(base64Encoded: imageString, options: Data.Base64DecodingOptions.ignoreUnknownCharacters) {
            if let decodedimage:UIImage = UIImage(data: dataDecoded) {
                print("Image decoded to: \(decodedimage)")
                return decodedimage
            } else {
                print("Could not turn data into image")
            }
        } else {
            print("Data not decodable")
        }
        return nil
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    

    func uploadImageString() {
//        let imageFile = self.image.jpegData(compressionQuality: 1)
        let imageFile = self.image
        
        if let title = titleTextField.text {
            if imageFile == nil { return }
            pictureController.uploadImageString(forUser: currentUser.name, forImage: imageFile!, forPictureTitle: title) {_ in
                print("image: \(imageFile!)")
            }
            if let description = descriptionTextField.text {
                let picture: [String: String] = ["title": title, "description": description]
                self.picture = Picture(id: 0, title: title, description: description)
                pictureController.addPictureData(forUser: currentUser.name, forPicture: picture) {_ in}
            }
        }
        sleep(1)
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
            uploadImageString()
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
