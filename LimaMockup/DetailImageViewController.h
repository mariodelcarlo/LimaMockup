//
//  DetailImageViewController.h
//  LimaMockup
//
//  Created by Marie-Odile Del Carlo on 14/08/2015.
//  Copyright (c) 2015 Marie-Odile Del Carlo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailImageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView * imageView;
@property (nonatomic, assign) NSString * imagePath;
@property (nonatomic, assign) NSString * imageName;
@end
