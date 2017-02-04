//
//  User.m
//  TwitterTheApp
//
//  Created by  Imtiyaz Jariwala on 1/30/17.
//  Copyright © 2017 yahoo. All rights reserved.
//

#import "User.h"

@implementation User


- (id) initWithDictionary:(NSDictionary *) dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profileImageUrl = dictionary[@"profile_image_url_https"];
        
        NSLog(@"BANNER -- %@", dictionary[@"profile_banner_url"]);
        NSLog(@"PRO BG -- %@", dictionary[@"profile_background_image_url_https"]);
        
        //self.profileBackgroundImage = (dictionary[@"profile_banner_url"] != nil) ? dictionary[@"profile_banner_url"] : dictionary[@"profile_background_image_url_https"];
        
        self.profileBannerImage = dictionary[@"profile_banner_url"];
        self.profileBackgroundImage = dictionary[@"profile_background_image_url_https"];
        
        self.location = dictionary[@"location"];
        self.tweetsCount = [dictionary[@"statuses_count"] intValue];
        self.followersCount = [dictionary[@"followers_count"] intValue];
        self.followingCount = [dictionary[@"friends_count"] intValue];
    }
    
    return self;
}


@end
