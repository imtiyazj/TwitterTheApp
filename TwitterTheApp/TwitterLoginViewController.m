//
//  TwitterLoginViewController.m
//  TwitterTheApp
//
//  Created by  Imtiyaz Jariwala on 1/30/17.
//  Copyright © 2017 yahoo. All rights reserved.
//

#import "TwitterLoginViewController.h"
#import "TweetListViewController.h"
#import "TwitterClient.h"

@interface TwitterLoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation TwitterLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginBtn.layer.cornerRadius = 10;
    self.loginBtn.clipsToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onTwitterLogin:(id)sender {
    [[TwitterClient sharedClientInstance] loginWithCompletion:^(User *user, NSError *error) {
        if (error == nil) {
            NSLog(@"LOGIN COMPLETE -- %@", user);
            [[TwitterClient sharedClientInstance] tweetsWithCompletion:^(NSArray *tweets, NSError *error) {
                if (error == nil) {
                    NSLog(@"TWEETS COMPLETE -- %lu", (unsigned long)tweets.count);
            
                    TweetListViewController *listViewContoller = [[TweetListViewController alloc] initWithNibName:@"TweetListViewController" bundle:nil];
            
                    listViewContoller.currentUser = user;
                    [listViewContoller setTimelineTweets: tweets];
            
                    [self.navigationController pushViewController:listViewContoller animated:YES];
                }
                else {
                    NSLog(@"TWEET ERROR --");
                }
            }];
        }
        else {
            NSLog(@"LOGIN ERROR --");
        }
    }];
}

@end
