//
//  DirectoryListViewController.h
//  LimaMockup
//
//  Created by Marie-Odile Del Carlo on 13/08/2015.
//  Copyright (c) 2015 Marie-Odile Del Carlo. All rights reserved.
//

#import <UIKit/UIKit.h>

//Controller listing a directory
@interface DirectoryListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
//the path of the directory to list. If nil, we list the content of the endpoint of the API
@property(nonatomic,assign)NSString *directoyPath;
@end
