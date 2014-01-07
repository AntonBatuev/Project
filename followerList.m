//
//  followerList.m
//  Project
//
//  Created by Admin on 1/4/14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import "followerList.h"
#import "AppDelegate.h"
#import "Followers.h"
@interface followerList ()
{
    NSManagedObjectContext *context;
}
@end

@implementation followerList

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
    self.title  = @"Фолловеры";
     [self.navigationController setNavigationBarHidden:NO];
    [self downloadFollowerList];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    context = [appdelegate managedObjectContext];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription  *entity = [NSEntityDescription entityForName:@"Followers" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
    
    if (appdelegate.netStatus == NotReachable)
    {
        NSLog(@"Not connectionnnnnnnn");
        //if (fetchedObjects.count!=0) {
        netConnect = NO;
        
        NSLog(@"Кор дата не пустая.Должны заполнить таблицу из кор даты");
        flag = YES;
        // [followerTable reloadData];
        //  }
        NSLog(@"fetchedObjects.count = = = %d",fetchedObjects.count);
        //  else
        //{  // flag = NO;
        //                [self downloadLenta];
        //                NSLog(@"Кор дата пустая.Заполняем кор дату из твиитДикт,потом заполняем таблицу из кордаты");
        //  }
        
        
        
    }
    else if (appdelegate.netStatus ==ReachableViaWiFi)
    {
     //   NSLog(@"WIFIIIIIII");
        netConnect = YES;
        [self downloadFollowerList];
        //            [self saveData];
        //            [tweetTable reloadData];
        
        NSLog(@"Wifiiiiiiiiiiii");
    }

    
}
-(void)saveData
{
    //AppDelegate *appdelegate  = [[UIApplication sharedApplication]delegate];
    //context = [appdelegate managedObjectContext];
    //dispatch_async(dispatch_get_main_queue(), ^{
    
    NSFetchRequest *allfetch = [[NSFetchRequest alloc]init];
    [allfetch setEntity:[NSEntityDescription entityForName:@"Followers" inManagedObjectContext:context]];
    NSArray *arrr = [context executeFetchRequest:allfetch error:nil];
    
    for (Followers *lentt in arrr)
    {
        [context deleteObject:lentt];
    }
    NSError *saveError = nil;
    [context save:&saveError];
    
    
    
    
    NSLog(@"saveDataCountTweet = %d",[users count]);
    for (int i =0 ; i<[users count]; i++)
    {
        Followers *followers = [NSEntityDescription insertNewObjectForEntityForName:@"Followers" inManagedObjectContext:context];
        NSDictionary *dict = users[i];
        //  NSDictionary *user = dict[@"user"];
        followers.name = dict[@"name"];
        followers.screen_name =[NSString stringWithFormat:@"@%@", dict[@"screen_name"]];
        NSURL *imageurl = [NSURL URLWithString:dict[@"profile_image_url_https"]];
        followers.image = [NSData dataWithContentsOfURL:imageurl];
    }
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
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
    if (netConnect==NO)
    {
        NSLog(@"count row = %d",[tweetDict count]);
        NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription  *entity = [NSEntityDescription entityForName:@"Followers" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
        return [fetchedObjects count];
    }
    else
    {
        return [users count];
    }
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
    numberRow = indexPath.row;
    UIActionSheet * actSheet =[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:@"Отправить сообщение",@"Просмотр профиля", nil];
    actSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actSheet showInView:self.view];
    
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
       // UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
   // [cell addSubview:button];
    if (netConnect == NO) {
        
        NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription  *entity = [NSEntityDescription entityForName:@"Followers" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
        NSLog(@"COUNT FETCHEDOBJECTS = %d",[fetchedObjects count]);
        NSMutableArray *Array_name = [NSMutableArray arrayWithCapacity:[fetchedObjects count]];
        NSMutableArray *Array_Screen_name = [NSMutableArray arrayWithCapacity:[fetchedObjects count]];
        NSMutableArray *Array_image = [NSMutableArray arrayWithCapacity:[fetchedObjects count]];
        [Array_name removeAllObjects];
        [Array_Screen_name removeAllObjects];
        [Array_image removeAllObjects];
        for (Followers *info in fetchedObjects)
        {
            
            // cell.textLabel.text = info.text;
            
            [Array_name addObject:info.name];
            [Array_Screen_name addObject:info.screen_name];
            [Array_image addObject:info.image];
            //NSLog(@"Text: %@", info.text);
            //  NSLog(@"screen_name: %@", info.screen_name);
        }
        
        cell.textLabel.text =Array_name[indexPath.row];
        cell.detailTextLabel.text =Array_Screen_name[indexPath.row];
        cell.imageView.image = [UIImage imageWithData:Array_image[indexPath.row]];
    }
    else
    {
        cell.textLabel.text = user[@"name"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"@%@", user[@"screen_name"]];
        NSURL *urlImage = [NSURL URLWithString:user[@"profile_image_url"]];
        cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlImage]];
        
        //}
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
}
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"Send message");
            NSDictionary *us =users[numberRow];
            SendPrivateView *sendView = [[SendPrivateView alloc]initWithNibName:@"SendPrivateView" bundle:nil];
            //NSLog(@"screen Name = %@",us[@"screen_name"]);
            sendView.screen_name =us[@"screen_name"];
            [self.navigationController pushViewController:sendView animated:YES];
        }
            break;
            case 1:
            
        {
            ProfileView * profileView = [[ProfileView alloc]initWithNibName:@"ProfileView" bundle:nil];
            NSDictionary *user = users[numberRow];
            //cell.textLabel.text = user[@"name"];
            //cell.detailTextLabel.text = [NSString stringWithFormat:@"@%@", user[@"screen_name"]];
            profileView.SCREEN_NAME =user[@"screen_name"];
             NSLog(@"screen Name = %@",user[@"screen_name"]);
            [self.navigationController pushViewController:profileView animated:YES];

                   }
            break;
            
            
            case 2:
        { NSLog(@"cancel");

                  }
            break;
                  default:
            break;
    }
    
    NSLog(@"NUMBER BUTTON = %d",buttonIndex);
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
                [param setObject:twitterAccount.username forKey:@"screen_name"];
                NSURL *requestAPI = [NSURL URLWithString:@"https://api.twitter.com/1.1/followers/list.json"];
                SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestAPI parameters:param];
                [twitterInfoRequest setAccount:twitterAccount];
                [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
                {
                    tweetDict= [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                    NSLog(@"tweetDict = %d",tweetDict.count);
                    if(tweetDict.count!=0){
                        dispatch_async(dispatch_get_main_queue(), ^
                        {
                            users = tweetDict[@"users"];
                            NSLog(@"users = %d",[users count]);
                           [self saveData];
                            [followerTable reloadData];
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
