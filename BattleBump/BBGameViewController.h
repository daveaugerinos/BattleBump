//
//  BBGameViewController.h
//  BattleBump
//
//  Created by Dave Augerinos on 2017-03-06.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "BBConnectViewController.h"

@interface BBGameViewController : UIViewController <BBNetworkManagerProtocol>

@property (strong, nonatomic) NSMutableArray *playerInviteesArray;
@property (strong, nonatomic) BBNetworkManager *networkManager;

@end
