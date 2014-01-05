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
@interface LentaView : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tweetTable;
@property (strong,nonatomic) NSMutableArray *tweetDict;
@end
