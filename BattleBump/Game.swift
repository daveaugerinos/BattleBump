//
//  Game.swift
//  BattleBump
//
//  Created by Dave Augerinos on 2017-03-07.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

class Game: NSObject {

    let name: String
    let stakes: String
    var state: String
    
    init(name: String, stakes:String) {
        
        self.name = name;
        self.stakes = stakes;
        self.state = "init"
        super.init()
    }
}
