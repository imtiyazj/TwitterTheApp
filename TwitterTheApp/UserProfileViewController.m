//
//  UserProfileViewController.m
//  TwitterTheApp
//
//  Created by  Imtiyaz Jariwala on 1/31/17.
//  Copyright © 2017 yahoo. All rights reserved.
//

#import "UserProfileViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface UserProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileBackgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UILabel *profileHandle;

@property (weak, nonatomic) IBOutlet UILabel *tweetsCount;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UILabel *followersCount;


@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"currentUser: %@", self.currentUser.profileBackgroundImage);
    
    [self.profileName setText: self.currentUser.name];
    [self.profileHandle setText: self.currentUser.screenName];
    
    [self.tweetsCount setText: @(self.currentUser.tweetsCount).stringValue];
    [self.followingCount setText: @(self.currentUser.followingCount).stringValue];
    [self.followersCount setText: @(self.currentUser.followersCount).stringValue];

    [self.profileImage setImageWithURL: [NSURL URLWithString:self.currentUser.profileImageUrl]];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.currentUser.profileBannerImage]];
    [self.profileBackgroundImage setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        if (response != nil) {
            self.profileBackgroundImage.alpha = 0.2;
            self.profileBackgroundImage.image = image;
            [UIView animateWithDuration:0.3 animations:^{
                self.profileBackgroundImage.alpha = 1;
            }];
        }
        else {
            self.profileBackgroundImage.image = image;
        }
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        NSLog(@"Banner image couldn't be loaded");
    }];

    //Blur the banner/background image
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = self.view.frame;
    [self.profileBackgroundImage addSubview:effectView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
