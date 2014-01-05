//
//  TweetPost.h
//  Project
//
//  Created by Admin on 1/2/14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface TweetPost : UIViewController <UITextViewDelegate,UIImagePickerControllerDelegate>

{
    BOOL fotoFlag;
    
}
@property (weak, nonatomic) IBOutlet UITextView *TextView;
@property (weak, nonatomic) IBOutlet UILabel *LabelCountSymbol;
@property (strong,nonatomic) UIImagePickerController * imagePicker;
@property (strong,nonatomic) UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIButton *sendTweet;
@property (strong,nonatomic) IBOutlet UIBarButtonItem *sendButton;
@end
