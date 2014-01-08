//
//  TweetView.m
//  Project
//
//  Created by Admin on 1/5/14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import "TweetView.h"

@interface TweetView ()

@end

@implementation TweetView
@synthesize tweet,lblDate,lblName,lblScreenName,image,Text,lentaORtweet;
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
    lblDate.hidden = YES;
    lblName.hidden = YES;
    lblScreenName.hidden = YES;
    [super viewDidLoad];
    self.title  = @"Твит";
       if (lentaORtweet == NO) {
           UIBarButtonItem  *deleteButton= [[UIBarButtonItem alloc]initWithTitle:@"Удалить"  style:UIBarButtonItemStyleBordered target:self action:@selector(delete)];
           self.navigationItem.rightBarButtonItem = deleteButton;
 }
    Text.text = tweet[@"text"];
    if ([tweet[@"text"]length]!=0) {
        
        lblDate.hidden = NO;
        lblName.hidden = NO;
        lblScreenName.hidden = NO;
    NSDictionary *user = tweet[@"user"];
    lblName.text = user[@"name"];
    lblScreenName.text =[NSString stringWithFormat:@"@%@", user[@"screen_name"]];
    NSMutableString *datestr  = [NSMutableString stringWithCapacity:40];
    [datestr appendString:tweet[@"created_at"]];
    NSLog(@"DATASTR = %@",datestr);
   [datestr deleteCharactersInRange:NSMakeRange(17, 11)];
    lblDate.text = datestr;
    NSURL *imageurl = [NSURL URLWithString:user[@"profile_image_url"]];
    image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageurl]];
    
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)imageButton:(id)sender {
    
    ProfileView *profileView = [[ProfileView alloc]initWithNibName:@"ProfileView" bundle:nil];
    NSDictionary *scr = tweet[@"user"];
    profileView.SCREEN_NAME =scr[@"screen_name"];
    [self.navigationController  pushViewController:profileView animated:YES];
   }

-(void)delete
{
    NSString *idstr = tweet[@"id"];
    NSLog(@"ID TWEET = %@",idstr);
    [self deleteTweet:idstr];
    [self.navigationController popViewControllerAnimated:YES];

    
}
-(void) deleteTweet:(NSString *)id
{
    ACAccountStore* accountStore= [[ACAccountStore alloc]init];
    ACAccountType *twitterType =
    [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    SLRequestHandler requestHandler =
    ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (responseData) {
            NSInteger statusCode = urlResponse.statusCode;
            if (statusCode >= 200 && statusCode < 300) {
                NSDictionary *postResponseData =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers
                                                  error:NULL];
                NSLog(@"[SUCCESS!] Created Tweet with ID: %@", postResponseData[@"id_str"]);
                //[self.navigationController popViewControllerAnimated:YES];

                
            }
            else {
                NSLog(@"[ERROR] Server responded: status code %d %@", statusCode,
                      [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
                
            }
        }
        else {
            NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
        }
    };
    
    ACAccountStoreRequestAccessCompletionHandler accountStoreHandler =
    ^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:twitterType];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/destroy/%@.json",id]];
            NSDictionary *params= @ {@"id_str" : id};
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                    requestMethod:SLRequestMethodPOST
                                                              URL:url
                                                       parameters:params];
            [request setAccount:[accounts lastObject]];
            [request setAccessibilityValue:@"1"];
            [request performRequestWithHandler:requestHandler];
        }
        else {
            NSLog(@"[ERROR] An error occurred while asking for user authorization: %@",
                  [error localizedDescription]);
        }
    };
    
    [accountStore requestAccessToAccountsWithType:twitterType
                                          options:NULL
                                       completion:accountStoreHandler];
    
}


@end
