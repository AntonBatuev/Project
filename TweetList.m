//
//  TweetList.m
//  Project
//
//  Created by Admin on 1/3/14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import "TweetList.h"

@interface TweetList ()



@end

@implementation TweetList

@synthesize image,tweetDict;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
     [self downloadTweet];
     NSLog(@"count tweet  = %d",tweetDict.count);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)downloadTweet
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
                NSURL *requestAPI = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"];
                SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestAPI parameters:param];
                [twitterInfoRequest setAccount:twitterAccount];
                [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Check if we reached the reate limit
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
                        if (responseData) {
                            NSLog(@"RESPONSEDATA");
                            NSError *error = nil;
                            tweetDict= [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                            
                            
                        }
                    });
                }];
            }
        } else
        {
            NSLog(@"No access granted");
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    


    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    CGRect size = CGRectMake(40, 25, 150, 25);
    UILabel *tweetLabel = [[UILabel alloc]initWithFrame:size];
    size = CGRectMake(40, 0, 100, 20);
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:size];
    size = CGRectMake(140, 0, 240, 20);
    UILabel *screenNameLabel = [[UILabel alloc]initWithFrame:size];
    size = CGRectMake(0, 10, 35, 35);
    UIImageView *imageCell = [[UIImageView  alloc]initWithFrame:size];
    imageCell.image = image;
    tweetLabel.text = @"tweetLabel";
    nameLabel.text = @"nameLabel";
    nameLabel.font = [UIFont systemFontOfSize:12.0];
    screenNameLabel.font = [UIFont systemFontOfSize:12.0];
    screenNameLabel.text = @"ScreenLabel";
    [cell addSubview:imageCell];
    [cell addSubview:tweetLabel];
    [cell addSubview:nameLabel];
    [cell addSubview:screenNameLabel];
 //   cell.imageView.image = image;
    NSDictionary *dict = tweetDict[indexPath.row];
    tweetLabel.text= dict[@"text"];
    // Configure the cell...
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;

}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"COUNT  == %d",tweetDict.count);
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
 */

@end
