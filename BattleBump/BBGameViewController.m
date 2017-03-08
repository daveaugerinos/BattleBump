//
//  BBGameViewController.m
//  BattleBump
//
//  Created by Dave Augerinos on 2017-03-06.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

#import "BBGameViewController.h"
#import "BattleBump-Swift.h"
#import "GameLogicManager.h"
#import "Move.h"

@interface BBGameViewController ()

@property (weak, nonatomic) IBOutlet UICircularProgressRingView *progressRing;
@property (weak, nonatomic) IBOutlet UILabel *rockLabel;
@property (strong, nonatomic) UIImageView *rockConfirmationIcon;
@property (weak, nonatomic) IBOutlet UILabel *paperLabel;
@property (strong, nonatomic) UIImageView *paperConfirmationIcon;
@property (weak, nonatomic) IBOutlet UILabel *scissorsLabel;
@property (strong, nonatomic) UIImageView *scissorsConfirmationIcon;
@property (weak, nonatomic) IBOutlet UILabel *currentPlayGameLabel;
@property (strong, nonatomic) GameLogicManager *gameLogicManager;

@end

@implementation BBGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.gameLogicManager = [[GameLogicManager alloc] init];
    self.gameLogicManager.isGameOn = YES;
    
    [self configureViews];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startCountdown:(UIButton *)sender
{
    
//    NSTimeInterval progressTime = 5.0;
    [self.progressRing setProgressWithValue:(0.0) animationDuration:5.0 completion:^(void){
        
        //picks random move if user hasn't chosen one by the time timer completes
        if (!self.gameLogicManager.myConfirmedMove) {
            int i = arc4random_uniform(3);
            switch (i) {
                case 0:
                    self.gameLogicManager.myConfirmedMove = @"Rock";
                    break;
                case 1:
                    self.gameLogicManager.myConfirmedMove = @"Paper";
                    break;
                case 2:
                    self.gameLogicManager.myConfirmedMove = @"Scissors";
                    break;
                default:
                    break;
            }
            NSLog(@"randomly picked: %@", self.gameLogicManager.myConfirmedMove);

        }
        
        //BIG ICON OF self.gameLogicManager.myConfirmedMove
        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
            UILabel *giantMoveLabel = [[UILabel alloc] initWithFrame:self.progressRing.frame];
            giantMoveLabel.text = self.gameLogicManager.myConfirmedMove;
        }];
        
    }];
    // completion block also needs:  reset values and call setNeedsDisplay on mainQueue
}

-(void)configureViews
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


#pragma mark - Confirmation Gestures -


