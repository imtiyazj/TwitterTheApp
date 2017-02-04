//
//  User.h
//  TwitterTheApp
//
//  Created by  Imtiyaz Jariwala on 1/30/17.
//  Copyright © 2017 yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *profileBannerImage;
@property (nonatomic, strong) NSString *profileBackgroundImage;
@property (nonatomic, strong) NSString *location;

@property (nonatomic) int tweetsCount;
@property (nonatomic) int followingCount;
@property (nonatomic) int followersCount;

@property (nonatomic, strong) User *currentUser;

- (id) initWithDictionary:(NSDictionary *) dictionary;

@end
