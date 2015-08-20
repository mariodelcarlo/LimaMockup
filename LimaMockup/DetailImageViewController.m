//
//  DetailImageViewController.m
//  LimaMockup
//
//  Created by Marie-Odile Del Carlo on 14/08/2015.
//  Copyright (c) 2015 Marie-Odile Del Carlo. All rights reserved.
//

#import "DetailImageViewController.h"
#import "HttpHelper.h"
#import "Constants.h"

@implementation DetailImageViewController

#pragma mark view life cycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self loadImage];
}

#pragma mark private methods
- (void)loadImage{
     __weak DetailImageViewController *weakSelf = self;
    NSString *request = [NSString stringWithFormat:@"%@%@",LIMA_API_URL,self.filePath];
    NSString *escapedRequest = [request stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:escapedRequest];
    [HttpHelper fetchDataForURL:url completion:^(id theData, NSError *error) {
        if(!error){
            UIImage *downloadedImage = [UIImage imageWithData:theData];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.imageView.image = downloadedImage;
            });
        }
        else{
            [HttpHelper handleError:error];
        }
    }];
}

@end
