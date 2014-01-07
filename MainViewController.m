//
//  MainViewController.m
//  Project
//
//  Created by Admin on 12/16/13.
//  Copyright (c) 2013 MSU. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"

@interface MainViewController ()

{
   }
@end

@implementation MainViewController

@synthesize array,tableView,connection,webData,array2,connectButton,mainDict,username;
@synthesize tweetCount,friendCount,followerCount,avatar,screenName,MainName;
@synthesize lbfol,lbfr,lbtweet;
@synthesize btnAbout,btnListFollower,btnListFriend,btnListTweet,btnTweet;
@synthesize btnLenta;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [self testNet];
    
    
    avatar.layer.cornerRadius =40;
    avatar.clipsToBounds  = YES;
    self.title  = @"";
  
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"MAIN.jpg"]drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    lbtweet.hidden =  YES;
    lbfr.hidden =  YES;
    lbfol.hidden =  YES;
    btnTweet.hidden=YES;
    btnListTweet.hidden=YES;
    btnListFriend.hidden=YES;
    btnListFollower.hidden = YES;
    btnAbout.hidden = YES;
    btnLenta.hidden = YES;
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([[userDefaults objectForKey:@"MainName"] length]==0) {
        NSLog(@"Space");
    }
    else
    {
        lbtweet.hidden =  NO;
        lbfr.hidden =  NO;
        lbfol.hidden =  NO;
        MainName.text = [userDefaults objectForKey:@"MainName"];
        screenName.text = [userDefaults objectForKey:@"screenName"];
        followerCount.text= [NSString stringWithFormat:@"%@", [userDefaults objectForKey:@"followerCount"]];
        friendCount.text= [NSString stringWithFormat:@"%@", [userDefaults objectForKey:@"friendsCount"]];
        tweetCount.text = [NSString stringWithFormat:@"%@", [userDefaults objectForKey:@"tweetCount"]];
        NSData *imagedata = [userDefaults objectForKey:@"image"];
        avatar.image = [UIImage imageWithData:imagedata];
        btnTweet.hidden=NO;
        btnListTweet.hidden=NO;
        btnListFriend.hidden=NO;
        btnListFollower.hidden = NO;
        btnAbout.hidden = NO;
        btnLenta.hidden = NO;

   }
    
    array2 = [[NSMutableArray alloc]init];
    //[self.navigationController setNavigationBarHidden:YES];
   //UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
   // [indicator startAnimating];
    //[self LoadMainView];
}
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"MAINVIEW");
    self.title  = @"Мой профиль";
 //   [self testNet];
    [self.navigationController setNavigationBarHidden:YES];
    [self LoadMainView];
}
-(void)testNet
{
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *result ;
    
    dispatch_async(dispatch_get_main_queue(), ^{
    if (appdelegate.netStatus == NotReachable)
    {
        NSLog(@"Not connection");
//        UIAlertView *nonConnection = [[UIAlertView alloc]initWithTitle:@"Нет интернета" message:@"Включите 3G или Wi-Fi" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [nonConnection show];
    }
    else if (appdelegate.netStatus ==ReachableViaWiFi)
    {
        NSLog(@"Wifi");
    }
 
    });
}
- (IBAction)aboutProgram:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"О программе"
                                            message:@"Реализованно:\n1.Просмотр твитов\n2.Отправка твитов\n3.Отправка твитов с фото\n4.Удаление твитов\n5.Просмотр списка друзей\n6.Просмотр списка фолловеров\n7.Отправка личных сообщений\n8.Просмотр ленты\n9.Просмотр профиля\n10.CoreData(Лента,друзья,фолловеры),NSUserDefaults\nВерсия 1.2.1\nCopyLeft ↄ2014 Batuev Anton"
                                            delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [alert show];
}

-(void)LoadMainView
{
    NSLog(@"START");
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    accountStore = [[ACAccountStore alloc] init];
    accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            NSLog(@"COUNT accounts  = %d",accounts.count);
            if (accounts.count > 0)
            {
                ACAccount *twitterAccount = [accounts objectAtIndex:0];
                NSString *str = twitterAccount.username;
                NSLog(@"USERNAME = %@",str);
                NSDictionary *param =[NSDictionary dictionaryWithObject:str forKey:@"screen_name"];
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
                            mainDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                            
                            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                            
                            MainName.text = mainDict[@"name"];
                            screenName.text = [NSString stringWithFormat:@"@%@", mainDict[@"screen_name"]];
                            followerCount.text=[NSString stringWithFormat:@"%d", [[mainDict objectForKey:@"followers_count"]integerValue]];
                            friendCount.text=[NSString stringWithFormat:@"%d", [[mainDict objectForKey:@"friends_count"]integerValue]];
                            tweetCount.text = [NSString stringWithFormat:@"%d", [[mainDict objectForKey:@"statuses_count"]integerValue]];
                            btnTweet.hidden=NO;
                            btnListTweet.hidden=NO;
                            btnListFriend.hidden=NO;
                            btnListFollower.hidden = NO;
                            btnAbout.hidden = NO;
                            btnLenta.hidden = NO;
                            lbtweet.hidden =  NO;
                            lbfr.hidden =  NO;
                            lbfol.hidden =  NO;

                            [userDefaults setObject:MainName.text forKey:@"MainName"];
                            [userDefaults setObject:screenName.text forKey:@"screenName"];
                            [userDefaults setInteger:[[mainDict objectForKey:@"followers_count"]integerValue] forKey:@"followerCount"];
                            [userDefaults setInteger:[[mainDict objectForKey:@"friends_count"]integerValue] forKey:@"friendsCount"];
                            [userDefaults setInteger:[[mainDict objectForKey:@"statuses_count"]integerValue] forKey:@"tweetCount"];
                            [userDefaults synchronize];
                            NSLog(@"FINISH");
                            NSURL *imageurl = [NSURL URLWithString:mainDict[@"profile_image_url_https"]];
                            avatar.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageurl]];
                            [userDefaults setObject:UIImagePNGRepresentation(avatar.image) forKey:@"image"];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
     NSLog(@"didReceiveResponse");
    [webData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData");
    [webData appendData:data];
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"fail with Error");
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
        NSDictionary *allDataDictionary = [NSJSONSerialization JSONObjectWithData:webData options:0 error:nil];
        NSDictionary *first = [allDataDictionary objectForKey:@"0"];
        NSDictionary * entities = [first objectForKey:@"entities"];
        NSDictionary * user = [first objectForKey:@"user"];
        NSString *str = [user objectForKey:@"name"];
        NSLog(@"str = @",str);
    

