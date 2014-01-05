//
//  LentaView.m
//  Project
//
//  Created by Admin on 1/5/14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import "LentaView.h"

@interface LentaView ()

@end

@implementation LentaView

@synthesize tweetDict,tweetTable;

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
    [self downloadLenta];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)downloadLenta
{
    
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
                NSURL *requestAPI = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
                SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestAPI parameters:param];
                [twitterInfoRequest setAccount:twitterAccount];
                [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    
                    tweetDict= [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                    if(tweetDict.count!=0){
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            //[tweetTable beginUpdates];
                            
                            NSLog(@"tweetDICT COUNT = %d",tweetDict.count);
                            
                            
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
    //return [tweetDict count];
    return 10;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath * )indexPath
{
    
    TweetView *tweetView = [[TweetView alloc]initWithNibName:@"TweetView" bundle:nil];
    tweetView.lentaORtweet = YES;
    NSDictionary *dict = tweetDict[indexPath.row];
    tweetView.tweet = dict;
    NSLog(@"TWEET TEXT ====  %@",dict[@"text"] );
    [self.navigationController pushViewController:tweetView animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog (@"CELL NEW");
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    CGRect size = CGRectMake(40, 25, 320, 25);
    tweetLabel = [[UILabel alloc]initWithFrame:size];
    tweetLabel.frame = size;
    size = CGRectMake(40, 0, 100, 20);
    nameLabel = [[UILabel alloc]initWithFrame:size];
    
    size = CGRectMake(140, 0, 240, 20);
    screenNameLabel = [[UILabel alloc]initWithFrame:size];
    size = CGRectMake(0, 15, 35, 35);
    imageCell = [[UIImageView alloc]initWithFrame:size];
   // imageCell.image = mainImage;
    //tweetLabel.text = @"tweetLabel";
    //nameLabel.text = @"nameLabel";
    nameLabel.font = [UIFont systemFontOfSize:12.0];
    screenNameLabel.font = [UIFont systemFontOfSize:12.0];
   // screenNameLabel.text = @"ScreenLabel";
    NSDictionary *dict = tweetDict[indexPath.row];
    NSDictionary *user = dict[@"user"];
    NSString *scrname = user[@"screen_name"];
    NSLog(@"ScreenName = %@",scrname);
    NSLog(@"BOOL = %d",[scrname length]) ;
    
    tweetLabel.text=dict[@"text"];
    nameLabel.text = user[@"name"];
    cell.textLabel.text = dict[@"text"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"@%@", user[@"screen_name"]];
    
    //[cell addSubview:tweetLabel];
   // [cell addSubview:nameLabel];
    //[cell addSubview:screenNameLabel];
    //[cell addSubview:imageCell];
    
    
    
    NSURL *imageurl = [NSURL URLWithString:user[@"profile_image_url_https"]];
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageurl]];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
}


@end
