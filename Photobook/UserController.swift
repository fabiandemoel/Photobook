//
//  UserController.swift
//  Photobook
//
//  Created by Fabian de Moel on 22/05/2019.
//  Copyright © 2019 Fabian de Moel. All rights reserved.
//

import Foundation

extension URL {
    
    func withQueries(_ queries: [String]) -> URL? {
        
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.compactMap { URLQueryItem(name: "name", value: $0) }
        if let url = components?.url {
            return url
        } else {
            return nil
        }
    }
}

class UserController {
    
    // Constants
    static let shared = UserController()
    let baseUrl = URL(string: "https://ide50-a10778403.legacy.cs50.io:8080/list/users")!
    
    
    /////////////////////// Get Functions //////////////////////////////
    
    // Get Users Friends
    
    // In order to use this, the server needs to accept multiple users at once. At this moment it only returns the first user bound to the name parameter
    
//    func fetchFriends(forFriends friends: String, completion: @escaping ([User]?) -> Void) {
//
//        var query: [String] = []
//
//        let friendList = friends.split(separator: ",")
//        for friend in friendList {
//            query.append(String(friend))
//        }
//
//        guard let url = baseUrl.withQueries(query) else {
//            completion(nil)
//            print("Unable to build URL with supplied queries.")
//            return
//        }
//
//
//        // Decoding data
//        let task = URLSession.shared.dataTask(with: url)
//        { (data, response, error) in
//            let jsonDecoder = JSONDecoder()
//            if let data = data,
//                let users = try? jsonDecoder.decode([User].self, from: data) {
//                completion(users)
//            } else {
//                completion(nil)
//            }
//        }
//        task.resume()
//    }
    

    

    // Get One User
    func fetchUser(forUser userName: String, completion: @escaping (User?) -> Void) {
        
        // append url with user id
        guard let url = baseUrl.withQueries([userName]) else {
            completion(nil)
            print("Unable to build URL with supplied queries.")
            return
        }
        
        
        // Decoding data
        let task = URLSession.shared.dataTask(with: url)
        { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let user = try? jsonDecoder.decode([User].self, from: data) {
                completion(user[0])
            } else {
                completion(nil)
            }
        }
        task.resume()
        
//        // Decoding data
//        let task = URLSession.shared.dataTask(with: url)
//        { (data, response, error) in
//            let jsonDecoder = JSONDecoder()
//            if let data = data,
//                let user = try? jsonDecoder.decode(User.self, from: data) {
//                print("success")
//                completion(user)
//            } else {
//                print("fail")
//                completion(nil)
//            }
//        }
//        task.resume()
    }
    
    /////////////////////// Post Function //////////////////////////////
    
    // Add new User
    func addUser(forUser user: [String: String], completion: @escaping (User?) -> Void) {
        var request = URLRequest(url: baseUrl)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // User
        let userData: [String: Any] = user
        request.httpBody = "name=\(userData["name"]!)&type=\(userData["type"]!)&friendsFamily=\(userData["friendsFamily"]!)&passWord=\(userData["passWord"]!)".data(using: .utf8)
        
        // Register User
        let task = URLSession.shared.dataTask(with: request) { (data,
            response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let user = try?
                    jsonDecoder.decode(User.self, from: data) {
                completion(user)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    // Edit User
    func editUser(forValues valueDict: [String:String], forUser userID: Int, completion: @escaping (User?) -> Void) {
        
        let url = URL(string: "https://ide50-a10778403.legacy.cs50.io:8080/list/users/\(userID)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // User
        let userData = (valueDict.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }) as Array).joined(separator: "&")
        request.httpBody = userData.data(using: .utf8)
        
        // Register User
        let task = URLSession.shared.dataTask(with: request) { (data,
            response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let user = try? jsonDecoder.decode([User].self, from: data) {
                completion(user[0])
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}
