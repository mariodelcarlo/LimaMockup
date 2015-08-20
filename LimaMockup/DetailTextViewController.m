//
//  DetailTextViewController.m
//  LimaMockup
//
//  Created by Marie-Odile Del Carlo on 17/08/2015.
//  Copyright (c) 2015 Marie-Odile Del Carlo. All rights reserved.
//

#import "DetailTextViewController.h"
#import "Constants.h"
#import "HttpHelper.h"

@implementation DetailTextViewController

#pragma mark view life cycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self loadText];
}

#pragma mark private methods
-(void)loadText{
    __weak DetailTextViewController *weakSelf = self;
    NSString *request = [NSString stringWithFormat:@"%@%@",LIMA_API_URL,self.filePath];
    NSString *escapedRequest = [request stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",escapedRequest);
    NSURL * url = [NSURL URLWithString:escapedRequest];
    [HttpHelper fetchDataForURL:url completion:^(id theData, NSError *error) {
        if(!error){
            NSString * downloadedText = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
            if(!downloadedText){
                downloadedText = [[NSString alloc] initWithData:theData encoding:NSUnicodeStringEncoding];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (downloadedText != nil){
                    weakSelf.textView.text = downloadedText;
                }
                else{
                    weakSelf.textView.text = @"Could not load the text";
                }
            });
        }
        else{
            [HttpHelper handleError:error];
        }
    }];
}

@end
