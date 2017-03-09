//
//  Invitee.swift
//  BattleBump
//
//  Created by Dave Augerinos on 2017-03-07.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

class Invitee: NSObject {

    let player: Player
    let game: Game
    
    init(player: Player, game:Game) {
        
        self.player = player
        self.game = game
        super.init()
    }
}
