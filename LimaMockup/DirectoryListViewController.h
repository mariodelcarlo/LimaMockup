//
//  DirectoryListViewController.h
//  LimaMockup
//
//  Created by Marie-Odile Del Carlo on 13/08/2015.
//  Copyright (c) 2015 Marie-Odile Del Carlo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DirectoryListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,assign)NSString *directoyPath;
@end
