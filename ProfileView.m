//
//  ProfileView.m
//  Project
//
//  Created by Admin on 1/6/14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import "ProfileView.h"

@interface ProfileView ()

@end

@implementation ProfileView
@synthesize name,screenName,countFollower,countFriend,countTweet,image,SCREEN_NAME,profileShow;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"SCREEN NAME = %@",SCREEN_NAME);
    self.title  = @"Профиль";
    [self LoadMainView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)LoadMainView
{
    NSLog(@"START");
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    ACAccountStore* accountStore = [[ACAccountStore alloc] init];
   ACAccountType* accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            NSLog(@"COUNT accounts  = %d",accounts.count);
            if (accounts.count > 0)
            {
                ACAccount *twitterAccount = [accounts objectAtIndex:0];
                NSString *str = twitterAccount.username;
                NSLog(@"USERNAME = %@",str);
                NSDictionary *param =[NSDictionary dictionaryWithObject:SCREEN_NAME forKey:@"screen_name"];
                NSURL *requestAPI = [NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"];
                SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestAPI parameters:param];
                [twitterInfoRequest setAccount:twitterAccount];
                [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([urlResponse statusCode] == 429)
                        {
                            NSLog(@"Rate limit reached");
                            return;
                        }
                        if (error)
                        {
                            NSLog(@"Error: %@", error.localizedDescription);
                            return;
                        }
                        if (responseData)
                        {
                            NSError *error = nil;
                            profileShow = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                            
                            name.text = profileShow[@"name"];
                            screenName.text = [NSString stringWithFormat:@"@%@",profileShow[@"screen_name"]];
                            countFollower.text=[NSString stringWithFormat:@"%d", [[profileShow objectForKey:@"followers_count"]integerValue]];
                            countFriend.text=[NSString stringWithFormat:@"%d", [[profileShow objectForKey:@"friends_count"]integerValue]];
                            countTweet.text = [NSString stringWithFormat:@"%d", [[profileShow objectForKey:@"statuses_count"]integerValue]];
                            NSURL *imageurl = [NSURL URLWithString:profileShow                                           [@"profile_image_url_https"]];
                            image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageurl]];
                            
                           }
                    });
                }];
            } else {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Нет доступа"
                                                               message:@"Подключите аккаунт Твиттера настройках"
                                                              delegate:self
                                                     cancelButtonTitle:@"OK,пойду подключать"
                                                     otherButtonTitles:nil];
                [alert show];
            }
        } else
        {
            NSLog(@"alert");
        }
    }];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
}


@end
