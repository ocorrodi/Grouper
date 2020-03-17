//
//  Member.swift
//  Grouper
//
//  Created by Olivia Corrodi on 12/2/17.
//  Copyright © 2017 Olivia Corrodi. All rights reserved.
//

import Foundation
class Member {
    let year: Int
    var ability: [Float]
    let name: String
    
    init(year: Int, ability: [Float] , name: String) {
        self.year = year
        self.ability = ability
        self.name = name
    }

}
