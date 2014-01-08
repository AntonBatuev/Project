//
//  ProfileView.h
//  Project
//
//  Created by Admin on 1/6/14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface ProfileView : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *countTweet;
@property (weak, nonatomic) IBOutlet UILabel *countFriend;
@property (weak, nonatomic) IBOutlet UILabel *countFollower;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (strong,nonatomic) NSString *SCREEN_NAME;
@property (strong,nonatomic)NSDictionary *profileShow;
@property (weak, nonatomic) IBOutlet UILabel *tweet;
@property (weak, nonatomic) IBOutlet UILabel *foll;
@property (weak, nonatomic) IBOutlet UILabel *fr;


@end
