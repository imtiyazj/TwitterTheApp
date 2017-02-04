//
//  Tweet.h
//  TwitterTheApp
//
//  Created by  Imtiyaz Jariwala on 1/30/17.
//  Copyright © 2017 yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *tweetId;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *author;
@property (nonatomic, strong) User *retweetedBy;
@property (nonatomic) int retweetCount;
@property (nonatomic) int favoriteCount;

- (id) initWithDictionary:(NSDictionary *) dictionary;
+ (NSArray *) tweetsWithArray: (NSArray *) array;

@end
