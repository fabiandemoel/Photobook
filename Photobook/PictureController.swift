//
//  PictureController.swift
//  Photobook
//
//  Created by Fabian de Moel on 22/05/2019.
//  Copyright © 2019 Fabian de Moel. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

extension URL {
    
    func withQueriesforImages(_ queries: [String]) -> URL? {
        
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.compactMap { URLQueryItem(name: "title", value: $0) }
        if let url = components?.url {
            return url
        } else {
            return nil
        }
    }
}

class PictureController {
    
    // Constants
    static let shared = PictureController()
    
    
    /////////////////////// Get Functions //////////////////////////////
    
    // Get All Pictures for One User
    func fetchPictures(forUser userName: String, completion: @escaping ([Picture]?) -> Void) {
        
        // Append url with userName
        let url = URL(string: "https://ide50-a10778403.legacy.cs50.io:8080/list/\(userName)")!
        
        // Decoding data
        let task = URLSession.shared.dataTask(with: url)
        { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let pictures = try? jsonDecoder.decode([Picture].self, from: data) {
                completion(pictures)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    // Get String Image
    func fetchImageString(user: String, title: String, completion: @escaping (UIImage?) -> Void) {
        let baseUrl = URL(string: "https://ide50-a10778403.legacy.cs50.io:8080/list/pictures\(user)")!
        
        let query: [String] = [title]

        guard let url = baseUrl.withQueriesforImages(query) else {
            completion(nil)
            print("Unable to build URL with supplied queries.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let imageString = try? jsonDecoder.decode([ImageString].self, from: data) {
                if imageString.isEmpty != true {
                    let image = self.convertBase64ToImage(imageString: imageString[0].imageString.replacingOccurrences(of: " ", with: "+"))
                    completion(image)
                } else {
                    completion(nil)
                }
            } else {
                print("Nil Completion PC")
                completion(nil)
            }
        }
        task.resume()
    }
    
    
    
    
    /////////////////////// Post Functions //////////////////////////////

    // Upload the data
    func addPictureData(forUser userName: String, forPicture pictureData: [String: String], completion: @escaping (Picture?) -> Void) {
        let url = URL(string: "https://ide50-a10778403.legacy.cs50.io:8080/list/\(userName)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Picture Data
        let picture: [String: Any] = pictureData
        request.httpBody = "title=\(picture["title"]!)&description=\(picture["description"]!)".data(using: .utf8)
        
        // Save Picture Data
        let task = URLSession.shared.dataTask(with: request) { (data,
            response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let picture = try?
                    jsonDecoder.decode(Picture.self, from: data) {
                completion(picture)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    
    
    //Upload Image with string base 64
    func uploadImageString(forUser user: String, forImage image: UIImage, forPictureTitle title: String, completion: @escaping (Picture?) -> Void) {
        let url = URL(string: "https://ide50-a10778403.legacy.cs50.io:8080/list/pictures\(user)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        // Picture Data
        let imageString = convertImageToBase64(image: image)
        request.httpBody = "title=\(title)&imageString=\(imageString)".data(using: .utf8)

        // Save Picture Data
        let task = URLSession.shared.dataTask(with: request) { (data,
            response, error) in
            if let data = data {
                print(data)
                completion(nil)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    
    ///// Accompanying Functions /////
    
    // Source: https://stackoverflow.com/questions/11251340/convert-between-uiimage-and-base64-string
    // Convert UIImage to a base64 representation
    func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.pngData()!
        let imageString = imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
        return imageString
    }
    

    // Convert a base64 representation to a UIImage
    func convertBase64ToImage(imageString: String) -> UIImage? {
        if let dataDecoded = Data(base64Encoded: imageString, options: Data.Base64DecodingOptions.ignoreUnknownCharacters) {
            print("Data Decoded: \(dataDecoded)")
            if let decodedimage:UIImage = UIImage(data: dataDecoded) {
                print(decodedimage)
                return decodedimage
            } else {
                print("Could not turn data into image")
            }
        } else {
            print("Data not decodable")
        }
        return nil
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    /////////////////////////// PUT function ///////////////////////
    
    // Edit Picture
    func editPictureData(forValues valueDict: [String: String], forPicture pictureId: Int, forUser userName: String, completion: @escaping (Picture?) -> Void) {
        
        let url = URL(string: "https://ide50-a10778403.legacy.cs50.io:8080/list/\(userName)/\(pictureId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Value
        //https://stackoverflow.com/questions/26372198/convert-swift-dictionary-to-string
        let pictureData = (valueDict.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }) as Array).joined(separator: "&")
        request.httpBody = pictureData.data(using: .utf8)
        
        // Edit Picture
        let task = URLSession.shared.dataTask(with: request) { (data,
            response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let picture = try? jsonDecoder.decode([Picture].self, from: data) {
                completion(picture[0])
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    
    /////////////////////////////////// DELETE function /////////////////////////
    
    // Edit Picture
    func deletePictureData(forPicture pictureId: Int, forUser userName: String, completion: @escaping (Picture?) -> Void) {
        
        let url = URL(string: "https://ide50-a10778403.legacy.cs50.io:8080/list/\(userName)/\(pictureId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Delete Picture
        let task = URLSession.shared.dataTask(with: request) { (data,
            response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let picture = try? jsonDecoder.decode([Picture].self, from: data) {
                completion(picture[0])
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
}

extension Data {
    mutating func appendString(_ string: String) {
        let data = string.data(
            using: String.Encoding.utf8,
            allowLossyConversion: true)
        append(data!)
    }
}





////////////////////   Code Temp Bin /////////////////



//        For giving uploads more unique url's:
//        let uploadUrl = URL(string: "https://ide50-a10778403.legacy.cs50.io:8080/picture_upload/\(username)/")!
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        let path1 = Bundle.main.path(forResource: "image_x", ofType: "png") as String!
//        request.HTTPBody =
//        let upload = URLSession.shared.uploadTask(with: request as URLRequest, from: png) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
//            // Decode response
//            let jsonDecoder = JSONDecoder()
//            if let data = data,
//                let picture = try?
//                    jsonDecoder.decode(Picture.self, from: data) {
//                completion(picture)
//            } else if let error = error{
//                print(error)
//                completion(nil)
//            }





//    // Upload the Image
//    func uploadImageJpeg(forUser user: String, forImage image: Data, forPictureTitle title: String, completion: @escaping (Picture?) -> Void) {
//
//        // Header
//        let uploadUrl = URL(string: "https://ide50-a10778403.legacy.cs50.io:8080/picture_upload/")!
//
//        let request = NSMutableURLRequest(url: uploadUrl)
//        request.httpMethod = "POST"
//        let boundary = generateBoundaryString()
//
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//
//
//        // Picture
//        request.httpBody = createBody(parameters: ["name": user],
//                                      boundary: boundary,
//                                      data: image,
//                                      mimeType: "image/jpg",
//                                      filename: "\(title).jpg")
//
//        print(request.httpBody)
//
//
//        let task = URLSession.shared.uploadTask(with: request as URLRequest, from: image) { (data,
//            response, error) in }
//        task.resume()
//    }
//
//
//        // Source: https://newfivefour.com/swift-form-data-multipart-upload-URLRequest.html
//        // Create body for request
//        func createBody(parameters: [String: String],
//                        boundary: String,
//                        data: Data,
//                        mimeType: String,
//                        filename: String) -> Data {
//            var body = Data()
//
//            let boundaryPrefix = "--\(boundary)\r\n"
//
//
//
//            for (key, value) in parameters {
//                body.appendString(boundaryPrefix)
//                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//                body.appendString("\(value)\r\n")
//            }
//
//            body.appendString(boundaryPrefix)
//            body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
//            body.appendString("Content-Type: \(mimeType)\r\n\r\n")
//            body.append(data)
//            body.appendString("\r\n")
//            body.appendString("--".appending(boundary.appending("--")))
//
//            return body as Data
//        }
//
//        func generateBoundaryString() -> String {
//            return "Boundary-\(NSUUID().uuidString)"
//        }



//          Fetch Picture
//        func fetchPictureJpeg(url: URL, completion: @escaping (UIImage?) -> Void) {
//            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//                if let data = data,
//                    let image = UIImage(data: data) {
//                    completion(image)
//                } else {
//                    completion(nil)
//                }
//            }
//            task.resume()
//        }



/////////////////// Upload Image with string base 64
//    func uploadImage(forUser user: String, forImage image: UIImage, forPictureTitle title: String, completion: @escaping (Picture?) -> Void) {
//        let url = URL(string: "https://ide50-a10778403.legacy.cs50.io:8080/list/pictures\(user)")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//
//        // Picture Data
//        let imageString = convertImageToBase64(image: image)
//        request.httpBody = "title=\(title)&imageString=\(imageString)".data(using: .utf8)
//
//        // Save Picture Data
//        let task = URLSession.shared.dataTask(with: request) { (data,
//            response, error) in
//            let jsonDecoder = JSONDecoder()
//            if let data = data {
////                let picture = try?
////                    jsonDecoder.decode(Picture.self, from: data) {
////                completion(picture)
//                print(data)
//                completion(nil)
//            } else {
//                completion(nil)
//            }
//        }
//        task.resume()
//    }



////////////// Alamofire ////////////////

//    // Upload the Image
//    func uploadImage(forUser user: String, forImage image: UIImage, forPictureTitle title: String, completion: @escaping (Picture?) -> Void) {
//
//        let imageData: NSMutableData = NSMutableData(data: image.jpegData(compressionQuality: 1)!);
//
//
//
////        AF.upload(.POST, "http://localhost:8080/rest/service/upload?attachmentName=file.jpg",  imageData)
////            .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
////                print(totalBytesWritten)
////            }
////            .responseString { (request, response, JSON, error) in
////                print(request)
////                print(response)
////                print(JSON)
////        }
//
//    }
//

