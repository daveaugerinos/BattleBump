//
//  Game.swift
//  BattleBump
//
//  Created by Dave Augerinos on 2017-03-07.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

class Game: NSObject, NSCoding {

    let name: String
    var state: String
    
    init(name: String, state: String) {
        
        self.name = name
        self.state = state
        super.init()
    }
    
    // MARK: NSCoding
    
    required convenience init?(coder decoder: NSCoder) {
        
        guard let name = decoder.decodeObject(forKey: "name") as? String,
            let state = decoder.decodeObject(forKey: "state") as? String
            else { return nil }
        
        self.init(name: name, state: state)
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.state, forKey: "state")
    }
}
