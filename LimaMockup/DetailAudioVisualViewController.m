//
//  DetailAudioVisualViewController.m
//  LimaMockup
//
//  Created by Marie-Odile Del Carlo on 14/08/2015.
//  Copyright (c) 2015 Marie-Odile Del Carlo. All rights reserved.
//

#import "DetailAudioVisualViewController.h"
#import "Constants.h"
#import <AVFoundation/AVFoundation.h>

@interface DetailAudioVisualViewController()
@property (nonatomic, strong) MPMoviePlayerController * player;
@property (nonatomic, strong) UIActivityIndicatorView * activity;
@end

@implementation DetailAudioVisualViewController

#pragma mark view life cycle
-(void)viewDidLoad{
    [super viewDidLoad];
    [self loadMedia];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieLoadStateDidChange:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:self.player];
    
    [self.activity startAnimating];
}


-(void)viewWillDisappear:(BOOL)animated{
    [self.player stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

#pragma mark private methods
//Init the url for the sound or video and the player
- (void)loadMedia{
    NSString *request = [NSString stringWithFormat:@"%@%@",LIMA_API_URL,self.filePath];
    NSString *escapedRequest = [request stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //Checks the extension in order to see if MPMoviePlayerController can play the media
    if ([self isMediaFileSupportedForPath:escapedRequest]){
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
        [self.player setFullscreen:YES animated:NO];
        self.player.backgroundView.backgroundColor = [UIColor whiteColor];
        self.player.repeatMode = MPMovieRepeatModeNone;
        self.player.shouldAutoplay = NO;
        [self.view addSubview: [self.player view]];
        
        //Add an activity indicator while the media is loading
        self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activity.center = self.view.center;
        [self.view addSubview:self.activity];
    }
    else{
        //Not supported, TODO add some process to read unsuppported files
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"warning", @"warning")
                                                           message:NSLocalizedString(@"audioVisualNotSupportedFileMessage", @"audioVisualNotSupportedFileMessage")
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
    }
}

- (NSArray *)playerSupportedFileExtension{
    static NSArray *names;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        names = @[@".mov", @".mp4", @".mpv", @".3gp", @".mp3"];
    });
    
    return names;
}

- (BOOL)isMediaFileSupportedForPath:(NSString *)thePath{
    NSRange range = [thePath rangeOfString:@"." options:NSBackwardsSearch range:NSMakeRange(0, thePath.length)];
    if(range.location != NSNotFound){
        NSString * extension = [[thePath substringFromIndex:range.location] lowercaseString];
        if ([[self playerSupportedFileExtension] containsObject:extension]){
            return true;
        }
    }
    return false;
}

#pragma mark MPMoviePlayerLoadStateDidChangeNotification
-(void)movieLoadStateDidChange:(id)sender{
    if(self.player.loadState == MPMovieLoadStatePlayable || self.player.loadState == MPMovieLoadStatePlaythroughOK){
        if(self.activity){
            [self.activity stopAnimating];
            [self.activity removeFromSuperview];
        }
        if (self.player.playbackState != MPMoviePlaybackStatePlaying){
            [self.player play];
        }
    }
}
@end
