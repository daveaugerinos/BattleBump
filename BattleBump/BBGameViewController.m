//
//  BBGameViewController.m
//  BattleBump
//
//  Created by Dave Augerinos & Callum Davies on 2017-03-06.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

#import "BBGameViewController.h"
#import "BattleBump-Swift.h"
#import "GameLogicManager.h"
#import "BBNetworkManager.h"

@interface BBGameViewController  ()

@property (weak, nonatomic) IBOutlet UICircularProgressRingView *progressRing;
@property (weak, nonatomic) IBOutlet UILabel *rockLabel;
@property (weak, nonatomic) IBOutlet UILabel *theirLastMoveLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) UIImageView *rockConfirmationIcon;
@property (weak, nonatomic) IBOutlet UILabel *paperLabel;
@property (strong, nonatomic) UIImageView *paperConfirmationIcon;
@property (weak, nonatomic) IBOutlet UILabel *scissorsLabel;
@property (strong, nonatomic) UIImageView *scissorsConfirmationIcon;
@property (weak, nonatomic) IBOutlet UILabel *currentPlayGameLabel;
@property (strong, nonatomic) GameLogicManager *gameLogicManager;
@property (weak, nonatomic) IBOutlet UILabel *giantMoveLabel;
@property (strong, nonatomic) Invitee *opponent;
@property (strong, nonatomic) Invitee *me;

@end

@implementation BBGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.gameLogicManager = [[GameLogicManager alloc] init];

    [self configureAndEnableViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.me = self.playerInviteesArray[0];
    self.opponent = self.playerInviteesArray[1];
    self.currentPlayGameLabel.text = [NSString stringWithFormat:@"You are playing %@ for stakes: %@", self.opponent.player.name, self.opponent.game.stakes];
    self.networkManager.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)readyButtonPressed:(UIButton *)sender
{
    if([self.me.game.state isEqualToString:@"ready"] && [self.opponent.game.state isEqualToString:@"ready"]) {
        
        self.rockLabel.userInteractionEnabled = YES;
        self.paperLabel.userInteractionEnabled = YES;
        self.scissorsLabel.userInteractionEnabled = YES;
        
        self.theirLastMoveLabel.text = @"";
        self.resultLabel.text = @"";
        
        self.rockConfirmationIcon.alpha = 0.0;
        self.paperConfirmationIcon.alpha = 0.0;
        self.scissorsConfirmationIcon.alpha = 0.0;
        
        self.progressRing.alpha = 1.0;
        self.giantMoveLabel.alpha = 0.0;
        
        if(self.gameLogicManager.myConfirmedMove) {
            self.gameLogicManager.myConfirmedMove = nil;
        }
        
        [self.progressRing setProgressWithValue:(0.0) animationDuration:5.0 completion:^(void) {
            
            //picks random move if user hasn't chosen one by the time timer completes
            if (!self.gameLogicManager.myConfirmedMove) {
                [self.gameLogicManager pickRandomMove];
                NSLog(@"randomly picked: %@", self.gameLogicManager.myConfirmedMove);
            }
            
            [self drawGiantMoveLabel];
            self.progressRing.alpha = 0.0;
            //prevent choice after timer has run out
            [self disableMoveChoice];
            
            [self.progressRing setProgressWithValue:5.0 animationDuration:0.1 completion:nil];
            
            //set round over
            self.me.game.state = @"roundOver";
            self.me.player.move = self.gameLogicManager.myConfirmedMove;
            
            //notify opponent
            NSLog(@"Did Send");
            [self.networkManager send:self.me];
        }];
    }
}

-(void)drawGiantMoveLabel
{
    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
        self.giantMoveLabel.alpha = 1.0;
        NSUInteger i = self.gameLogicManager.myConfirmedMove.length;
        switch (i) {
            case 4:
                self.giantMoveLabel.text = @"👊🏽";
                break;
            case 5:
                self.giantMoveLabel.text = @"✋🏽";
                break;
            case 8:
                self.giantMoveLabel.text = @"✌🏽";
                break;
            default:
                break;
        }
        [self.giantMoveLabel setFont:[self.giantMoveLabel.font fontWithSize:175]];
    }];
}

