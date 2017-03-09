//
//  BBConnectViewController.m
//  BattleBump
//
//  Created by Dave Augerinos on 2017-03-06.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

#import "BBConnectViewController.h"
#import "BBConnectCollectionViewCell.h"
#import "BattleBump-Swift.h"

@interface BBConnectViewController ()

@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerEmojiLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameStakesLabel;
@property (weak, nonatomic) IBOutlet UITextField *playerNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *playerEmojiTextField;
@property (weak, nonatomic) IBOutlet UITextField *gameNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *chooseInviteesLabel;
@property (weak, nonatomic) IBOutlet UITextField *gameStakesTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *inviteeCollectionView;
@property (strong, nonatomic) NSMutableArray <Invitee *> *invitees;
@property (strong, nonatomic) Invitee *me;

@property (strong, nonatomic) MCPeerID *myPeerID;
@property (strong, nonatomic) MCNearbyServiceAdvertiser *myAdvertiser;
@property (strong, nonatomic) MCNearbyServiceBrowser *myBrowser;
@property (strong, nonatomic) MCSession *mySession;
//@property (strong, nonatomic) MCBrowserViewController *browserViewController;

// Testing
@property (weak, nonatomic) IBOutlet UILabel *connectedToLabel;

@end

@implementation BBConnectViewController

static NSString * const BBRPSServiceType = @"BBRPS-game";
static NSString * const reuseIdentifier = @"inviteeCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.invitees = [[NSMutableArray alloc] init];
    NSLog(@"Invitee Array count: %lu", (unsigned long)[self.invitees count]);
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.invitees count];;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BBConnectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    Invitee *invitee = [self.invitees objectAtIndex:indexPath.row];
    cell.invitee = invitee;
    
    return cell;
}


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
}

// MCSession Delegate callback when receiving data from a peer in a given session
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSLog(@"Received data from %@", peerID.displayName);
    
    NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    Invitee *invitee = dictionary[@"invitee"];
        
    [self receivedInviteeMessage:(Invitee *) invitee];
}


- (void)receivedInviteeMessage:(Invitee *) invitee {
    
    if([self.invitees count] == 0) {
        
        [self.invitees addObject:invitee];
    }
    
    else {
        
        for(Invitee *myInvitee in self.invitees) {
            
            if (! [myInvitee.player.name isEqualToString:invitee.player.name]) {
                
                [self.invitees addObject:invitee];
                NSLog(@"Count %lu", [self.invitees count]);
            }
        }
    }
    [self.inviteeCollectionView reloadData];
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


#pragma mark - MultipeerConnectivity Methods -

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


#pragma mark - MCNearbyServiceAdvertiserDelegate -

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{

    invitationHandler(YES, self.mySession);
}


#pragma mark - IBActions methods -

- (IBAction)joinButtonPressed:(UIButton *)sender {
    
    // if valid advertise or invite
    // populate collection view
    
    NSString *playerName = self.playerNameTextField.text;
    NSString *playerEmoji = self.playerEmojiTextField.text;
    NSString *gameName = self.gameNameTextField.text;
    NSString *gameStakes = self.gameStakesTextField.text;
    
    // Check for valid player name
    // Check for valid emoji
    // Check for valid game name
    // Check for valid game stakes
    
    Player *player = [[Player alloc] initWithName:playerName emoji:playerEmoji move:@"init"];
    Game *game = [[Game alloc] initWithName:gameName stakes:gameStakes state:@"init"];
    self.me = [[Invitee alloc]initWithPlayer:player game:game];
    
    [self joinWithInvitee:self.me];
}


- (IBAction)startGameButtonPressed:(UIButton *)sender {

    NSLog(@"Start Game!\n");
    
    NSDictionary *dictionary = @{ @"invitee": self.me };

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
    NSError *error = nil;
    if (![self.mySession sendData:data
                        toPeers:self.mySession.connectedPeers
                       withMode:MCSessionSendDataReliable
                          error:&error]) {
        NSLog(@"[Error] %@", error);
    }
}


#pragma mark - UITextFieldDelegate methods -

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view endEditing:YES];
}


#pragma mark - Helper -

//- (NSArray *)prepareDataSource {
//    
//    Player *player1 = [[Player alloc] initWithName:@"Callum" emoji:@"💂"];
//    Player *player2 = [[Player alloc] initWithName:@"Dave" emoji:@"👨‍✈️"];
//    Player *player3 = [[Player alloc] initWithName:@"Mystery Player" emoji:@"🕴"];
//    Game *game1 = [[Game alloc] initWithName:@"BeerWarz" stakes:@"Loser buys beer"];
//    Game *game2 = [[Game alloc] initWithName:@"Mysterious" stakes:@"is mystery"];
//    
//    Invitee *invitee1 = [[Invitee alloc] initWithPlayer:player1 game:game1];
//    Invitee *invitee2 = [[Invitee alloc] initWithPlayer:player2 game:game1];
//    Invitee *invitee3 = [[Invitee alloc] initWithPlayer:player3 game:game2];
//                       
//    NSArray *initialArray = @[invitee1, invitee2, invitee3];
//    
//    return initialArray;
//}

@end
