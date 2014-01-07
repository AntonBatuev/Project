//
//  LentaView.m
//  Project
//
//  Created by Admin on 1/5/14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import "LentaView.h"
#import "LentaList.h"
#import <CoreData/CoreData.h>
@interface LentaView ()
{
    NSManagedObjectContext *context;
//    NSFetchRequest *fetchRequest;
//    NSEntityDescription *entity;
  //  NSArray *fetchedObjects;
}
@end

@implementation LentaView

@synthesize tweetDict,tweetTable,indicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *result;
    
    //  dispatch_async(dispatch_get_main_queue(), ^{
    context = [appdelegate managedObjectContext];
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription  *entity = [NSEntityDescription entityForName:@"LentaList" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
    
    if (appdelegate.netStatus == NotReachable)
    {
        NSLog(@"Not connectionnnnnnnn");
        if (fetchedObjects.count!=0) {
            netConnect = NO;

            NSLog(@"Кор дата не пустая.Должны заполнить таблицу из кор даты");
            flag = YES;
            [tweetTable reloadData];
        }
                            else
                   {  // flag = NO;
        //                [self downloadLenta];
        //                NSLog(@"Кор дата пустая.Заполняем кор дату из твиитДикт,потом заполняем таблицу из кордаты");
                  }
        
        
        
    }
    else if (appdelegate.netStatus ==ReachableViaWiFi)
    {
        netConnect = YES;
        [self downloadLenta];
        //            [self saveData];
        //            [tweetTable reloadData];
        
        NSLog(@"Wifiiiiiiiiiiii");
    }
    
    NSLog(@"ViewDidLoad");
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    self.title  = @"Лента";
    indicator.hidden = NO;

}

- (void)viewDidLoad

