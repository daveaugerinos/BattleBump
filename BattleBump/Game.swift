//
//  Game.swift
//  BattleBump
//
//  Created by Dave Augerinos on 2017-03-07.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

class Game: NSObject {

    private let name: String
    private let stakes: String
    
    init(name: String, stakes:String) {
        
        self.name = name;
        self.stakes = stakes;
        super.init()
    }
}
