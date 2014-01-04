//
//  SendPrivateView.h
//  Project
//
//  Created by Admin on 1/4/14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
@interface SendPrivateView : UIViewController


@property (strong,nonatomic) NSString *screen_name;
@property (weak, nonatomic) IBOutlet UITextView *TextView;
@property (weak, nonatomic) IBOutlet UILabel *LabelCountSymbol;
@property (strong,nonatomic) IBOutlet UIBarButtonItem *sendButton;
@end
