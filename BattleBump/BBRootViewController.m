//
//  BBRootViewController.m
//  BattleBump
//
//  Created by Dave Augerinos on 2017-03-06.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

#import "BBRootViewController.h"
#import "BBConnectViewController.h"
#import "BBGameViewController.h"


@interface BBRootViewController ()

@property (strong, nonatomic) NSArray *controllers;

@end

@implementation BBRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = self;
    
    UIStoryboard *connectStoryboard = [UIStoryboard storyboardWithName:@"Connect" bundle:nil];
    BBConnectViewController *connectVC = [connectStoryboard instantiateViewControllerWithIdentifier:@"Connect"];
    
    UIStoryboard *gameStoryboard = [UIStoryboard storyboardWithName:@"Game" bundle:nil];
    BBGameViewController *gameVC = [gameStoryboard instantiateViewControllerWithIdentifier:@"Game"];
    
    self.controllers = @[connectVC, gameVC];
    
    [self setViewControllers:@[connectVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
 
    if([viewController isKindOfClass:[BBConnectViewController class]]) {
        return nil;
    }
    
    else if ([viewController isKindOfClass:[BBGameViewController class]]) {
        return self.controllers[0];
    }
    
    return nil;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    if([viewController isKindOfClass:[BBConnectViewController class]]) {
        return self.controllers[1];;
    }
    
    else if ([viewController isKindOfClass:[BBGameViewController class]]) {
        return nil;
    }
    
    return nil;
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
