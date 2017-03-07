//
//  BBConnectCollectionViewCell.m
//  BattleBump
//
//  Created by Dave Augerinos on 2017-03-07.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

#import "BBConnectCollectionViewCell.h"

@interface BBConnectCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *playerEmojiLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;

@end

@implementation BBConnectCollectionViewCell

-(void)setName:(Player *)player {
    
    _player = player;
    [self configureCellWithPlayer];
}


-(void)setGame:(Game *)game {
    
    _game = game;
    [self configureCellWithGame];
}


-(void)configureCellWithPlayer {
    
    self.playerEmojiLabel.text = self.player.emoji;
    self.playerNameLabel.text = self.player.name;
}


-(void)configureCellWithGame {
    
    self.gameNameLabel.text = self.game.name;
}

@end
