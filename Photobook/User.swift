//
//  User.swift
//  Photobook
//
//  Created by Fabian de Moel on 04/03/2019.
//  Copyright © 2019 Fabian de Moel. All rights reserved.
//

import Foundation

struct User: Decodable {
    var id: String
    var name: String
    var type: String
    var friendsFamily: String //seperate into different names/ids using initializer
    var passWord: String

    static func loadSampleUser() -> User {
    let user = User(id: "1", name: "Fabian", type: "simple", friendsFamily: "Jack, Jassabae", passWord: "wachtwoord")
        return user
    }
    
    // var content: [Picture] //convert string into picture object using initializer
    
    
    
    // var dateJoined: Date
    // var supportAccount: Int? // Friend or family member that can help remotely

    
//    enum AccountType: Decodable, CodingKey {
//        init(from decoder: Decoder) throws {
//            let valueContainer = try decoder.container(keyedBy: AccountType.self)
//            self = try valueContainer.decode(AccountType.self, forKey: AccountType)
//        }
//
//        case simple, normal
//    }

}
