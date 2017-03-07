//
//  BBConnectViewController.m
//  BattleBump
//
//  Created by Dave Augerinos on 2017-03-06.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

#import "BBConnectViewController.h"
#import "BattleBump-Swift.h"

@interface BBConnectViewController () <BBConnectServiceManagerDelegate>

@property (strong, nonatomic)  BBConnectServiceManager *connectServiceManager;

// Testing
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *connectedLabel;


@end

@implementation BBConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.connectServiceManager = [[BBConnectServiceManager alloc] init];
    self.connectServiceManager.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)connectedDevicesChangedWithManager:(BBConnectServiceManager *)manager connectedDevices:(NSArray<NSString *> *)connectedDevices {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
        
        if(connectedDevices) {
            
            self.connectedLabel.text = [connectedDevices firstObject];
        }
    }];
}


-(void)receivedPlayWithManager:(BBConnectServiceManager *)manager play:(NSString *)play {
 
    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
        
        self.resultLabel.text = play;
    }];
}


// Testing

- (IBAction)rockButtonPressed:(UIButton *)sender {

    [self.connectServiceManager sendWithPlay:@"👊"];
}


- (IBAction)paperButtonPressed:(UIButton *)sender {
    
    [self.connectServiceManager sendWithPlay:@"✋"];
}


- (IBAction)scissorsButtonPressed:(UIButton *)sender {

    [self.connectServiceManager sendWithPlay:@"✌️"];
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
