//
//  Item.swift
//  Color Todo
//
//  Created by Daniel Kilders Díaz on 30/11/2018.
//  Copyright © 2018 dankil. All rights reserved.
//

import UIKit

class Item: Codable { // Swift 4 replaces: Encodable, Decodable
    var title: String = ""
    var done: Bool = false
    
    required init(title: String, done: Bool = false) {
        self.title = title
        self.done = done
    }
}
