//
//  tweetLists.h
//  Project
//
//  Created by Admin on 1/3/14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface tweetLists : UIViewController

{
    NSString *name;
    NSString *screenName;
}
@property (weak, nonatomic) IBOutlet UITableView *tweetTable;
@property (strong,nonatomic,readwrite) NSMutableArray* tweetDict;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *screenname;
@property (strong,nonatomic) UIImage *mainImage;
@property (strong,nonatomic) NSString* idTweet;
@property (strong,nonatomic) NSMutableArray* arrayTweet;

@end
