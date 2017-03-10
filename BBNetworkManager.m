//
//  BBNetworkManager.m
//  BattleBump
//
//  Created by Dave Augerinos on 2017-03-09.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

#import "BBNetworkManager.h"
#import "BattleBump-Swift.h"

@interface BBNetworkManager ()

@property (strong, nonatomic) MCPeerID *myPeerID;
@property (strong, nonatomic) MCNearbyServiceAdvertiser *myAdvertiser;
@property (strong, nonatomic) MCNearbyServiceBrowser *myBrowser;
@property (strong, nonatomic) MCSession *mySession;

@end

@implementation BBNetworkManager

static NSString * const BBRPSServiceType = @"BBRPS-game";

#pragma mark - MCSessionDelegate methods -

// Helper method for human readable printing of MCSessionState.  This state is per peer.
- (NSString *)stringForPeerConnectionState:(MCSessionState)state
{
    switch (state) {
        case MCSessionStateConnected:
            return @"Connected";
            
        case MCSessionStateConnecting:
            return @"Connecting";
            
        case MCSessionStateNotConnected:
            return @"Not Connected";
    }
}

// Override this method to handle changes to peer session state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    NSLog(@"Peer [%@] changed state to %@", peerID.displayName, [self stringForPeerConnectionState:state]);
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        
        // send current connection state to Connect VC
    }];
}

// MCSession Delegate callback when receiving data from a peer in a given session
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSLog(@"Received data from %@", peerID.displayName);
    
    NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    Invitee *invitee = dictionary[@"invitee"];
    
    [self.delegate receivedInviteeMessage:(Invitee *) invitee];
}

// MCSession delegate callback when we start to receive a resource from a peer in a given session
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    NSLog(@"Start receiving resource [%@] from peer %@ with progress [%@]", resourceName, peerID.displayName, progress);
}

// MCSession delegate callback when a incoming resource transfer ends (possibly with error)
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    NSLog(@"Received data over resource with name %@ from peer %@", resourceName, peerID.displayName);
}

// Streaming API not utilized in this sample code
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    NSLog(@"Received data over stream with name %@ from peer %@", streamName, peerID.displayName);
}


#pragma mark - MCNearbyServiceAdvertiserDelegate -

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
    
    invitationHandler(YES, self.mySession);
}


#pragma mark - MCNearbyServiceBrowserDelegate -

-(void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary<NSString *,NSString *> *)info {
    
    self.mySession = [[MCSession alloc] initWithPeer:self.myPeerID
                                    securityIdentity:nil
                                encryptionPreference:MCEncryptionNone];
    self.mySession.delegate = self;
    
    [browser invitePeer:peerID toSession:self.mySession withContext:nil timeout:10];
}

-(void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    
    NSLog(@"Peer lost: %@", peerID.displayName);
}


#pragma mark - BBNetwork Manager Client Methods

- (void)joinWithInvitee:(Invitee *)invitee {
    
    self.myPeerID = [[MCPeerID alloc] initWithDisplayName:invitee.player.name];
    self.myAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.myPeerID
                                                          discoveryInfo:nil
                                                            serviceType:BBRPSServiceType];
    self.myAdvertiser.delegate = self;
    [self.myAdvertiser startAdvertisingPeer];
    
    self.myBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.myPeerID serviceType:BBRPSServiceType];
    self.myBrowser.delegate = self;
    [self.myBrowser startBrowsingForPeers];
}

- (void)send:(Invitee *)invitee {
    
    NSLog(@"Send Invitee Message\n");
    
    NSDictionary *dictionary = @{ @"invitee": invitee };
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
    NSError *error = nil;
    if (![self.mySession sendData:data
                          toPeers:self.mySession.connectedPeers
                         withMode:MCSessionSendDataReliable
                            error:&error]) {
        NSLog(@"[Error] %@", error);
    }
}

@end
