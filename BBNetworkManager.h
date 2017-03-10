//
//  BBNetworkManager.h
//  BattleBump
//
//  Created by Dave Augerinos on 2017-03-09.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@class Invitee;

@protocol BBNetworkManagerProtocol <NSObject>

-(void)receivedInviteeMessage:(Invitee *) invitee;

@end

@interface BBNetworkManager : NSObject <MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate>

@property (weak, nonatomic) id <BBNetworkManagerProtocol> delegate;

- (void)joinWithInvitee:(Invitee *)invitee;
- (void)send:(Invitee *)invitee;

@end
