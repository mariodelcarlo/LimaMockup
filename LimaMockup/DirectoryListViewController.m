//
//  DirectoryListViewController.m
//  LimaMockup
//
//  Created by Marie-Odile Del Carlo on 13/08/2015.
//  Copyright (c) 2015 Marie-Odile Del Carlo. All rights reserved.
//

#import "DirectoryListViewController.h"
#import "LimaDocumentTableViewCell.h"
#import "LimaDocument.h"
#import "DetailImageViewController.h"
#import "DetailAudioVisualViewController.h"
#import "DetailTextViewController.h"
#import "HttpHelper.h"
#import "Constants.h"


@interface DirectoryListViewController()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSArray *limaDocuments;
@property (nonatomic, strong) NSIndexPath * selectedRowIndexPath;
@end

@implementation DirectoryListViewController

#pragma mark view life cycle methods
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!self.directoyPath|| [self.directoyPath isEqualToString:@""]){
        self.title = NSLocalizedString(@"myDocumentsTitle", @"myDocumentsTitle");
    }
    else{
         self.title = self.directoyPath;
    }
}


-(void)viewDidLoad{
    [super viewDidLoad];
    [self loadDocumentsForDirectory:self.directoyPath];
    self.selectedRowIndexPath = nil;
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor lightGrayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshDocuments) forControlEvents:UIControlEventValueChanged];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:SHOW_IMAGE_SEGUE]) {
        if (self.selectedRowIndexPath != nil){
            LimaDocument *document = self.limaDocuments[self.selectedRowIndexPath.row];
            DetailImageViewController * destViewConroller = [segue destinationViewController];
            destViewConroller.filePath = document.filePath;
            destViewConroller.fileName = document.fileName;
        }
    }
    else if([segue.identifier isEqualToString:SHOW_AUDIOVISUAL_SEGUE]) {
        if (self.selectedRowIndexPath != nil){
            LimaDocument *document = self.limaDocuments[self.selectedRowIndexPath.row];
            DetailAudioVisualViewController * destViewConroller = [segue destinationViewController];
            destViewConroller.filePath = document.filePath;
            destViewConroller.fileName = document.fileName;
        }
    }
    else if([segue.identifier isEqualToString:SHOW_TEXT_SEGUE]) {
        if (self.selectedRowIndexPath != nil){
            LimaDocument *document = self.limaDocuments[self.selectedRowIndexPath.row];
            DetailTextViewController * destViewConroller = [segue destinationViewController];
            destViewConroller.filePath = document.filePath;
            destViewConroller.fileName = document.fileName;
        }
    }
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

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedRowIndexPath = indexPath;
    LimaDocument *document = self.limaDocuments[indexPath.row];
    switch (document.mimeType) {
        case MimeTypeImage:
            [self performSegueWithIdentifier:SHOW_IMAGE_SEGUE sender:self];
            break;
        
        case MimeTypeSound:
            [self performSegueWithIdentifier:SHOW_AUDIOVISUAL_SEGUE sender:self];
            break;
        
        case MimeTypeVideo:
            [self performSegueWithIdentifier:SHOW_AUDIOVISUAL_SEGUE sender:self];
            break;
        
        case MimeTypeText:
            [self performSegueWithIdentifier:SHOW_TEXT_SEGUE sender:self];
            break;
        
        case MimeTypeDirectory:{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            DirectoryListViewController *dest = [storyboard instantiateViewControllerWithIdentifier:@"Home"];
            dest.directoyPath = document.filePath;
            [self.navigationController pushViewController:dest animated:YES];
        }
            break;
        
        default:
            break;
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark private methods
- (void)refreshDocuments {
    //TODO: refresh your data
    [self loadDocumentsForDirectory:self.directoyPath];
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (void)loadDocumentsForDirectory:(NSString*)thePath{
    __weak DirectoryListViewController *weakSelf = self;
    NSURL * url = nil;
    if(!thePath || [thePath isEqualToString:@""]){
        url = [NSURL URLWithString:LIMA_API_URL];
    }
    else{
        NSString *request = [NSString stringWithFormat:@"%@%@",LIMA_API_URL,thePath];
        NSString *escapedRequest = [request stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        url = [NSURL URLWithString:escapedRequest];
        NSLog(@"%@",escapedRequest);
    }
    
    [HttpHelper fetchJSONForURL:url completion:^(id data, NSError *error) {
        if(error){
            [HttpHelper handleError:error];
        }
        else{
            NSArray * dataArray = (NSArray*) data;
            NSMutableArray * documentsFound  = [[NSMutableArray alloc] init];
            for (NSString * fileName in dataArray){
                LimaDocument * newDoc = [[LimaDocument alloc] initWithFileName:fileName];
                [documentsFound addObject:newDoc];
                [weakSelf getFileInfoForFileName:fileName];
            }
            weakSelf.limaDocuments = documentsFound;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}


- (void)getFileInfoForFileName:(NSString*)theFileName{
    __weak DirectoryListViewController *weakSelf = self;
    NSString *request = nil;
    if(!self.directoyPath || [self.directoyPath isEqualToString:@""]){
        request = [NSString stringWithFormat:@"%@/%@?stat",LIMA_API_URL,theFileName];
    }
    else{
        request = [NSString stringWithFormat:@"%@%@/%@?stat",LIMA_API_URL,self.directoyPath,theFileName];
    }
    
    NSString *escapedString = [request stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",escapedString);
    NSURL * url = [NSURL URLWithString:escapedString];

    [HttpHelper fetchJSONForURL:url completion:^(id data, NSError *error) {
        if(error){
            [HttpHelper handleError:error];
        }
        else{
            NSDictionary * dataDictionnary = (NSDictionary*) data;
            NSString *mime = [dataDictionnary objectForKey:@"mimetype"];
            NSString *path = [dataDictionnary objectForKey:@"path"];
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
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:docIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                });
            }
        }
    }];
    
}

@end
