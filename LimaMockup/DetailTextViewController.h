//
//  DetailTextViewController.h
//  LimaMockup
//
//  Created by Marie-Odile Del Carlo on 17/08/2015.
//  Copyright (c) 2015 Marie-Odile Del Carlo. All rights reserved.
//

#import "DetailViewController.h"

//Controller for displaying a text file
@interface DetailTextViewController : DetailViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end
