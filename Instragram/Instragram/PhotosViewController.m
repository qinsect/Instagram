//
//  ViewController.m
//  Instragram
//
//  Created by Yanfeng Ma on 9/14/16.
//  Copyright © 2016 Yanfeng Ma. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotoTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "PhotoDetailViewController.h"
#import "DataService.h"
#import "DataUtil.h"

@interface PhotosViewController ()

@property (nonatomic, copy) NSArray* posts;
@property (weak, nonatomic) IBOutlet UITableView *imageTableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation PhotosViewController

static NSString* API_URL = @"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.imageTableView.delegate = self;
    self.imageTableView.dataSource = self;

    // pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.imageTableView insertSubview:self.refreshControl atIndex:0];
    
    // Infinite footer
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    UIActivityIndicatorView *loadingView =
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingView startAnimating];
    loadingView.center = tableFooterView.center;
    [tableFooterView addSubview:loadingView];
    self.imageTableView.tableFooterView = tableFooterView;
    
    // fetch data
    [DataService fetchRequest:API_URL callback:^(NSDictionary* dic) {
        self.posts = [DataUtil getPosts:dic];
        [self.imageTableView reloadData];
    }];
}

- (void)onRefresh {
    [DataService fetchRequest:API_URL callback:^(NSDictionary* dic) {
        self.posts = [DataUtil getPosts:dic];
        if (self.posts && self.posts.count > 0) {
            [self.imageTableView reloadData];
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.posts) {
        return [self.posts count];
    }
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.posts count] > indexPath.row) {
        // photos
        NSDictionary* imageDic = [DataUtil getImageDicFromPost:[self.posts objectAtIndex:indexPath.row]];
        
        if (imageDic) {
            // try to make reasonable scale
            CGFloat width = [[imageDic objectForKey:@"width"] floatValue];
            
            return [[imageDic objectForKey:@"height"] floatValue] * (self.view.frame.size.width/width);
        }
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_imageTableView deselectRowAtIndexPath:indexPath animated:true];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"PhotoTableViewCell";
  
    PhotoTableViewCell *cell = [self.imageTableView dequeueReusableCellWithIdentifier:MyIdentifier forIndexPath:indexPath];
    
    if ([self.posts count] > indexPath.section) {
        NSString* url = [DataUtil getImageUrlFromPost:[self.posts objectAtIndex:indexPath.section]];
        
        if (url) {
            [cell.imageView setImageWithURL: [NSURL URLWithString:url]];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [headerView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.9]];
    
    UIImageView *profileView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [profileView setClipsToBounds:YES];
    profileView.layer.cornerRadius = 15;
    profileView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.8].CGColor;
    profileView.layer.borderWidth = 1;
    
    if ([self.posts count] > section) {
        NSString* url = [DataUtil getImageUrlFromPost:[self.posts objectAtIndex:section]];
        
        // it seems no any image related with profile, so just use this one.
        if (url) {
            [profileView setImageWithURL:[NSURL URLWithString:url]];
            [headerView addSubview:profileView];
        }
    }
    
    // Add a UILabel for the username here
    
    return headerView;
}


-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

// passing the data to detail view controller
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.imageTableView indexPathForCell:cell];
    PhotoDetailViewController *vc = segue.destinationViewController;
    vc.post = [self.posts objectAtIndex:indexPath.section];
}
@end
