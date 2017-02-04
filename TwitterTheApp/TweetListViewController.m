//
//  TweetListViewController.m
//  TwitterTheApp
//
//  Created by  Imtiyaz Jariwala on 1/30/17.
//  Copyright © 2017 yahoo. All rights reserved.
//

#import "TweetListViewController.h"
#import "TweetTableViewCell.h"
#import "User.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "TwitterLoginViewController.h"
#import "TweetDetailViewController.h"
#import "UserProfileViewController.h"
#import "NewTweetViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface TweetListViewController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tweetTableView;

@property (nonatomic, strong) NSArray<Tweet *> *tweets;

@property (nonatomic) UIRefreshControl *refreshControl;

@end

@implementation TweetListViewController

NSString *const tweetTableViewCell = @"TweetTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureNavigationBar];
    
    self.tweetTableView.dataSource = self;
    self.tweetTableView.delegate = self;
    self.tweetTableView.estimatedRowHeight = 200;
    self.tweetTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tweetTableView insertSubview:self.refreshControl atIndex:0];
    
    UINib *tweetNib = [UINib nibWithNibName: tweetTableViewCell bundle:nil];
    [self.tweetTableView registerNib:tweetNib forCellReuseIdentifier: tweetTableViewCell];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@" -- viewDidAppear -- ");
    [self configureToolBar];
}
- (void)viewWillAppear:(BOOL)animated {
    NSLog(@" -- viewWillAppear -- ");
    [self configureToolBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: tweetTableViewCell forIndexPath: indexPath];
    
    Tweet *tweet = [self.tweets objectAtIndex: indexPath.row];
    cell.tweetId = tweet.tweetId;
    [cell.profileImageView setImageWithURL: [NSURL URLWithString:tweet.author.profileImageUrl]];
    
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileImagePressed:)];
    //imageTap.delegate = self;
    cell.profileImageView.tag = indexPath.row;
    
    [cell.profileImageView addGestureRecognizer:imageTap];
    
    [cell.nameLabel setText: tweet.author.name];
    [cell.handleLabel setText: [NSString stringWithFormat:@"@%@", tweet.author.screenName]];
    [cell.contentLabel setText:tweet.text];
    
    NSDateComponentsFormatter *formatter = [[NSDateComponentsFormatter alloc] init];
    formatter.unitsStyle = NSDateComponentsFormatterUnitsStyleAbbreviated;
    formatter.allowedUnits = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    formatter.maximumUnitCount = 1;
    NSString *elapsed = [formatter stringFromDate:tweet.createdAt toDate:[NSDate date]];
    [cell.timestampLabel setText: elapsed];

    if (tweet.retweetedBy != nil) {
        cell.retweetContainerHeightConstraint.constant = 22;
        [cell.retweetLabel setHidden:NO];
        [cell.retweetImage setHidden:NO];
        [cell.retweetLabel setText:[NSString stringWithFormat:@"%@ Retweeted", tweet.retweetedBy.name]];
    }
    else {
        cell.retweetContainerHeightConstraint.constant = 0;
        [cell.retweetLabel setHidden:YES];
        [cell.retweetImage setHidden:YES];
    }
    
    [cell setNeedsUpdateConstraints];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TweetDetailViewController *detailViewContoller = [[TweetDetailViewController alloc] initWithNibName:@"TweetDetailViewController" bundle:nil];
    
    detailViewContoller.tweet = [self.tweets objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:detailViewContoller animated:YES];
}

- (void) configureNavigationBar {

    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = NO;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:45.0/255.0 green:160.0/255.0 blue:242.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

    
    self.navigationItem.title = @"Home";
    self.navigationItem.hidesBackButton = YES;

    UIBarButtonItem *signOutBtn = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(signOutBtnPressed)];
    self.navigationItem.leftBarButtonItem = signOutBtn;

    UIBarButtonItem *newtBtn = [[UIBarButtonItem alloc] initWithTitle:@"New"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(newBtnPressed)];
    self.navigationItem.rightBarButtonItem = newtBtn;
}

- (void) configureToolBar {
    
    UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [homeBtn setFrame:CGRectMake(0, 0, 230, 230)];
    [homeBtn setImage:[UIImage imageNamed:@"home-icon"] forState:UIControlStateNormal];
    [homeBtn addTarget:self action:@selector(homeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    homeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [homeBtn setTitle:@"Timelines" forState:UIControlStateNormal];
    [homeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [homeBtn sizeToFit];

    UIButton *profileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [profileBtn setImage:[UIImage imageNamed:@"profile-icon"] forState:UIControlStateNormal];
    [profileBtn addTarget:self action:@selector(profileBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    profileBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [profileBtn setTitle:@"Me" forState:UIControlStateNormal];
    [profileBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [profileBtn sizeToFit];
    
    UIBarButtonItem *fixedSpace =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                  target:nil
                                                  action:nil];
    fixedSpace.width = 80;
    
    self.navigationController.toolbar.items = [[NSArray alloc] initWithObjects: [[UIBarButtonItem alloc] initWithCustomView:homeBtn], fixedSpace, [[UIBarButtonItem alloc] initWithCustomView:profileBtn], nil];
}

- (void)onRefresh {
    [[TwitterClient sharedClientInstance] tweetsWithCompletion:^(NSArray *tweets, NSError *error) {
        
        NSLog(@"onRefresh TWEETS: %@", tweets);
        if (error == nil) {
            [self.tweetTableView reloadData];
            [self.refreshControl endRefreshing];
        }
        else {
            NSLog(@"Error getting tweets");
        }
    }];
}

- (IBAction) signOutBtnPressed {
    [[TwitterClient sharedClientInstance] logoutCurrentUser];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction) newBtnPressed {
    NewTweetViewController *newTweetViewContoller = [[NewTweetViewController alloc] initWithNibName:@"NewTweetViewController" bundle:nil];
    
    newTweetViewContoller.currentUser = self.currentUser;
    
    [self.navigationController pushViewController:newTweetViewContoller animated:YES];
}

- (IBAction) homeBtnPressed {
    NSLog(@"HOME BUTTON PRESSED");
}

- (IBAction)profileBtnPressed {
    UserProfileViewController *userProfileViewController = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
    
    userProfileViewController.currentUser = self.currentUser;
    
    [self.navigationController pushViewController:userProfileViewController animated:YES];
}

- (IBAction) profileImagePressed:(UITapGestureRecognizer *) sender {
    Tweet *tweet = [self.tweets objectAtIndex: sender.view.tag];
    NSLog(@"profileImagePressed -- %@", tweet);
    
    UserProfileViewController *userProfileViewController = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
    
    userProfileViewController.currentUser = tweet.author;
    
    [self.navigationController pushViewController:userProfileViewController animated:YES];
}

- (void) setTimelineTweets: (NSArray *) tweets {
    self.tweets = tweets;
}

@end
