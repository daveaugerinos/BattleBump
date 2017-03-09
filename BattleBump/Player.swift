//
//  Player.swift
//  BattleBump
//
//  Created by Dave Augerinos on 2017-03-07.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

class Player: NSObject {

    let name: String
    let emoji: String
    var move: String

    init(name: String, emoji:String, move: String) {
        
        self.name = name
        self.emoji = emoji
        self.move = move
        super.init()
    }
}
