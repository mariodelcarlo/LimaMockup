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
    [self.activity startAnimating];
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
                //remove activity
                [weakSelf.activity stopAnimating];
                [weakSelf.activity removeFromSuperview];
                
                //Chosse between imageView or webView depending if the image is animating
                BOOL isTheImageAnimated = [weakSelf isImageAnimatedForPath:escapedRequest];
                weakSelf.webView.hidden = !isTheImageAnimated;
                weakSelf.imageView.hidden = isTheImageAnimated;
                
                if(!isTheImageAnimated){
                    weakSelf.imageView.image = downloadedImage;
                }
                else{
                    [weakSelf.webView loadData:theData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
                }
            });
        }
        else{
            [HttpHelper handleError:error];
        }
    }];
}

//Indicates if the file which path is given in parameter is a static image or a sequence of images
- (BOOL)isImageAnimatedForPath:(NSString *)thePath{
    NSRange range = [thePath rangeOfString:@"." options:NSBackwardsSearch range:NSMakeRange(0, thePath.length)];
    if(range.location != NSNotFound){
        NSString * extension = [[thePath substringFromIndex:range.location] lowercaseString];
        if ([extension isEqualToString:@".gif"]){
            return true;
        }
    }
    return false;
}
@end
