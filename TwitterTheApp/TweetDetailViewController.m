//
//  TweetDetailViewController.m
//  TwitterTheApp
//
//  Created by  Imtiyaz Jariwala on 2/1/17.
//  Copyright © 2017 yahoo. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "Tweet.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface TweetDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *retweetImage;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetContainerHeightContraint;
@property (weak, nonatomic) IBOutlet UIView *countView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;

@end

@implementation TweetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, 0, CGRectGetWidth(self.countView.frame), 1);
    border.frame = CGRectMake(0, CGRectGetHeight(self.countView.frame) - 1, CGRectGetWidth(self.countView.frame), 1);
    border.backgroundColor = (__bridge CGColorRef _Nullable)([UIColor grayColor]);
    [self.countView.layer addSublayer:border];
    
    [self.profileImage setImageWithURL: [NSURL URLWithString:self.tweet.author.profileImageUrl]];
    [self.nameLabel setText: self.tweet.author.name];
    [self.handleLabel setText: [NSString stringWithFormat:@"@%@", self.tweet.author.screenName]];
    [self.textLabel setText:self.tweet.text];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString *dateTime = [formatter stringFromDate: self.tweet.createdAt];
    [self.timestampLabel setText: dateTime];
    
    if (self.tweet.retweetedBy != nil) {
        self.retweetContainerHeightContraint.constant = 25;
        //self.
        [self.retweetLabel setHidden:NO];
        [self.retweetImage setHidden:NO];
        [self.retweetLabel setText:[NSString stringWithFormat:@"%@ Retweeted", self.tweet.retweetedBy.name]];
    }
    else {
        self.retweetContainerHeightContraint.constant = 0;
        [self.retweetLabel setHidden:YES];
        [self.retweetImage setHidden:YES];
    }
    
    [self.retweetCount setText:[NSString stringWithFormat:@"%d", self.tweet.retweetCount]];
    [self.favoriteCount setText:[NSString stringWithFormat:@"%d", self.tweet.favoriteCount]];
    
    [self.view setNeedsUpdateConstraints];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)replyBtn:(id)sender {
}

- (IBAction)retweetBtn:(id)sender {
}

- (IBAction)favoriteBtn:(id)sender {
}

@end
