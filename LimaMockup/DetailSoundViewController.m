//
//  DetailSoundViewController.m
//  LimaMockup
//
//  Created by Marie-Odile Del Carlo on 14/08/2015.
//  Copyright (c) 2015 Marie-Odile Del Carlo. All rights reserved.
//

#import "DetailSoundViewController.h"
#import "Constants.h"


@implementation DetailSoundViewController

#pragma mark view life cycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self loadSound];
}

#pragma mark private methods
- (void)loadSound{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *request = [NSString stringWithFormat:@"%@%@",LIMA_API_URL,self.filePath];
        NSString *escapedRequest = [request stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:escapedRequest];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        NSError *error =nil;
        self.player = [[AVAudioPlayer alloc] initWithData:data error:&error];
        
        if(!error){
            //Force even if silent swith is on
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
            [self.player prepareToPlay];
            [self.player play];
        }
        else{
            NSLog(@"Error=%@",error);
        }
    });
}

@end
