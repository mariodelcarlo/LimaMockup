//
//  DetailImageViewController.h
//  LimaMockup
//
//  Created by Marie-Odile Del Carlo on 14/08/2015.
//  Copyright (c) 2015 Marie-Odile Del Carlo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

//Controller for displaying an image
@interface DetailImageViewController : DetailViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UIImageView * imageView;
@end
