//
//  BBConnectViewController.h
//  BattleBump
//
//  Created by Dave Augerinos on 2017-03-06.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface BBConnectViewController : UIViewController <MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate,  UITextFieldDelegate>

@end
