//
//  NewTweetViewController.m
//  TwitterTheApp
//
//  Created by  Imtiyaz Jariwala on 2/2/17.
//  Copyright © 2017 yahoo. All rights reserved.
//

#import "NewTweetViewController.h"
#import "TweetListViewController.h"
#import "TwitterClient.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface NewTweetViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;

@property (weak, nonatomic) IBOutlet UILabel *textCount;

@property (weak, nonatomic) IBOutlet UITextView *tweetText;

@end

@implementation NewTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tweetText.delegate = self;
    
    [self configureNavigationBar];
    
    [self.profileImage setImageWithURL: [NSURL URLWithString:self.currentUser.profileImageUrl]];
    [self.nameLabel setText:self.currentUser.name];
    [self.handleLabel setText:self.currentUser.screenName];
    
    //[self.tweetText setContentOffset: CGPointMake(0, 0) animated:YES];
    //self.tweetText.scrollEnabled = NO;
        [self.tweetText setContentOffset: CGPointMake(0,100) animated:NO];
    [self.tweetText becomeFirstResponder];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    [self.textCount setText: @(140 - [[textView text] length] - 1).stringValue];
    
    //Set 140 character limit
    if([[textView text] length] - range.length + text.length > 140){
        return NO;
    }
    
    return YES;
}

- (void) configureNavigationBar {
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = YES;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:45.0/255.0 green:160.0/255.0 blue:242.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(cancelBtnPressed)];
    self.navigationItem.leftBarButtonItem = cancelBtn;
    
    UIBarButtonItem *tweetBtn = [[UIBarButtonItem alloc] initWithTitle:@"Tweet"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(tweetBtnPressed)];
    self.navigationItem.rightBarButtonItem = tweetBtn;
}

- (void) cancelBtnPressed {
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

- (void) tweetBtnPressed {
    [[TwitterClient sharedClientInstance] postTweet:^(NSObject *result, NSError *error) {
        if (error == nil) {
            NSLog(@"Tweet posted");
        }
        
        [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }];
}

@end
