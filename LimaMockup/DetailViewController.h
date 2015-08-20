//
//  DetailViewController.h
//  LimaMockup
//
//  Created by Marie-Odile Del Carlo on 14/08/2015.
//  Copyright (c) 2015 Marie-Odile Del Carlo. All rights reserved.
//

#import <UIKit/UIKit.h>

//Superclass for Detail View controllers
//Share a fileName and a filePath (and others properties like size that are not used)
@interface DetailViewController : UIViewController
@property (nonatomic, assign) NSString * filePath;
@property (nonatomic, assign) NSString * fileName;
@end
