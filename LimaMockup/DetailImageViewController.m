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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = self.imageName;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self loadImage];
}

- (void)loadImage{
     __weak DetailImageViewController *weakSelf = self;
    NSString *request = [NSString stringWithFormat:@"%@%@",LIMA_API_URL,self.imagePath];
    NSURL * url = [NSURL URLWithString:request];
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
