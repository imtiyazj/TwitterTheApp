//
//  TweetTableViewCell.m
//  TwitterTheApp
//
//  Created by  Imtiyaz Jariwala on 1/30/17.
//  Copyright © 2017 yahoo. All rights reserved.
//

#import "TweetTableViewCell.h"
#import "TwitterClient.h"

@interface TweetTableViewCell()


@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteLabel;

@end

@implementation TweetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)onReply:(id)sender {
    NSLog(@"-- onReply1 -- %@", sender);
    NSLog(@"-- onReply2 -- %@", self.tweetId);
}

- (IBAction)onRetweet:(id)sender {
    NSLog(@"-- onRetweet1 -- %@", sender);
    NSLog(@"-- onRetweet2 -- %@", self.tweetId);
    [sender setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
}

- (IBAction)onFavorite:(id)sender {
    NSLog(@"-- onFavorite1 -- %@", sender);
    NSLog(@"-- onFavorite2 -- %@", self.tweetId);
    [sender setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
}

@end
