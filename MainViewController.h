//
//  MainViewController.h
//  Project
//
//  Created by Admin on 12/16/13.
//  Copyright (c) 2013 MSU. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "TweetPost.h"
//#import "TweetList.h"
#import "tweetLists.h"
#import "followerList.h"
#import "friendsList.h"
#import "LentaView.h"
#import "LentaList.h"
@interface MainViewController : UIViewController<NSURLConnectionDataDelegate>

{
    NSString *ScreenName;
    ACAccountStore *accountStore;
    ACAccountType *accountType;
    //UIActivityIndicatorView *indicator;
    
}

//@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *MainName;

@property (strong,nonatomic) NSArray *array;

@property (strong,nonatomic) NSDictionary *mainDict;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSMutableData *webData;

@property (strong,nonatomic) NSURLConnection *connection;

@property (strong,nonatomic) NSMutableArray *array2;

@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (strong,nonatomic) NSString *username;

@property (weak, nonatomic) IBOutlet UILabel *tweetCount;
@property (weak, nonatomic) IBOutlet UILabel *friendCount;
@property (weak, nonatomic) IBOutlet UILabel *followerCount;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *lbtweet;
@property (weak, nonatomic) IBOutlet UILabel *lbfr;
@property (weak, nonatomic) IBOutlet UILabel *lbfol;
@property (weak, nonatomic) IBOutlet UIButton *btnTweet;
@property (weak, nonatomic) IBOutlet UIButton *btnListTweet;
@property (weak, nonatomic) IBOutlet UIButton *btnListFollower;
@property (weak, nonatomic) IBOutlet UIButton *btnListFriend;
@property (weak, nonatomic) IBOutlet UIButton *btnAbout;
@property (weak, nonatomic) IBOutlet UIButton *btnLenta;


-(void) LoadMainView;

@end
