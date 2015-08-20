//
//  DetailViewController.m
//  LimaMockup
//
//  Created by Marie-Odile Del Carlo on 17/08/2015.
//  Copyright (c) 2015 Marie-Odile Del Carlo. All rights reserved.
//

#import "DetailViewController.h"


@implementation DetailViewController

#pragma mark view life cycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = self.fileName;
}

@end
