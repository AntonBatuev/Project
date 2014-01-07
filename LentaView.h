//
//  LentaView.h
//  Project
//
//  Created by Admin on 1/5/14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "TweetView.h"
#import "AppDelegate.h"
@interface LentaView : UIViewController

{
    UILabel *tweetLabel;
    UILabel *nameLabel;
    UIImageView *imageCell;
    UILabel *screenNameLabel;
    NSMutableArray *arrayText;
   
    BOOL flag;
    //0 - Core Data Space;
    //1 Core Data not Space;
    BOOL netConnect;
}
@property (weak, nonatomic) IBOutlet UITableView *tweetTable;
@property (strong,nonatomic) NSMutableArray *tweetDict;
@property (strong,nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@end
