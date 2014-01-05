//
//  friendsList.m
//  Project
//
//  Created by Admin on 1/4/14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import "friendsList.h"

@interface friendsList ()

@end

@implementation friendsList
@synthesize tweetDict,followerTable,users;

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
    [self downloadFollowerList];
    // Do any additional setup after loading the view from its nib.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [users count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationTop];
        
        
        [tableView reloadData];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath * )indexPath
{
    
    ProfileView * profileView = [[ProfileView alloc]initWithNibName:@"ProfileView" bundle:nil];
    NSDictionary *user = users[indexPath.row];
  
    profileView.SCREEN_NAME =user[@"screen_name"];
    NSLog(@"screen Name = %@",user[@"screen_name"]);
    NSLog(@"SCREEN NAME %@",user[@"screen_name"]);
    [self.navigationController pushViewController:profileView animated:YES];
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
    NSLog(@"array count = = = = %d",users.count);
    NSDictionary *user = users[indexPath.row];
    
    cell.textLabel.text = user[@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"@%@", user[@"screen_name"]];
    NSURL *urlImage = [NSURL URLWithString:user[@"profile_image_url"]];
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlImage]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
}
-(void)downloadFollowerList
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
                [param setObject:twitterAccount.username forKey:@"screenname"];
                NSURL *requestAPI = [NSURL URLWithString:@"https://api.twitter.com/1.1/friends/list.json"];
                SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestAPI parameters:param];
                [twitterInfoRequest setAccount:twitterAccount];
                [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    
                    tweetDict= [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                    if(tweetDict.count!=0){
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            users = tweetDict[@"users"];
                            NSLog(@"users = %d",[users count]);
                            
                            
                            
                            [followerTable reloadData];
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


@end