//     NSLog(@"DidFinishLoading");
//    NSDictionary *allDataDictionary = [NSJSONSerialization JSONObjectWithData:webData options:0 error:nil];
//    NSDictionary *feed = [allDataDictionary objectForKey:@"feed"];
//    NSArray *arrayOfEntry = [feed objectForKey:@"entry"];
//    NSLog(@"entry = ",[[feed objectForKey:@"entry"]objectAtIndex:0]);
//   
//    for (NSDictionary *diction in arrayOfEntry) {
//        NSDictionary *title  = [diction objectForKey:@"title"];
//        NSString *label  = [title objectForKey:@"label"];
//        [array2 addObject:label];
//    }
    
    [tableView reloadData];
}
- (IBAction)AuthPush:(id)sender {

    [self LoadMainView];
}


- (IBAction)postPush:(id)sender {
    
   accountStore= [[ACAccountStore alloc]init];
    NSString *status = @"from my application11";

    UIImage *image = [UIImage imageNamed:@"wallpaper.jpg"];
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
            NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"];
            NSDictionary *params = @ {@"status" : status};
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                    requestMethod:SLRequestMethodPOST
                                                              URL:url
                                                       parameters:params];
           // NSData *imageData = UIImageJPEGRepresentation(image, 1.f);
            //[request addMultipartData:imageData
                   //          withName:@"media[]"
                     //            type:@"image/jpeg"
                       //      filename:@"image.jpg"];
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

- (IBAction)tweetPost:(id)sender {

    TweetPost *tweetView = [[TweetPost alloc]initWithNibName:@"TweetPost" bundle:nil];
    [self.navigationController pushViewController:tweetView animated:YES];

}
- (IBAction)tweetList:(id)sender
{
    tweetLists *tweetListView = [[tweetLists alloc]initWithNibName:@"tweetLists" bundle:nil];
    tweetListView.name = MainName.text;
    tweetListView.screenname = [NSString stringWithFormat:@"%@", screenName.text];
    tweetListView.mainImage = avatar.image;
    [self.navigationController pushViewController:tweetListView animated:YES];
}


- (IBAction)messageSent:(id)sender {
    
    
    accountStore= [[ACAccountStore alloc]init];
    ACAccountType *twitterType =[accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSString *text  = @"from my application";
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
                NSDictionary *params = @ {@"screen_name":@"monster3991",@"text" : text};
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


-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSLog(@"count = %d",[array count  ]);
    return [array count];
}


-(UITableViewCell*)tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
 
    
    NSLog(@"COUNT = %d",mainDict.count);
   // NSDictionary *dict  = [mainDict objectForKey:@"0"];
    NSString *str = [mainDict objectForKey:@"name"];
    NSLog(@"str = %@",str);
    
    return cell;
}

-(void)tableView:(UITableView*)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    
}
- (IBAction)PushConnect:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (appDelegate.netStatus ==NotReachable) {
        NSLog(@"Not Connection");
        
    }else if (appDelegate.netStatus == ReachableViaWiFi) {NSLog(@"Connection ReachableViaWiFi");}
    else if (appDelegate.netStatus ==ReachableViaWWAN) {NSLog(@"Connection RechableViaWWAN");}
}


- (IBAction)FollowerButton:(id)sender {
    followerList *followerView = [[followerList alloc]initWithNibName:@"followerList" bundle:nil];
    [self.navigationController pushViewController:followerView animated:YES];

}

- (IBAction)FriendsButton:(id)sender {
    friendsList *friendsView = [[friendsList alloc]initWithNibName:@"friendsList" bundle:nil];
    [self.navigationController pushViewController:friendsView animated:YES];

}
- (IBAction)lentaButton:(id)sender {
 
    LentaView *lentaView = [[LentaView alloc]initWithNibName:@"LentaView" bundle:nil];
    [self.navigationController pushViewController:lentaView animated:YES];
}

@end
