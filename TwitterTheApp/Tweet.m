//
//  Tweet.m
//  TwitterTheApp
//
//  Created by  Imtiyaz Jariwala on 1/30/17.
//  Copyright © 2017 yahoo. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet


- (id) initWithDictionary:(NSDictionary *) dictionary {
    self = [super init];
    if (self) {
        self.tweetId = dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        
        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [dateFormatter dateFromString:createdAtString];
        
        if (dictionary[@"retweeted_status"] != nil) {
            self.author = [[User alloc] initWithDictionary: dictionary[@"retweeted_status"][@"user"]];
            self.retweetedBy = [[User alloc] initWithDictionary: dictionary[@"user"]];
        }
        else {
            self.author = [[User alloc] initWithDictionary: dictionary[@"user"]];
            self.retweetedBy = nil;
        }
        
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
    }
    
    return self;
}

+ (NSArray *) tweetsWithArray: (NSArray *) array {
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary: dictionary]];
    }
    
    return tweets;
}

@end
