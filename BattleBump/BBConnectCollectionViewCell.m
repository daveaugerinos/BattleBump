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

-(void)setInvitee:(Invitee *)invitee {
    
    _invitee = invitee;
    [self configureCellWithInvitee];
}


-(void)configureCellWithInvitee {
    
    self.playerEmojiLabel.text = self.invitee.player.emoji;
    self.playerNameLabel.text = self.invitee.player.name;
    self.gameNameLabel.text = self.invitee.game.name;
}

@end
