//
//  DetailSoundViewController.m
//  LimaMockup
//
//  Created by Marie-Odile Del Carlo on 14/08/2015.
//  Copyright (c) 2015 Marie-Odile Del Carlo. All rights reserved.
//

#import "DetailSoundViewController.h"
#import "Constants.h"
#import <AVFoundation/AVFoundation.h>

@interface DetailSoundViewController()
@property (nonatomic, strong) MPMoviePlayerController * player;
@end

@implementation DetailSoundViewController

#pragma mark view life cycle
-(void)viewDidLoad{
    [super viewDidLoad];
    [self loadSound];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.player play];
}


-(void)viewWillDisappear:(BOOL)animated{
    [self.player stop];
    [super viewWillDisappear:animated];
}

#pragma mark private methods
//Init the url for the sound and the player
- (void)loadSound{
    NSString *request = [NSString stringWithFormat:@"%@%@",LIMA_API_URL,self.filePath];
    NSString *escapedRequest = [request stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:escapedRequest];
    
    //Force even if silent swith is on
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    self.player=[[MPMoviePlayerController alloc]init];
    [self.player setMovieSourceType:MPMovieSourceTypeStreaming];
    [self.player setContentURL:url];
    [self.player prepareToPlay];
    [[self.player view] setFrame:self.view.bounds];
    [self.player view].backgroundColor = [UIColor whiteColor];
    self.player.scalingMode = MPMovieScalingModeNone;
    self.player.controlStyle = MPMovieControlStyleDefault;
    self.player.backgroundView.backgroundColor = [UIColor whiteColor];
    self.player.repeatMode = MPMovieRepeatModeNone;
    [self.view addSubview: [self.player view]];
}

@end
