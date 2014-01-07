//
//  tweetLists.m
//  Project
//
//  Created by Admin on 1/3/14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import "tweetLists.h"

@interface tweetLists ()

@end

@implementation tweetLists

@synthesize tweetTable,tweetDict,name,screenname,idTweet,arrayTweet,mainImage;

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
    self.title  = @"Твиты";
    [self.navigationController setNavigationBarHidden:NO];
    
    [self downloadTweet];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self downloadTweet];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)downloadTweet
{
    
    //[tweetDict removeAllObjects];
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            if (accounts.count > 0)
            {
                NSLog(@"GOOD");
                ACAccount *twitterAccount = [accounts objectAtIndex:0];
                NSString *str = twitterAccount.username;
                NSLog(@"USERNAME = %@",str);
                NSMutableDictionary *param =[[NSMutableDictionary alloc]init];
                [param setObject:@"100" forKey:@"count"];
                [param setObject:@"1" forKey:@"include_entities"];
                NSURL *requestAPI = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"];
                SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestAPI parameters:param];
                [twitterInfoRequest setAccount:twitterAccount];
                [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                   
                    tweetDict= [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                    if(tweetDict.count!=0){
                      
                    dispatch_async(dispatch_get_main_queue(), ^{
                      
                        //[tweetTable beginUpdates];
                        arrayTweet = [NSMutableArray arrayWithCapacity:tweetDict.count];
                        NSLog(@"tweetDICT COUNT = %d",tweetDict.count);
                        
                        for (int i = 0; i<tweetDict.count; i++)
                        {
                            NSDictionary *dict = tweetDict[i];
                            [arrayTweet addObject:dict[@"text"]];
                           }
                        NSLog(@"arTWEET = %d",arrayTweet.count);

                             //[tweetTable endUpdates];
                        [tweetTable reloadData];
                        // Check if we reached the reate limit
                                            });
                       
                    }
                }];
            }
        } else
        {
            NSLog(@"No access granted");
        }
    }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
   NSLog(@"NUMBER______ARRAY TWEET = %d,ARRAY DICT  = %d",[arrayTweet count],[tweetDict count]);
  //  return [arrayTweet count];
    return [tweetDict count];
    //return 10;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *selectTweet = tweetDict[indexPath.row];
        idTweet = selectTweet[@"id_str"];
        [arrayTweet removeObjectAtIndex:indexPath.row];
       [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationTop];
        [self deleteTweet:idTweet];
        [self downloadTweet];
        NSLog(@"COUNT TWEET DICT 2 = %d COUNT ARRAY TWEET 2 = %d",[tweetDict count],[arrayTweet count]);
        [tableView reloadData];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath * )indexPath
{
 
    TweetView *tweetView = [[TweetView alloc]initWithNibName:@"TweetView" bundle:nil];
    tweetView.lentaORtweet = NO;
    NSDictionary *dict = tweetDict[indexPath.row];
    tweetView.tweet = dict;
    NSLog(@"TWEET TEXT ====  %@",dict[@"text"] );
    [self.navigationController pushViewController:tweetView animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    CGRect size = CGRectMake(40, 25, 320, 25);
    UILabel *tweetLabel = [[UILabel alloc]initWithFrame:size];
    size = CGRectMake(40, 0, 100, 20);
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:size];
    size = CGRectMake(140, 0, 240, 20);
    UILabel *screenNameLabel = [[UILabel alloc]initWithFrame:size];
    size = CGRectMake(0, 15, 35, 35);
    UIImageView *imageCell = [[UIImageView alloc]initWithFrame:size];
    imageCell.image = mainImage;
   // tweetLabel.text = @"tweetLabel";
   // nameLabel.text = @"nameLabel";
    nameLabel.font = [UIFont systemFontOfSize:12.0];
    screenNameLabel.font = [UIFont systemFontOfSize:12.0];
    screenNameLabel.text = @"ScreenLabel";
    NSDictionary *dict = tweetDict[indexPath.row];
    cell.textLabel.text = dict[@"text"];
    NSDictionary *user = dict[@"user"];
    cell.detailTextLabel.text =[NSString stringWithFormat:@"@%@", user[@"screen_name"]];
    NSURL *imageurl = [NSURL URLWithString:user[@"profile_image_url"]];
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageurl]];
    
    //tweetLabel.text=arrayTweet[indexPath.row];
    //nameLabel.text = name;
    //screenNameLabel.text = screenname;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
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
