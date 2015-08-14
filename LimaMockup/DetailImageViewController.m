//
//  DetailImageViewController.m
//  LimaMockup
//
//  Created by Marie-Odile Del Carlo on 14/08/2015.
//  Copyright (c) 2015 Marie-Odile Del Carlo. All rights reserved.
//

#import "DetailImageViewController.h"

@implementation DetailImageViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = self.imageName;
}

@end
