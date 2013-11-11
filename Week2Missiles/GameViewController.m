//
//  GameViewController.m
//  Week2Missiles
//
//  Created by Christopher J Di Luccia on 10/28/13.
//  Copyright (c) 2013 Christopher J Di Luccia. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Box.h"
#import "GameViewController.h"
#import "Utility.h"

#define SCREEN_WIDTH self.view.frame.size.width
#define SCREEN_HEIGHT self.view.frame.size.height

@interface GameViewController ()
{
    bool gameOver;
    int highScore;
    int score;
    int health;
    int enemySpawnFrequency;
    NSMutableArray * enemyArray;
    NSMutableArray * missileArray;
    NSTimer * spawnBox;
    UILabel * scoreLabel;
    UILabel * healthLabel;
    UILabel * highScoreLabel;
    UILabel * gameOverLabel;
    UILabel * newHighScoreLabel;
    UIButton * playAgainButton;
    
    float rise;//used for calculation slope for missile trajectory (rise over run)
    float run;//used for calculation slope for missile trajectory (rise over run)
}

@end

@implementation GameViewController

- (void)viewDidLoad
{
    enemySpawnFrequency = 2;
    
    gameOver = NO;
    
    highScore = [[NSUserDefaults standardUserDefaults] integerForKey: @"highScore"];
    
    score = 0;
    health = 100;
    
    scoreLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, SCREEN_HEIGHT-20, 100, 20)];
    scoreLabel.font = [UIFont fontWithName: @"Times New Roman" size: 14];
    scoreLabel.text = [NSString stringWithFormat:@"SCORE: %d", score];
    [self.view addSubview:scoreLabel];
    
    healthLabel = [[UILabel alloc] initWithFrame: CGRectMake(110, SCREEN_HEIGHT-20, 100, 20)];
    healthLabel.font = [UIFont fontWithName: @"Times New Roman" size: 14];
    healthLabel.text = [NSString stringWithFormat:@"HEALTH: %d", health];
    [self.view addSubview:healthLabel];
    
    highScoreLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 20, 200, 20)];
    highScoreLabel.font = [UIFont fontWithName: @"Times New Roman" size: 14];
    highScoreLabel.text = [NSString stringWithFormat:@"HIGH SCORE: %d", highScore];
    [self.view addSubview:highScoreLabel];
    
    gameOverLabel = [[UILabel alloc] initWithFrame: CGRectMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, 150, 24)];
    gameOverLabel.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
    gameOverLabel.font = [UIFont fontWithName: @"Times New Roman" size: 24];
    gameOverLabel.text = [NSString stringWithFormat:@"GAME OVER!"];
    
    newHighScoreLabel = [[UILabel alloc] initWithFrame: CGRectMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, 200, 24)];
    newHighScoreLabel.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
    newHighScoreLabel.font = [UIFont fontWithName: @"Times New Roman" size: 18];
    
    playAgainButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    playAgainButton.frame = CGRectMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 4, 100, 24);
    playAgainButton.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 1.5);
    [playAgainButton setTitle:@"Play Again?" forState:UIControlStateNormal];
    [playAgainButton addTarget:self
                    action:@selector(playAgainButtonAction)
          forControlEvents:UIControlEventTouchUpInside];
    
    enemyArray = [[NSMutableArray alloc]init];
    missileArray = [[NSMutableArray alloc]init];
    
    [self spawnAnEnemy];
    
    CADisplayLink * displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(stepWorld)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    spawnBox = [NSTimer scheduledTimerWithTimeInterval:enemySpawnFrequency
                                                target:self
                                              selector:@selector(spawnAnEnemy)
                                              userInfo:Nil
                                               repeats:YES];
    
}

