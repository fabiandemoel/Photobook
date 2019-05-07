//
//  UploadViewController.swift
//  Photobook
//
//  Created by Fabian de Moel on 04/03/2019.
//  Copyright © 2019 Fabian de Moel. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var currentUser: User!
    var picture: Picture!
    var image: UIImage!
    let imagePicker = UIImagePickerController()
    
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextView!
    @IBOutlet var submitPostButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBAction func textEditingChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    @IBAction func returnPressed(_ sender: Any) {
        titleTextField.resignFirstResponder()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentUser = User.loadSampleUser()
        
        if let post = picture {
            loadPost(with: post)
        }
        updateSaveButtonState()
        imagePicker.delegate = self
    }
    
    // Load Picture
    func loadPost(with picture: Picture) {
        titleTextField.text = picture.title
        descriptionTextField.text = picture.description
        imageView.image = UploadViewController.convertBase64ToImage(imageString: picture.imageString)
    }
    
    func updateSaveButtonState() {
        let text = titleTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    @IBAction func loadImageButtonTapped(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
        
    }

    func uploadImage() {
        let imageFile = imageView.image?.jpegData(compressionQuality: 1)
        if imageFile == nil { return }

        PictureController.shared.addPicture(forPicture: imageFile!) {_ in
            print(self.picture)
        }
        
//        let imageString = UploadViewController.convertImageToBase64(image: imageView.image!)
//
//        let newPicture: [String: Any] = ["title": titleTextField.text!, "description": descriptionTextField.text!, "imageString": imageString]
//
//        PictureController.shared.addPicture(forPicture: newPicture, forUser: currentUser)
//        { (picture) in
//            DispatchQueue.main.async {
//                print("dispatch queue")
//                if let picture = picture {
//                    print("picture=picture")
//                    self.picture = picture
//                }
//            }
//        }
    }
    
    // Convert UIImage to String
    // Source: https://stackoverflow.com/questions/11251340/convert-between-uiimage-and-base64-string
    class func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.pngData()!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    class func convertBase64ToImage(imageString: String) -> UIImage {
        let imageData = Data(base64Encoded: imageString, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        return UIImage(data: imageData)!
    }
    
    
    @IBAction func unwindToMyContent(segue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        uploadImage()
        
    }
    
}
