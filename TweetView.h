//
//  TweetView.h
//  Project
//
//  Created by Admin on 1/5/14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "ProfileView.h"
@interface TweetView : UIViewController


@property (strong,nonatomic) NSDictionary *tweet;

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblScreenName;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextView *Text;
@property (nonatomic) BOOL lentaORtweet;
//0 - tweet
//1 - lenta

@end
