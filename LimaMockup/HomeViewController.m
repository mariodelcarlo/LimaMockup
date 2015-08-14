//
//  HomeViewController.m
//  LimaMockup
//
//  Created by Marie-Odile Del Carlo on 13/08/2015.
//  Copyright (c) 2015 Marie-Odile Del Carlo. All rights reserved.
//

#import "HomeViewController.h"
#import "LimaDocumentTableViewCell.h"
#import "LimaDocument.h"

NSString * LIMA_URL_STR = @"http://ioschallenge.api.meetlima.com";

@interface HomeViewController()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSArray *limaDocuments;
@end

@implementation HomeViewController

#pragma mark view life cycle methods

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadDocuments];
    self.title = @"Your documents";
}


-(void)viewDidLoad{
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor lightGrayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshDocuments) forControlEvents:UIControlEventValueChanged];
}

#pragma mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.limaDocuments.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"LimaDocumentCell";
    LimaDocumentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    LimaDocument *document = self.limaDocuments[indexPath.row];
    cell.fileNameLabel.text = document.fileName;
    cell.iconImageView.image = document.iconImage;
    
    if(document.mimeType == MimeTypeDirectory){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark private methods
- (void)refreshDocuments {
    //TODO: refresh your data
    [self loadDocuments];
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (void)loadDocuments{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    __weak HomeViewController *weakSelf = self;
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:config];
    NSURL * url = [NSURL URLWithString:LIMA_URL_STR];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(!error){
            NSHTTPURLResponse * urlResponse = (NSHTTPURLResponse*)response;
            if (urlResponse.statusCode == 200) {
                NSError *jsonError = nil;
                
                NSArray *documentsArray = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:NSJSONReadingAllowFragments
                                                                             error:&jsonError];
                if(!jsonError){
                    NSMutableArray * documentsFound  = [[NSMutableArray alloc] init];
                    for (NSString * fileName in documentsArray){
                        LimaDocument * newDoc = [[LimaDocument alloc] initWithFileName:fileName];
                        [documentsFound addObject:newDoc];
                        [weakSelf getFileInfoForFileName:fileName];
                    }
                    weakSelf.limaDocuments = documentsFound;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        [weakSelf.tableView reloadData];
                    });
                }
                else{
                    [self handleWBErrorWithError:jsonError];
                }
            }
            else{
                NSError *statusError = [NSError errorWithDomain:@"Status Error" code:144 userInfo:nil];
                [self handleWBErrorWithError:statusError];
            }
        }
        else{
            [self handleWBErrorWithError:error];
        }
    }];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [task resume];
}


- (void)getFileInfoForFileName:(NSString*)theFileName{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    __weak HomeViewController *weakSelf = self;
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:config];
    
    NSString *request = [NSString stringWithFormat:@"%@/%@?stat",LIMA_URL_STR,theFileName];
    NSURL * url = [NSURL URLWithString:request];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(!error){
            NSHTTPURLResponse * urlResponse = (NSHTTPURLResponse*)response;
            if (urlResponse.statusCode == 200) {
                NSError *jsonError = nil;
                
                NSDictionary *documentsDictionnary = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:NSJSONReadingAllowFragments
                                                                            error:&jsonError];
                if(!jsonError){
                    NSString *mime = [documentsDictionnary objectForKey:@"mimetype"];
                    NSString *path = [documentsDictionnary objectForKey:@"path"];
                    NSUInteger docIndex = [weakSelf.limaDocuments indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                        if ([[(LimaDocument *)obj fileName] isEqualToString:theFileName]) {
                            *stop = YES;
                            return YES;
                        }
                        return NO;
                    }];
                    
                    if (docIndex != NSNotFound) {
                        LimaDocument *document = weakSelf.limaDocuments[docIndex];
                        document.mimeType = [LimaDocument mimeTypeForMimeString:mime];
                        document.filePath = path;
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:docIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                        });
                    }
                }
                else{
                    [self handleWBErrorWithError:jsonError];
                }
            }
            else{
                NSError *statusError = [NSError errorWithDomain:@"Status Error" code:144 userInfo:nil];
                [self handleWBErrorWithError:statusError];
            }
        }
        else{
            [self handleWBErrorWithError:error];
        }
    }];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [task resume];

}

- (void) handleWBErrorWithError:(NSError*)theError{
    
    NSLog(@"WB error:%@",theError);
}

@end
