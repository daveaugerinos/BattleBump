//
//  GameLogicManager.m
//  BattleBump
//
//  Created by Callum Davies on 2017-03-07.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

#import "GameLogicManager.h"

@implementation GameLogicManager

-(void)pickRandomMove
{
    int i = arc4random_uniform(3);
    switch (i) {
        case 0:
            self.myConfirmedMove = @"Rock";
            break;
        case 1:
            self.myConfirmedMove = @"Paper";
            break;
        case 2:
            self.myConfirmedMove = @"Scissors";
            break;
        default:
            break;
    }
}

-(void)readyForNextRound
{
    
}

-(NSString *)generateResultsLabelWithMoves
{
    NSString *computedString = @"";
    if ([self.myConfirmedMove isEqualToString:self.theirConfirmedMove]) {
        computedString = [NSString stringWithFormat:@"%@ ties %@", self.myConfirmedMove, self.theirConfirmedMove];
    }
    else {
        
    }
    return computedString;
}
@end
