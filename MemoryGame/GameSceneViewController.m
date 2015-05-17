//
//  GameSceneViewController.m
//  MemoryGame
//
//  Created by Anil Kumar on 17/05/15.
//  Copyright (c) 2015 Shokeen. All rights reserved.
//

#import "GameSceneViewController.h"

@interface GameSceneViewController ()
//Declare Private Properties
//add a blank tile image and an image of the tile that is flipped over
@property UIImage *blankTileImage;
@property UIImage *backTileImage;

//Array of tile images
@property NSMutableArray *tiles;
//Array of shuffled tile IDs
@property NSMutableArray *shuffledTiles;
//How many times did the player get a match
@property NSInteger matchCounter;
//How many times did the player guess
@property NSInteger guessCounter;
//The ID of the first flipped tile
@property NSInteger tileFlipped;
//The first button object that was clicked
@property UIButton *tile1;
//The second button object that was clicked
@property UIButton *tile2;

//Instance Methods
- (void)shuffleTiles;
- (void)resetTiles;
- (void) winner;
@end

@implementation GameSceneViewController
//Local Variables
static bool isDisabled = false;
static bool isMatch = false;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //This is where we will initialize our properties once this scene has loaded
    //Assign images to the blank and back image properties
    self.backTileImage = [UIImage imageNamed:@"back.png"];
    self.blankTileImage = [UIImage imageNamed:@"blank.png"];
    
    //Set the tile flipped variable less than zero so we know that a tile has not been clicked yet
    self.tileFlipped = -1;
    
    //set our guesses and matches to zero
    self.matchCounter = 0;
    self.guessCounter = 0;
    //Show the score at the top of our screen in the tile clicked
    self.gameScoreLabel.text = [NSString stringWithFormat:@"Matches: %d Guesses: %d", self.matchCounter, self.guessCounter];
    
    self.tiles = [[NSMutableArray alloc]initWithObjects:
                  [UIImage imageNamed:@"icons01.png"],
                  [UIImage imageNamed:@"icons01.png"],
                  [UIImage imageNamed:@"icons02.png"],
                  [UIImage imageNamed:@"icons02.png"],
                  [UIImage imageNamed:@"icons03.png"],
                  [UIImage imageNamed:@"icons03.png"],
                  [UIImage imageNamed:@"icons04.png"],
                  [UIImage imageNamed:@"icons04.png"],
                  [UIImage imageNamed:@"icons05.png"],
                  [UIImage imageNamed:@"icons05.png"],
                  [UIImage imageNamed:@"icons06.png"],
                  [UIImage imageNamed:@"icons06.png"],
                  [UIImage imageNamed:@"icons07.png"],
                  [UIImage imageNamed:@"icons07.png"],
                  [UIImage imageNamed:@"icons08.png"],
                  [UIImage imageNamed:@"icons08.png"],
                  [UIImage imageNamed:@"icons09.png"],
                  [UIImage imageNamed:@"icons09.png"],
                  [UIImage imageNamed:@"icons10.png"],
                  [UIImage imageNamed:@"icons10.png"],
                  [UIImage imageNamed:@"icons11.png"],
                  [UIImage imageNamed:@"icons11.png"],
                  [UIImage imageNamed:@"icons12.png"],
                  [UIImage imageNamed:@"icons12.png"],
                  [UIImage imageNamed:@"icons13.png"],
                  [UIImage imageNamed:@"icons13.png"],
                  [UIImage imageNamed:@"icons14.png"],
                  [UIImage imageNamed:@"icons14.png"],
                  [UIImage imageNamed:@"icons15.png"],
                  [UIImage imageNamed:@"icons15.png"],
                  nil];
    [self shuffleTiles];
}

- (void)shuffleTiles
{
    int tileCount = [self.tiles count];
    
    for (int tileID = 0; tileID < (tileCount/2); tileID++)
    {
        [self.shuffledTiles addObject:[NSNumber numberWithInt:tileID]];
        [self.shuffledTiles addObject:[NSNumber numberWithInt:tileID]];
    }
    
    for (NSUInteger i = 0; i < tileCount; ++i) {
        NSInteger nElements = tileCount - i;
        NSInteger n = (arc4random() % nElements) + i;
        [self.shuffledTiles exchangeObjectAtIndex:i withObjectAtIndex:n];
        [self.tiles exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)tileClicked:(id)sender
{
    if(isDisabled == true)
        return;
    int senderID = [sender tag];
    
    if(self.tileFlipped >= 0 && senderID != self.tileFlipped)
    {
        self.tile2 = sender;
        
        UIImage *lastImage = [self.tiles objectAtIndex:self.tileFlipped];
        UIImage *tileImage = [self.tiles objectAtIndex:senderID];
        
        [sender setImage: tileImage forState:UIControlStateNormal];
        self.guessCounter++;
        if(tileImage == lastImage)
        {
            //printf("MATCHING TILES");
            [self.tile1 setEnabled:false];
            [self.tile2 setEnabled:false];
            self.matchCounter++;
            isMatch = true;
        }
        isDisabled = true;
        //set up a timer to flip the tiles over after 1 sec.
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(resetTiles)
                                       userInfo:nil
                                        repeats:NO];
        self.tileFlipped = -1;
    }
    else
    {
        
        self.tileFlipped = senderID;
        self.tile1 = sender;
        UIImage *tileImage = [self.tiles objectAtIndex:senderID];
        [sender setImage: tileImage forState:UIControlStateNormal];
    }
    
    self.gameScoreLabel.text = [NSString stringWithFormat:@"Matches: %d Guesses: %d", self.matchCounter, self.guessCounter];
}

- (void)resetTiles
{
    if(isMatch)
    {
        [self.tile1 setImage: self.blankTileImage forState:UIControlStateNormal];
        [self.tile2 setImage: self.blankTileImage forState:UIControlStateNormal];
    }
    else
    {
        [self.tile1 setImage: self.backTileImage forState:UIControlStateNormal];
        [self.tile2 setImage: self.backTileImage forState:UIControlStateNormal];
    }
    isDisabled = false;
    isMatch = false;
    NSLog(@"%d", (self.tiles.count/2));
    if(self.matchCounter == (self.tiles.count/2))
        [self winner];
}

- (void) winner
{
    self.gameScoreLabel.text = [NSString stringWithFormat:@"You won with %d Guesses", self.guessCounter];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

@end

