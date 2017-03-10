//
//  BBConnectViewController.m
//  BattleBump
//
//  Created by Dave Augerinos on 2017-03-06.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

#import "BBConnectViewController.h"
#import "BBConnectCollectionViewCell.h"
#import "BBGameViewController.h"
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
@property (strong, nonatomic) BBNetworkManager *networkManager;
@property (strong, nonatomic) NSMutableArray <Invitee *> *invitees;
@property (strong, nonatomic) Invitee *me;
@property (weak, nonatomic) IBOutlet UILabel *connectedToLabel;
@property (strong, nonatomic) NSMutableArray *playerInviteesArray;

@end

@implementation BBConnectViewController

static NSString * const reuseIdentifier = @"inviteeCell";


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.networkManager = [[BBNetworkManager alloc] init];
    self.networkManager.delegate = self;
    
    self.invitees = [[NSMutableArray alloc] init];
    self.playerInviteesArray = [[NSMutableArray alloc] init];
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


#pragma mark - NetworkManager Method -

- (void)receivedInviteeMessage:(Invitee *) invitee {

    if([self.invitees count] == 0) {

        [self.invitees addObject:invitee];
        self.connectedToLabel.text = invitee.player.name;
    }

    else {

        for(Invitee *myInvitee in self.invitees) {

            if (! [myInvitee.player.name isEqualToString:invitee.player.name]) {

                [self.invitees addObject:invitee];
            }
        }
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        
        [self.inviteeCollectionView reloadData];
    }];
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

    [self.networkManager joinWithInvitee:self.me];
}


- (IBAction)sendInviteButtonPressed:(UIButton *)sender {

    NSLog(@"Start Game!\n");
    
    [self.networkManager send:self.me];
}


- (IBAction)startGameButtonPressed:(UIButton *)sender {

    [self performSegueWithIdentifier:@"startGame" sender:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    BBGameViewController *bbgvc = segue.destinationViewController;
    bbgvc.playerInviteesArray = [self.playerInviteesArray mutableCopy];
}


#pragma mark - UITextFieldDelegate methods -

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [self.view endEditing:YES];
}


# pragma mark - UICollectionViewDelegate methods - 

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BBConnectCollectionViewCell *selectedCell = (BBConnectCollectionViewCell *)[self.inviteeCollectionView cellForItemAtIndexPath:indexPath];
    
    Invitee *selectedInvitee = selectedCell.invitee;
    
    [self.playerInviteesArray addObject:self.me];
    [self.playerInviteesArray addObject:selectedInvitee];
    
    for (Invitee *invitee in self.playerInviteesArray) {
        
        invitee.game.state = @"ready";
    }
}

@end
