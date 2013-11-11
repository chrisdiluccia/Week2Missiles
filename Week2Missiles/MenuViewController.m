//
//  MenuViewController.m
//  Week2Missiles
//
//  Created by Christopher J Di Luccia on 11/10/13.
//  Copyright (c) 2013 Christopher J Di Luccia. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MenuViewController.h"
#import "GameViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

GameViewController *gameViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    ////////dog and cat pulsing animation code//////
    UIImageView *dogView;
    dogView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dogface.jpg"]];
    dogView.frame = CGRectMake(self.view.frame.size.width*.1, self.view.frame.size.height*.2, self.view.frame.size.width * 0.2, self.view.frame.size.height * 0.2);
    
    UIImageView *catView;
    catView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"catface.jpg"]];
    catView.frame = CGRectMake(self.view.frame.size.width*.7, self.view.frame.size.height*.2, self.view.frame.size.width * 0.2, self.view.frame.size.height * 0.2);
    
    [self.view addSubview:dogView];
    [self.view addSubview:catView];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 0.5;
    scaleAnimation.repeatCount = HUGE_VAL;
    scaleAnimation.autoreverses = YES;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.2];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.8];
    
    [dogView.layer addAnimation:scaleAnimation forKey:@"scale"];
    [catView.layer addAnimation:scaleAnimation forKey:@"scale"];
    ////////end dog and cat animation code//////////
    
    /////start game title code///////
    UILabel * titleLabel = [[UILabel alloc]
                            initWithFrame: CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, self.view.frame.size.width * 0.6, self.view.frame.size.height * 0.2)];
    titleLabel.text = [NSString stringWithFormat:@"Pug Blaster!!!"];
    titleLabel.font = [UIFont fontWithName: @"Helvetica-Bold" size: 18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.view addSubview:titleLabel];
    /////end game title code/////////
    
    /////start button code///////////
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    startButton.frame =
    CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 1.5, self.view.frame.size.width * 0.3, self.view.frame.size.height * 0.1);
    [startButton.titleLabel setTextColor:[UIColor blackColor]];
    [startButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [startButton setTitle:@"START" forState:UIControlStateNormal];
    [startButton addTarget:self
                    action:@selector(startAction)
          forControlEvents:UIControlEventTouchUpInside];
    startButton.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/1.5);
    
    [self.view addSubview:startButton];
    /////end start button code/////
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) startAction
{
    gameViewController = [[GameViewController alloc]init];
    [self.navigationController pushViewController:gameViewController animated:NO];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = YES;
}

@end
