//
//  PictureController.swift
//  Photobook
//
//  Created by Fabian de Moel on 22/05/2019.
//  Copyright © 2019 Fabian de Moel. All rights reserved.
//

import Foundation
import UIKit


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
    
    // Get One Picture
    func fetchPicture(url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data,
                let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    
    /////////////////////// Post Functions //////////////////////////////
    // Add new Picture
    
    func uploadImage(forPicture picture: Data, completion: @escaping (Picture?) -> Void) {
        
        // Header
        let uploadUrl = URL(string: "https://ide50-a10778403.legacy.cs50.io:8080/picture_upload/")!
        
//        For giving uploads more unique url's:
//        let uploadUrl = URL(string: "https://ide50-a10778403.legacy.cs50.io:8080/picture_upload/\(username)/")!
        
        
        var request = URLRequest(url: uploadUrl)
        request.httpMethod = "POST"
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Picture
        request.httpBody = picture
        
        // Upload Image
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
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func addPictureData(forUser userName: String, forPicture pictureData: [String: String], completion: @escaping (Picture?) -> Void) {
        let url = URL(string: "https://ide50-a10778403.legacy.cs50.io:8080/list/\(userName)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Picture Data
        let picture: [String: Any] = pictureData
        request.httpBody = "title=\(picture["title"]!)&description=\(picture["description"]!)&url=\(picture["url"]!)".data(using: .utf8)
        
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