-(void)didConfirmRock
{
    self.rockConfirmationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.rockLabel.bounds.origin.x, self.rockLabel.bounds.origin.y, self.rockLabel.bounds.size.width, self.rockLabel.bounds.size.height)];
    self.rockConfirmationIcon.image = [[UIImage imageNamed:@"confirmationTick"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.rockConfirmationIcon.tintColor = [UIColor greenColor];
    self.rockConfirmationIcon.alpha = 1.0;
    [self.rockLabel addSubview:self.rockConfirmationIcon];
    
    //hide other confirmations
    self.paperConfirmationIcon.alpha = 0.0;
    self.scissorsConfirmationIcon.alpha = 0.0;
    

    
    self.gameLogicManager.myConfirmedMove = @"Rock";
    NSLog(@"%@", self.gameLogicManager.myConfirmedMove);
}

-(void)didConfirmPaper
{
    self.paperConfirmationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.paperLabel.bounds.origin.x, self.paperLabel.bounds.origin.y, self.paperLabel.bounds.size.width, self.paperLabel.bounds.size.height)];
    self.paperConfirmationIcon.image = [[UIImage imageNamed:@"confirmationTick"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.paperConfirmationIcon.tintColor = [UIColor greenColor];
    self.paperConfirmationIcon.alpha = 1.0;
    [self.paperLabel addSubview:self.paperConfirmationIcon];
    
    //hide other confirmations
    self.rockConfirmationIcon.alpha = 0.0;
    self.scissorsConfirmationIcon.alpha = 0.0;
    
    
    self.gameLogicManager.myConfirmedMove = @"Paper";
    NSLog(@"%@", self.gameLogicManager.myConfirmedMove);
}
-(void)didConfirmScissors
{
    self.scissorsConfirmationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.scissorsLabel.bounds.origin.x, self.scissorsLabel.bounds.origin.y, self.scissorsLabel.bounds.size.width, self.scissorsLabel.bounds.size.height)];
    self.scissorsConfirmationIcon.image = [[UIImage imageNamed:@"confirmationTick"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.scissorsConfirmationIcon.tintColor = [UIColor greenColor];
    self.scissorsConfirmationIcon.alpha = 1.0;
    [self.scissorsLabel addSubview:self.scissorsConfirmationIcon];
    
    
    //hide other confirmations
    self.rockConfirmationIcon.alpha = 0.0;
    self.paperConfirmationIcon.alpha = 0.0;
    
    self.gameLogicManager.myConfirmedMove = @"Scissors";
    NSLog(@"%@", self.gameLogicManager.myConfirmedMove);
}

-(void)removeOtherConfirmationIcons
{
    
}

//-(void)willConfirmRock
//{
//    self.rockLabel.alpha = 1.0;
//    self.paperLabel.alpha = 0.3;
//    self.scissorsLabel.alpha = 0.3;
//
//    UIImageView *confirmationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.rockLabel.bounds.origin.x, self.rockLabel.bounds.origin.y, self.rockLabel.bounds.size.width,   self.rockLabel.bounds.size.height)];
//    confirmationIcon.image = [[UIImage imageNamed:@"confirmationTick"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    confirmationIcon.tintColor = [UIColor greenColor];
//
//    [self.rockLabel addSubview:confirmationIcon];
//
//    confirmationIcon.userInteractionEnabled = YES;
//    UITapGestureRecognizer *finalConfirmTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didConfirmRock)];
//    [confirmationIcon addGestureRecognizer:finalConfirmTap];
//}
//
//-(void)willConfirmPaper
//{
//    self.paperLabel.alpha = 1.0;
//    self.rockLabel.alpha = 0.3;
//    self.scissorsLabel.alpha = 0.3;
//
//    UIImageView *confirmationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.paperLabel.bounds.origin.x, self.paperLabel.bounds.origin.y, self.paperLabel.bounds.size.width, self.paperLabel.bounds.size.height)];
//    confirmationIcon.image = [[UIImage imageNamed:@"confirmationTick"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    confirmationIcon.tintColor = [UIColor greenColor];
//    [self.paperLabel addSubview:confirmationIcon];
//
//    confirmationIcon.userInteractionEnabled = YES;
//    UITapGestureRecognizer *finalConfirmTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didConfirmPaper)];
//    [confirmationIcon addGestureRecognizer:finalConfirmTap];
//}
//
//-(void)willConfirmScissors
//{
//    self.scissorsLabel.alpha = 1.0;
//    self.rockLabel.alpha = 0.3;
//    self.paperLabel.alpha = 0.3;
//    
//    UIImageView *confirmationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.scissorsLabel.bounds.origin.x, self.scissorsLabel.bounds.origin.y, self.scissorsLabel.bounds.size.width, self.scissorsLabel.bounds.size.height)];
//    confirmationIcon.image = [[UIImage imageNamed:@"confirmationTick"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    confirmationIcon.tintColor = [UIColor greenColor];
//    [self.scissorsLabel addSubview:confirmationIcon];
//    
//    confirmationIcon.userInteractionEnabled = YES;
//    UITapGestureRecognizer *finalConfirmTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didConfirmScissors)];
//    [confirmationIcon addGestureRecognizer:finalConfirmTap];
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
