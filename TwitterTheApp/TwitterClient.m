//
//  TwitterClient.m
//  TwitterTheApp
//
//  Created by  Imtiyaz Jariwala on 1/30/17.
//  Copyright © 2017 yahoo. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString *const twitterConsumerKey = @"eohHuSVfoBOPddhhRV7Y57rA4";
NSString *const twitterConsumerSecret = @"AIosi0i3Ycoep24jpfWIehjGjRnyX4PpKv0krV3OfHGcEoF6wF";
NSString *const twitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()

@property (nonatomic, strong) void (^loginCallback) (User *user, NSError *error);
@property (nonatomic, strong) void (^tweetsCallback) (NSArray *tweets, NSError *error);
@property (nonatomic, strong) void (^postCallback) (NSObject *result, NSError *error);

@end

@implementation TwitterClient

User *user;
NSArray *tweets;
NSData *userData;
NSUserDefaults *currentUser;


+ (TwitterClient *) sharedClientInstance {
    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL: [NSURL URLWithString:twitterBaseUrl] consumerKey: twitterConsumerKey consumerSecret: twitterConsumerSecret];
        }
    });
    
    return instance;
}

- (void) loginWithCompletion: (void (^)(User *user, NSError *error)) completion {
    
    self.loginCallback = completion;
    
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"twittertheapp://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        
        NSURL *authUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        
        NSDictionary *options;
        [[UIApplication sharedApplication] openURL:authUrl options: options completionHandler:^(BOOL success) {
            NSLog(@"Logging-in");
        }];
        
    } failure:^(NSError *error) {
        self.loginCallback(nil, error);
    }];
}

- (void) tweetsWithCompletion: (void (^)(NSArray *tweets, NSError *error)) completion {
    self.tweetsCallback = completion;
    
    [[TwitterClient sharedClientInstance] openUrl: nil operation:@"home_timeline" parameters: nil];
}

- (void) postTweet: (void (^)(NSObject *result, NSError *error)) completion {
    self.postCallback = completion;
    
    [[TwitterClient sharedClientInstance] openUrl: nil operation:@"post_tweet" parameters:nil];
}

- (void) replyTweet: (void (^)(NSObject *result, NSError *error)) completion {
    self.postCallback = completion;
    
    [[TwitterClient sharedClientInstance] openUrl: nil operation:@"reply_tweet" parameters:nil];
}

- (void) retweetTweet: (void (^)(NSObject *result, NSError *error)) completion {
    self.postCallback = completion;
    
    [[TwitterClient sharedClientInstance] openUrl: nil operation:@"retweet_tweet" parameters:nil];
}

- (void) favoriteTweet: (void (^)(NSObject *result, NSError *error)) completion {
    self.postCallback = completion;
    
    [[TwitterClient sharedClientInstance] openUrl: nil operation:@"favorite_tweet" parameters:nil];
}

- (void) openUrl:(NSURL *)url operation:(NSString *) operation parameters: (NSArray *) params {
    currentUser = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"OPERATION: %@", operation);
    
    if ([operation isEqual: @"login"]) {

                //Login flow

                [[TwitterClient sharedClientInstance]
                    fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST"
                    requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query]
                    success:^(BDBOAuth1Credential *accessToken) {
             
                        [[TwitterClient sharedClientInstance].requestSerializer saveAccessToken:accessToken];
             
                        [[TwitterClient sharedClientInstance] GET:@"1.1/account/verify_credentials.json"
                                                       parameters:nil
                                                         progress:nil
                                                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                              user = [[User alloc] initWithDictionary:responseObject];
                                                              self.loginCallback(user, nil);
                                                              
                                                              NSLog(@"USER PROFILE: %@", responseObject);
                                              
                                                              ///userData = [NSKeyedArchiver archivedDataWithRootObject: user];
                                                              ///[currentUser setObject:userData forKey:@"logged_in_user"];
                                                              ///[currentUser synchronize];
                                                          }
                                                          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                              NSLog(@"Error in verifying credentials");
                                                              self.loginCallback(nil, error);
                                                          }];
                        
                        
                        
                    }
                    failure:^(NSError *error) {
                        NSLog(@"LOGIN ERROR: %@", error);
                    }];
    }
    else if ([operation isEqual: @"home_timeline"]) {
                //Get timeline tweets

                [[TwitterClient sharedClientInstance] GET:@"1.1/statuses/home_timeline.json"
                                               parameters:nil
                                                 progress:nil
                                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                      tweets = [Tweet tweetsWithArray:responseObject];
                                                      NSLog(@"TMP tweets: %@", responseObject);
                                                      self.tweetsCallback(tweets, nil);
                                                  }
                                                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                      NSLog(@"Error in getting tweets");
                                                      self.tweetsCallback(nil, error);
                                                  }];
    }
    else if ([operation isEqual: @"post_tweet"]) {
        
        [[TwitterClient sharedClientInstance] POST:@"1.1/statuses/update.json?status=Posting"
                                        parameters:@{@"status": @"Posting"}
                                          progress:nil
                                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                                               NSLog(@"POSTED tweets: %@", responseObject);
                                               self.postCallback(responseObject, nil);
                                           }
                                           failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                               NSLog(@"Error in posting tweet: %@", error);
                                               self.postCallback(nil, error);
                                           }];
             
    }
    else if ([operation isEqual: @"reply"]) {
        
        [[TwitterClient sharedClientInstance] POST:@"1.1/statuses/retweet/id.json"
                                        parameters:nil
                                          progress:nil
                                           success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {

                                               NSLog(@"Replied tweet: %@", responseObject);
                                               self.postCallback(tweets, nil);
                                           }
                                           failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                               NSLog(@"Error in replying tweet: %@", error);
                                               self.postCallback(nil, error);
                                           }];
        
    }
    else if ([operation isEqual: @"retweet"]) {
        
        [[TwitterClient sharedClientInstance] POST:@"1.1/statuses/retweet/id.json"
                                        parameters:nil
                                          progress:nil
                                           success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                                               NSLog(@"Retweeted tweet: %@", responseObject);
                                               self.postCallback(responseObject, nil);
                                           }
                                           failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                               NSLog(@"Error in posting tweet: %@", error);
                                               self.postCallback(nil, error);
                                           }];
        
    }
    else if ([operation isEqual: @"favorite"]) {
        
        [[TwitterClient sharedClientInstance] POST:@"1.1/favorites/create.json"
                                        parameters:@{@"id": @"id"}
                                          progress:nil
                                           success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {

                                               NSLog(@"Favorited tweet: %@", responseObject);
                                               self.postCallback(tweets, nil);
                                           }
                                           failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                               NSLog(@"Error in posting tweet: %@", error);
                                               self.postCallback(nil, error);
                                           }];
        
    }
    
}

- (void) logoutCurrentUser {
    [self.requestSerializer removeAccessToken];
}

@end
