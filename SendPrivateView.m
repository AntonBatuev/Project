//
//  SendPrivateView.m
//  Project
//
//  Created by Admin on 1/4/14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import "SendPrivateView.h"

@interface SendPrivateView ()

@end

@implementation SendPrivateView

@synthesize LabelCountSymbol,TextView,screen_name,sendButton;

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
    [self.navigationController setNavigationBarHidden:NO];

   // sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Отправить" style: target:self action:@selector(sendMessage)];
    sendButton= [[UIBarButtonItem alloc]initWithTitle:@"Отправить" style:UIBarButtonItemStyleDone target:self action:@selector(sendMessage)];
    self.navigationItem.rightBarButtonItem = sendButton;
    sendButton.enabled = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textViewDidChange:(UITextView *) textView
{
    int len = textView.text.length;
    if (len == 0) sendButton.enabled = NO;
    else sendButton.enabled = YES;
    
    LabelCountSymbol.text = [NSString stringWithFormat:@"%i",140-len];
    
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    [textView resignFirstResponder];
    return YES;
}

-(BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        
    }
    if ([textView.text length]>139) {
        return NO;
    } else return YES;
}


-(void)sendMessage
{
    NSLog(@"screen Name = %@",screen_name);
    [self messageSent:screen_name];
}
- (void)messageSent:(NSString*)screenName{
    
    
       ACAccountStore* accountStore= [[ACAccountStore alloc]init];
    ACAccountType *twitterType =[accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSString *text = [NSString stringWithFormat:@"%@ #fromMyApp" ,TextView.text ];
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
                //UIAlertView *simpleAlert = [[UIAlertView alloc]initWithTitle:@"Твит отправлен" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                //[simpleAlert show];
                
            }
            else {
                NSLog(@"[ERROR] Server responded: status code %d %@", statusCode,
                      [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
                //  UIAlertView *simpleAlert1 = [[UIAlertView alloc]initWithTitle:@"Твит не отправлен" message:@"Напишите что-нибудь другое" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                // [simpleAlert1 show];
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
            NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/direct_messages/new.json"];
            NSDictionary *params = @ {@"screen_name":screenName,@"text" : text};
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
    LabelCountSymbol.text = @"140";
    TextView.text = @"";
    
}

@end
