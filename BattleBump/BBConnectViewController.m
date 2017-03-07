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

@interface BBConnectViewController () <BBConnectServiceManagerDelegate>

@property (strong, nonatomic)  BBConnectServiceManager *connectServiceManager;
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

@end

@implementation BBConnectViewController

static NSString * const reuseIdentifier = @"inviteeCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.connectServiceManager = [[BBConnectServiceManager alloc] init];
    self.connectServiceManager.delegate = self;
    
    self.invitees = [[self prepareDataSource] mutableCopy];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Communication -

-(void)connectedDevicesChangedWithManager:(BBConnectServiceManager *)manager connectedDevices:(NSArray<NSString *> *)connectedDevices {

    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{

        if(connectedDevices) {

//            self.connectedLabel.text = [connectedDevices firstObject];
        }
    }];
}


-(void)receivedPlayWithManager:(BBConnectServiceManager *)manager play:(NSString *)play {

    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
    

    }];
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



#pragma mark - Actions -

- (IBAction)joinButtonPressed:(UIButton *)sender {

}

- (IBAction)startGamePressed:(UIButton *)sender {
}


#pragma mark - Helper -

- (NSArray *)prepareDataSource {
    
    Player *player1 = [[Player alloc] initWithName:@"Callum" emoji:@"💂"];
    Player *player2 = [[Player alloc] initWithName:@"Dave" emoji:@"👨‍✈️"];
    Player *player3 = [[Player alloc] initWithName:@"Mystery Player" emoji:@"🕴"];
    Game *game1 = [[Game alloc] initWithName:@"BeerWarz" stakes:@"Loser buys beer"];
    Game *game2 = [[Game alloc] initWithName:@"Mysterious" stakes:@"is mystery"];
    
    Invitee *invitee1 = [[Invitee alloc] initWithPlayer:player1 game:game1];
    Invitee *invitee2 = [[Invitee alloc] initWithPlayer:player2 game:game1];
    Invitee *invitee3 = [[Invitee alloc] initWithPlayer:player3 game:game2];
                       
    NSArray *initialArray = @[invitee1, invitee2, invitee3];
    
    return initialArray;
}


@end