-(void)disableMoveChoice
{
    self.rockLabel.userInteractionEnabled = NO;
    self.paperLabel.userInteractionEnabled = NO;
    self.scissorsLabel.userInteractionEnabled = NO;
}

-(void)configureAndEnableViews
{
    self.rockLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *confirmRock = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didConfirmRock)];
    [self.rockLabel addGestureRecognizer:confirmRock];

    self.paperLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *confirmPaper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didConfirmPaper)];
    [self.paperLabel addGestureRecognizer:confirmPaper];

    self.scissorsLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *confirmScissors = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didConfirmScissors)];
    [self.scissorsLabel addGestureRecognizer:confirmScissors];
}

#pragma mark - Confirmations -

-(void)didConfirmRock
{
    if(!self.rockConfirmationIcon) {
        self.rockConfirmationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.rockLabel.bounds.origin.x, self.rockLabel.bounds.origin.y, self.rockLabel.bounds.size.width, self.rockLabel.bounds.size.height)];
        self.rockConfirmationIcon.image = [[UIImage imageNamed:@"confirmationTick"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.rockConfirmationIcon.tintColor = [UIColor greenColor];
        [self.rockLabel addSubview:self.rockConfirmationIcon];
    }

    //hide other confirmations
    self.rockConfirmationIcon.alpha = 0.5;
    self.paperConfirmationIcon.alpha = 0.0;
    self.scissorsConfirmationIcon.alpha = 0.0;

    self.gameLogicManager.myConfirmedMove = @"Rock";
}

-(void)didConfirmPaper
{
    if(!self.paperConfirmationIcon) {
        self.paperConfirmationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.paperLabel.bounds.origin.x, self.paperLabel.bounds.origin.y, self.paperLabel.bounds.size.width, self.paperLabel.bounds.size.height)];
        self.paperConfirmationIcon.image = [[UIImage imageNamed:@"confirmationTick"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.paperConfirmationIcon.tintColor = [UIColor greenColor];
        [self.paperLabel addSubview:self.paperConfirmationIcon];
    }

    //hide other confirmations
    self.paperConfirmationIcon.alpha = 0.5;
    self.rockConfirmationIcon.alpha = 0.0;
    self.scissorsConfirmationIcon.alpha = 0.0;

    self.gameLogicManager.myConfirmedMove = @"Paper";
}

-(void)didConfirmScissors
{
    if(!self.scissorsConfirmationIcon) {
        self.scissorsConfirmationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.scissorsLabel.bounds.origin.x, self.scissorsLabel.bounds.origin.y, self.scissorsLabel.bounds.size.width, self.scissorsLabel.bounds.size.height)];
        self.scissorsConfirmationIcon.image = [[UIImage imageNamed:@"confirmationTick"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.scissorsConfirmationIcon.tintColor = [UIColor greenColor];
        [self.scissorsLabel addSubview:self.scissorsConfirmationIcon];
    }

    //hide other confirmations
    self.scissorsConfirmationIcon.alpha = 0.5;
    self.rockConfirmationIcon.alpha = 0.0;
    self.paperConfirmationIcon.alpha = 0.0;

    self.gameLogicManager.myConfirmedMove = @"Scissors";
}

-(void)roundConclusion
{
    //update my views
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        self.theirLastMoveLabel.text = [NSString stringWithFormat:@"%@'s move: %@", self.opponent.player.name, self.opponent.player.move];
        
        self.resultLabel.text = [self.gameLogicManager generateResultsLabelWithMoves];
    }];
    
    
   // self.me.game.state = @"ready";
    
    
    [self.networkManager send:self.me];
    
    self.me.game.state = @"ready";
    self.opponent.game.state = @"ready";
}

#pragma mark - Networking -

-(void)receivedInviteeMessage:(Invitee *)invitee
{
 //   self.opponent = invitee;
    self.gameLogicManager.theirConfirmedMove = invitee.player.move;
    
    if([invitee.game.state isEqualToString:@"roundOver"] && [self.me.game.state isEqualToString:@"roundOver"]) {
    
        [self roundConclusion];
        
    }
}



@end