-(void)stepWorld
{
    if(health == 0)//check if health is gone / user is killed
    {
        healthLabel.text = [NSString stringWithFormat:@"HEALTH: %d", health];
        gameOver = YES;
        if(score > highScore)
        {
            highScoreLabel.text = [NSString stringWithFormat:@"HIGH SCORE: %d", score];
            newHighScoreLabel.text = [NSString stringWithFormat:@"NEW HIGH SCORE: %d", score];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:score forKey:@"highScore"];
            [defaults synchronize];
            [self.view addSubview:newHighScoreLabel];
        }
        else
        {
            [self.view addSubview:gameOverLabel];
        }
        
        [self.view addSubview:playAgainButton];
    }
    
    if(!gameOver)
    {//don't bother continuing to update the score or the health if the game is over
        scoreLabel.text = [NSString stringWithFormat:@"SCORE: %d", score];
        healthLabel.text = [NSString stringWithFormat:@"HEALTH: %d", health];
    }
    ////////////////motion code here/////////////////
    for (int v = 0; v < enemyArray.count; v++)
    {
        Box *tempEnemyMotion = [enemyArray objectAtIndex:v];
        
        tempEnemyMotion.center =
        CGPointMake(tempEnemyMotion.center.x+tempEnemyMotion.deltaX, tempEnemyMotion.center.y+tempEnemyMotion.deltaY);//give the enemy motion
    }
    for(int w = 0; w < missileArray.count; w++)
    {
        Box *tempMissileMotion = [missileArray objectAtIndex:w];
        tempMissileMotion.center =
        CGPointMake(tempMissileMotion.center.x-tempMissileMotion.deltaX, tempMissileMotion.center.y-tempMissileMotion.deltaY);//give the missile motion
    }
    ///////////end motion code/////////////////////
    
    ///////////collision code here/////////////////
    for (int i = 0; i < enemyArray.count; i++)
    {
        Box *tempEnemy = [enemyArray objectAtIndex:i];
        
        if(tempEnemy.center.y > SCREEN_HEIGHT)//check if an enemy reached the bottom
        {
            [enemyArray removeObject:tempEnemy];
            [tempEnemy removeFromSuperview];
            health -= 10;
        }
        
        for (int m = 0; m < missileArray.count; m++)
        {
            Box *tempMissile = [missileArray objectAtIndex:m];
            
            if(CGRectIntersectsRect(tempEnemy.frame, tempMissile.frame))//check if an enemy was hit by a missile
            {//remove both the enemy and the missile if they collide, the increase the score
                [enemyArray removeObject:tempEnemy];
                [tempEnemy removeFromSuperview];
                [missileArray removeObject:tempMissile];
                [tempMissile removeFromSuperview];
                score+=10;
            }
            if((tempMissile.center.y < 0) || (tempMissile.center.x < 0))//check if a missile is off the screen
            {
                [missileArray removeObject:tempMissile];
                [tempMissile removeFromSuperview];
            }
        }
    }
    ///////////end collision code//////////////
}

-(void)spawnAnEnemy
{
    
    Box *tempEnemy = [[Box alloc]initMakeMeABox:@"dogface.jpg"];
    
    int radX = arc4random() % (int)SCREEN_WIDTH;
    int radY = 0;
    
    tempEnemy.center = CGPointMake(radX, radY);
    
    tempEnemy.deltaX = 0;
    
    //the code below makes the game harder as you do better for a tetris like effect where the pieces drop faster as your score goes up
    
    if(score < 50)
    {
        tempEnemy.deltaY = 2;
    }
    if(score >= 50 && score<100)
    {
        tempEnemy.deltaY = 5;
    }
    if(score >=100 && score < 150)
    {
        tempEnemy.deltaY = 8;
    }
    if(score >=150 && score < 200)
    {
        tempEnemy.deltaY = 11;
    }
    if(score >=200)
    {
        tempEnemy.deltaY = 15;
    }
    
    [self.view addSubview:tempEnemy];
    //add freshly spawned enemy to the enemy array
    [enemyArray addObject:tempEnemy];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!gameOver)
    {//only allow the user to continue firing missiles if they have health remaining
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint location = [touch locationInView:touch.view];
        [self fireMissile:location];
    }
}

-(void)fireMissile:(CGPoint)point
{
    run = (SCREEN_WIDTH/2) - point.x;
    rise = point.y;
    
    
    if(run >=rise)
    {
        if(run >= 1000)
        {
            run = run / 1000;
            rise = rise / 1000;
        }
        else if(run >= 100)
        {
            run = run / 100;
            rise = rise / 100;
        }
        else if(run >= 10)
        {
            run = run / 10;
            rise = rise / 10;
        }
    }
    else
    {
        if(rise >= 1000)
        {
            run = run / 1000;
            rise = rise / 1000;
        }
        else if(rise >= 100)
        {
            run = run / 100;
            rise = rise / 100;
        }
        else if(rise >= 10)
        {
            run = run / 10;
            rise = rise / 10;
        }
    }
    
    Box *tempMissile = [[Box alloc]initMakeMeABox:@"catface.jpg"];
    
    tempMissile.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT);
    
    tempMissile.deltaX = run;
    tempMissile.deltaY = rise;
    
    [self.view addSubview:tempMissile];
    //add freshly fired missile to the missile array
    [missileArray addObject:tempMissile];
}

- (void) playAgainButtonAction
{
    [gameOverLabel removeFromSuperview];
    [newHighScoreLabel removeFromSuperview];
    [playAgainButton removeFromSuperview];
    health = 100;
    score = 0;
    gameOver = NO;
    
    for (int a = 0; a < enemyArray.count; a++)//remove all enemies from the screen to give a fresh start at a new game
    {
        Box *tempEnemy = [enemyArray objectAtIndex:a];
        [enemyArray removeObject:tempEnemy];
        [tempEnemy removeFromSuperview];
    }
}

@end
