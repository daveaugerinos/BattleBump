//
//  Invitee.swift
//  BattleBump
//
//  Created by Dave Augerinos on 2017-03-07.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

import UIKit

class Invitee: NSObject, NSCoding {

    let player: Player
    let game: Game
    
    init(player: Player, game:Game) {
        
        self.player = player
        self.game = game
        super.init()
    }
    
    // MARK: NSCoding
    
    required convenience init?(coder decoder: NSCoder) {
        
        guard let player = decoder.decodeObject(forKey:"player") as? Player,
            let game = decoder.decodeObject(forKey:"game") as? Game
            else { return nil }
        
        self.init(player: player, game: game)
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.player, forKey: "player")
        aCoder.encode(self.game, forKey: "game")
    }
}
