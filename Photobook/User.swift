//
//  User.swift
//  Photobook
//
//  Created by Fabian de Moel on 04/03/2019.
//  Copyright © 2019 Fabian de Moel. All rights reserved.
//

import Foundation

struct User: Encodable, Decodable {
    var id: Int
    var name: String
    var type: String
    var friendsFamily: String //seperate into different names/ids using initializer
    var passWord: String

    static func loadUser() -> User {
        if let savedUser = loadSavedUser() {
            return savedUser
        } else {
            let sampleUser = loadSampleUser()
            return sampleUser
        }
    }

    static func loadSavedUser() -> User? {
        guard let codedUser = try? Data(contentsOf: ArchiveURL) else {return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(User.self, from: codedUser)
    }
    
    static func saveUser(_ user: User) {
        let propertyListEncoder = PropertyListEncoder()
        let codedUser = try? propertyListEncoder.encode(user)
        try? codedUser?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    static func loadSampleUser() -> User {
        var sampleUser: User?
        UserController.shared.fetchUser(forUser: "Demo Account") { (user) in
            if let user = user {
                sampleUser = user
            }
        }
        
        sleep(2)
        if let user = sampleUser {
            return user
        } else {
            let user = User(id: 1, name: "Demo Account", type: "normal", friendsFamily: "Jack,Jasmin", passWord: "wachtwoord")
            return user
        }
        
    }
    
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("user").appendingPathExtension("plist")
    
    /////////// Optional ///////////////
//     var dateJoined: Date
//     var supportAccount: Int? // Friend or family member that can help remotely
//
//
//    enum AccountType: Decodable, CodingKey {
//        init(from decoder: Decoder) throws {
//            let valueContainer = try decoder.container(keyedBy: AccountType.self)
//            self = try valueContainer.decode(AccountType.self, forKey: AccountType)
//        }
//
//        case simple, normal
//    }

}