{
    
       // AppDelegate *appdelegate  = [[UIApplication sharedApplication]delegate];
//    if (fetchedObjects.count!=0) {
//        NSLog(@"Кор дата не пустая.Должны заполнить таблицу из кор даты");
//        flag = YES;
//        [tweetTable reloadData];
//    }
//    else
//    {   flag = NO;
//        [self downloadLenta];
//        NSLog(@"Кор дата пустая.Заполняем кор дату из твиитДикт,потом заполняем таблицу из кордаты");
//    }
//    AppDelegate *appdelegate  = [[UIApplication sharedApplication]delegate];
//    context = [appdelegate managedObjectContext];
//    fetchRequest = [[NSFetchRequest alloc] init];
//    entity = [NSEntityDescription entityForName:@"LentaList" inManagedObjectContext:context];
//    [fetchRequest setEntity:entity];
//    NSError *error;
//    fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
//    [tweetTable reloadData];
   // [self downloadLenta];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveData
{
    //AppDelegate *appdelegate  = [[UIApplication sharedApplication]delegate];
   //context = [appdelegate managedObjectContext];
          //dispatch_async(dispatch_get_main_queue(), ^{
  
        NSFetchRequest *allfetch = [[NSFetchRequest alloc]init];
        [allfetch setEntity:[NSEntityDescription entityForName:@"LentaList" inManagedObjectContext:context]];
        NSArray *arrr = [context executeFetchRequest:allfetch error:nil];
    
        for (LentaList *lentt in arrr) {
            [context deleteObject:lentt];
        }
        NSError *saveError = nil;
        [context save:&saveError];

    
    
    
    NSLog(@"saveDataCountTweet = %d",[tweetDict count]);
    for (int i =0 ; i<[tweetDict count]; i++) {
        LentaList *lentalist = [NSEntityDescription insertNewObjectForEntityForName:@"LentaList" inManagedObjectContext:context];
        NSDictionary *dict = tweetDict[i];
        NSDictionary *user = dict[@"user"];
        lentalist.text = dict[@"text"];
        lentalist.screen_name =[NSString stringWithFormat:@"@%@", user[@"screen_name"]];
        NSURL *imageurl = [NSURL URLWithString:user[@"profile_image_url_https"]];
        lentalist.image = [NSData dataWithContentsOfURL:imageurl];
    }
//
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    //[tweetTable reloadData];
    
//******************************
//    NSFetchRequest *allfetch = [[NSFetchRequest alloc]init];
//    [allfetch setEntity:[NSEntityDescription entityForName:@"LentaList" inManagedObjectContext:context]];
//    NSArray *arrr = [context executeFetchRequest:allfetch error:nil];
//    
//    for (LentaList *lentt in arrr) {
//        [context deleteObject:lentt];
//    }
//    NSError *saveError = nil;
//    [context save:&saveError];

//*******************************
//  NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
//   NSEntityDescription  *entity = [NSEntityDescription entityForName:@"LentaList" inManagedObjectContext:context];
//    [fetchRequest setEntity:entity];
//   fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
//    for (LentaList *info in fetchedObjects)
//    {
//        NSLog(@"Text: %@", info.text);
//        NSLog(@"screen_name: %@", info.screen_name);
//    }
  
//    NSLog(@"count fetch  = %d",[fetchedObjects count]);
    
  
    
//    NSLog(@"count fetch2  = %d",[arrr count]);

}
-(void)downloadLenta
{
    [indicator startAnimating];
   //  indicator.hidden = NO;
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
                    
                   // tweetDict= [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                   // if(tweetDict.count!=0){
                        
                        
                       dispatch_async(dispatch_get_main_queue(), ^{
                            tweetDict= [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
                           
                           
                           
                          // AppDelegate *appdelegate  = [[UIApplication sharedApplication]delegate];
                         //  context = [appdelegate managedObjectContext];
                           
                           
//                           fetchRequest = [[NSFetchRequest alloc]init];
//                           [fetchRequest setEntity:[NSEntityDescription entityForName:@"LentaList" inManagedObjectContext:context]];
//                           NSArray *arrr = [context executeFetchRequest:fetchRequest error:nil];
//                           
//                           for (LentaList *lentt in arrr) {
//                               [context deleteObject:lentt];
//                           }
//                           NSError *saveError = nil;
//                           [context save:&saveError];
//                           NSLog(@"count fetch2  = %d",[arrr count]);
//                           

                          [self saveData];
                           [tweetTable reloadData];
                           
                           // [tweetTable reloadData];
                       });
                    
                    
                            // Check if we reached the reate limit
                        //});
                        
                 //   }
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
  //  return [tweetDict count];
    if (netConnect==NO) {
        
    
    NSLog(@"count row = %d",[tweetDict count ]);
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription  *entity = [NSEntityDescription entityForName:@"LentaList" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];

    return [fetchedObjects count];
    }
    else
    {
        return [tweetDict count];
    }
    //return 10;
    
    //return tweetDict.count;
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
    
  //  NSLog (@"CELL NEW");
    
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
//    NSDictionary *dict = tweetDict[indexPath.row];
//    NSDictionary *user = dict[@"user"];
//    
//    AppDelegate *appdelegate  = [[UIApplication sharedApplication]delegate];
//    context = [appdelegate managedObjectContext];
//    
//    fetchRequest = [[NSFetchRequest alloc] init];
//    entity = [NSEntityDescription entityForName:@"LentaList" inManagedObjectContext:context];
//    [fetchRequest setEntity:entity];
//    NSError *error;
//    fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
//    NSLog(@"CELL_OBJECT = %d",[fetchedObjects count]);
   
//    for (LentaList *info in fetchedObjects)
//    {
//        NSLog(@"infotext =%@",info.text);
//        NSLog(@"screen_name = %@",info.screen_name)
//      //  cell.textLabel.text = info.text;
//       // cell.detailTextLabel.text = info.screen_name;
//
//    }
    NSDictionary *dict = tweetDict[indexPath.row];
    NSLog(@"DICT SIZE  = %d",dict.count );
    NSDictionary *user = dict[@"user"];

    if (netConnect == NO) {
        
      NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
       NSEntityDescription  *entity = [NSEntityDescription entityForName:@"LentaList" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
    NSLog(@"COUNT FETCHEDOBJECTS = %d",[fetchedObjects count]);
    NSMutableArray *Array_text = [NSMutableArray arrayWithCapacity:[fetchedObjects count]];
    NSMutableArray *Array_Screen_name = [NSMutableArray arrayWithCapacity:[fetchedObjects count]];
         NSMutableArray *Array_image = [NSMutableArray arrayWithCapacity:[fetchedObjects count]];
    [Array_text removeAllObjects];
    [Array_Screen_name removeAllObjects];
    for (LentaList *info in fetchedObjects)
        {
            
           // cell.textLabel.text = info.text;
            
            [Array_text addObject:info.text];
            [Array_Screen_name addObject:info.screen_name];
            [Array_image addObject:info.image];
         //NSLog(@"Text: %@", info.text);
          //  NSLog(@"screen_name: %@", info.screen_name);
       }
    
    cell.textLabel.text =Array_text[indexPath.row];
    cell.detailTextLabel.text =Array_Screen_name[indexPath.row];
    cell.imageView.image = [UIImage imageWithData:Array_image[indexPath.row]];
    }
    else
    {
        NSLog(@"CELL YES");
        cell.textLabel.text = dict[@"text"];
        //if ([[NSString stringWithFormat:@"@%@", user[@"screen_name"]] length]!=0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"@%@", user[@"screen_name"]];
             NSURL *imageurl = [NSURL URLWithString:user[@"profile_image_url_https"]];
        cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageurl]];
        

        //}
             }
        //    NSFetchRequest *allfetch = [[NSFetchRequest alloc]init];
//    [allfetch setEntity:[NSEntityDescription entityForName:@"LentaList" inManagedObjectContext:context]];
//    NSArray *arrr = [context executeFetchRequest:allfetch error:nil];
//    
//    for (LentaList *lentt in arrr) {
//        [context deleteObject:lentt];
//    }
//    NSError *saveError = nil;
//    [context save:&saveError];

//    cell.textLabel.text = dict[@"text"];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"@%@", user[@"screen_name"]];

      //dispatch_async(dispatch_get_main_queue(), ^{
   //     NSURL *imageurl = [NSURL URLWithString:user[@"profile_image_url_https"]];
    //cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageurl]];
    //});
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
}


@end
