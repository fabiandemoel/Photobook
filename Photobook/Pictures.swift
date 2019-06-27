//
//  Pictures.swift
//  Photobook
//
//  Created by Fabian de Moel on 22/05/2019.
//  Copyright © 2019 Fabian de Moel. All rights reserved.
//

import Foundation

struct Picture: Decodable {
    
    var id: Int
    var title: String = ""
    var description: String
}

struct ImageString: Decodable {
    var title: String
    var imageString: String
}

struct Pictures: Decodable {
    var pictures: [Picture]
}
