//
//  TweetList.h
//  Project
//
//  Created by Admin on 1/3/14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface TweetList : UITableViewController
{
    
}
@property (strong,nonatomic) UIImage *image;
@property (strong,nonatomic) NSArray *tweetDict;

-(void)downloadTweet;
@end
