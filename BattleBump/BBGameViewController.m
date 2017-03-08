//
//  BBGameViewController.m
//  BattleBump
//
//  Created by Dave Augerinos on 2017-03-06.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

#import "BBGameViewController.h"
#import "BattleBump-Swift.h"


@interface BBGameViewController ()

@property (weak, nonatomic) IBOutlet UICircularProgressRingView *progressRing;
@property (weak, nonatomic) IBOutlet UILabel *rockLabel;
@property (weak, nonatomic) IBOutlet UILabel *paperLabel;
@property (weak, nonatomic) IBOutlet UILabel *scissorsLabel;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation BBGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *confirmRock = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(confirmRock)];
    UITapGestureRecognizer *confirmPaper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(confirmPaper)];
    UITapGestureRecognizer *confirmScissors = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(confirmScissors)];
    
    [self.rockLabel addGestureRecognizer:confirmRock];
    self.rockLabel.userInteractionEnabled = YES;
    [self.paperLabel addGestureRecognizer:confirmPaper];
    self.paperLabel.userInteractionEnabled = YES;
    [self.scissorsLabel addGestureRecognizer:confirmScissors];
    self.scissorsLabel.userInteractionEnabled = YES;
    

}

#pragma mark - Confirmation Gestures -

-(void)confirmRock
{
    
    self.paperLabel.alpha = 0.3;
    self.scissorsLabel.alpha = 0.3;
    
    UIImageView *confirmationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.rockLabel.bounds.origin.x, self.rockLabel.bounds.origin.y, self.rockLabel.bounds.size.width, self.rockLabel.bounds.size.height)];
    
    confirmationIcon.image = [UIImage imageNamed:@"confirmationTick"];
    confirmationIcon.userInteractionEnabled = YES;

    [self.rockLabel addSubview:confirmationIcon];
    
    UITapGestureRecognizer *finalConfirmTap = [[UITapGestureRecognizer alloc] initWithTarget:confirmationIcon action:@selector(didConfirmRock)];
}

-(void)confirmPaper
{
    
    self.rockLabel.alpha = 0.3;
    self.scissorsLabel.alpha = 0.3;
    
    UIImageView *confirmationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.paperLabel.bounds.origin.x, self.paperLabel.bounds.origin.y, self.paperLabel.bounds.size.width, self.paperLabel.bounds.size.height)];
    
    confirmationIcon.image = [UIImage imageNamed:@"confirmationTick"];
    confirmationIcon.userInteractionEnabled = YES;
    
    [self.paperLabel addSubview:confirmationIcon];
    
    UITapGestureRecognizer *finalConfirmTap = [[UITapGestureRecognizer alloc] initWithTarget:confirmationIcon action:@selector(didConfirmPaper)];
}

-(void)confirmScissors
{
    self.rockLabel.alpha = 0.3;
    self.paperLabel.alpha = 0.3;
    
    UIImageView *confirmationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.scissorsLabel.bounds.origin.x, self.scissorsLabel.bounds.origin.y, self.scissorsLabel.bounds.size.width, self.scissorsLabel.bounds.size.height)];
    
    confirmationIcon.image = [UIImage imageNamed:@"confirmationTick"];
    confirmationIcon.userInteractionEnabled = YES;
    
    [self.scissorsLabel addSubview:confirmationIcon];
    
    UITapGestureRecognizer *finalConfirmTap = [[UITapGestureRecognizer alloc] initWithTarget:confirmationIcon action:@selector(didConfirmScissors)];
    
}

//-(void)makeCountdown
//{
//    //make frame
//    float counter = 5;
//}
//
//-(void)startCounting
//{
//    
//}

-(void)configureViews
{
    //set up labels, gestures etc
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startCountdown:(UIButton *)sender
{
    
    NSTimeInterval progressTime = 5.0;
    [self.progressRing setProgressWithValue:(0.0) animationDuration:progressTime completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
