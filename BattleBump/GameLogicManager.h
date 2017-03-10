//
//  GameLogicManager.h
//  BattleBump
//
//  Created by Callum Davies on 2017-03-07.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Move.h"

@interface GameLogicManager : NSObject

@property (strong, nonatomic) NSString *myConfirmedMove;
@property (strong, nonatomic) NSString *theirConfirmedMove;
@property (nonatomic) BOOL isGameOn;

-(void)pickRandomMove;
-(void)readyForNextRound;
-(NSString *)generateResultsLabelWithMoves;

@end
