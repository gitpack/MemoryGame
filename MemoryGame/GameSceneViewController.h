//
//  GameSceneViewController.h
//  MemoryGame
//
//  Created by Anil Kumar on 17/05/15.
//  Copyright (c) 2015 Shokeen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameSceneViewController : UIViewController
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonviews;
@property (strong, nonatomic) IBOutlet UILabel *gameScoreLabel;
-(IBAction)tileClicked:(id)sender;

@end