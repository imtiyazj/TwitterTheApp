//
//  TweetListViewController.h
//  TwitterTheApp
//
//  Created by  Imtiyaz Jariwala on 1/30/17.
//  Copyright © 2017 yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface TweetListViewController : UIViewController

- (void) setTimelineTweets: (NSArray *) tweets;

@property (nonatomic, strong) User *currentUser;

@end
