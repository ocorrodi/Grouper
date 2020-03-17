//
//  Class.swift
//  Grouper
//
//  Created by Olivia Corrodi on 12/2/17.
//  Copyright © 2017 Olivia Corrodi. All rights reserved.
//

import Foundation

class Class {
    let code: String
    let members: [Member]
    let id: String
    let name: String
    
    init(code: String, members: [Member], id: String, name: String) {
        self.code = code
        self.members = members
        self.id = id
        self.name = name
    }
}
