//
//  PhotoDetailViewController.m
//  Instragram
//
//  Created by Yanfeng Ma on 9/14/16.
//  Copyright © 2016 Yanfeng Ma. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "DataUtil.h"

@interface PhotoDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UILabel *summary;

@end

@implementation PhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.post) {
        NSString* url = [DataUtil getImageUrlFromPost: self.post];
        if (url) {
            [self.detailImageView setImageWithURL: [NSURL URLWithString:url]];
        }
        self.summary.text = [self.post objectForKey:@"summary"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
