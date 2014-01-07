//
//  friendsList.h
//  Project
//
//  Created by Admin on 1/4/14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "ProfileView.h"
@interface friendsList : UIViewController
{
    
    BOOL flag;
    //0 - Core Data Space;
    //1 Core Data not Space;
    BOOL netConnect;
    
}

@property (weak, nonatomic) IBOutlet UITableView *followerTable;
@property   (strong,nonatomic) NSMutableDictionary *tweetDict;
@property (strong,nonatomic) NSArray *users;

@end
