//
//  TwitterClient.h
//  TwitterTheApp
//
//  Created by  Imtiyaz Jariwala on 1/30/17.
//  Copyright © 2017 yahoo. All rights reserved.
//

#import <BDBOAuth1Manager/BDBOAuth1SessionManager.h>
#import "User.h"

@interface TwitterClient : BDBOAuth1SessionManager

+ (TwitterClient *) sharedClientInstance;

- (void) loginWithCompletion: (void (^)(User *user, NSError *error)) completion;
- (void) tweetsWithCompletion: (void (^)(NSArray *tweets, NSError *error)) completion;
- (void) postTweet: (void (^)(NSObject *result, NSError *error)) completion;
- (void) replyTweet: (void (^)(NSObject *result, NSError *error)) completion;
- (void) retweetTweet: (void (^)(NSObject *result, NSError *error)) completion;
- (void) favoriteTweet: (void (^)(NSObject *result, NSError *error)) completion;
- (void) openUrl:(NSURL *)url operation:(NSString *) operation parameters: (NSArray *) params;
- (void) logoutCurrentUser;

@end
