//
//  followerList.h
//  Project
//
//  Created by Admin on 1/4/14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "SendPrivateView.h"
@interface followerList : UIViewController<UIActionSheetDelegate>

{
    int numberRow;
}

@property (weak, nonatomic) IBOutlet UITableView *followerTable;
@property (strong,nonatomic) NSMutableDictionary *tweetDict;
@property (strong,nonatomic) NSArray *users;
@end
