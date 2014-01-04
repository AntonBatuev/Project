//
//  TweetPost.m
//  Project
//
//  Created by Admin on 1/2/14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import "TweetPost.h"

@interface TweetPost ()

@end

@implementation TweetPost
@synthesize LabelCountSymbol,TextView,image,imagePicker,ImageView,photoButton,sendTweet;

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
    sendTweet.enabled = NO;
    fotoFlag= NO;
    [self.navigationController setNavigationBarHidden:NO];
    ImageView.layer.cornerRadius =60;
    ImageView.clipsToBounds  = YES;
    
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
    if (len == 0) sendTweet.enabled = NO;
    else sendTweet.enabled = YES;
    
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
- (IBAction)Tweet:(id)sender {
    
        
    
    ACAccountStore* accountStore= [[ACAccountStore alloc]init];
    NSString *status =TextView.text;
    ACAccountType *twitterType =
    [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    if (fotoFlag ==NO) {
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
            NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"];
            NSDictionary *params = @ {@"status" : status};
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
        
        TextView.text = @"";
        LabelCountSymbol.text=@"140";
    }
    else
    {
    ///////////WITH FOTO
        NSString *status = TextView.text;
        
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
                NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update_with_media.json"];
                NSDictionary *params = @ {@"status" : status};
                SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                        requestMethod:SLRequestMethodPOST
                                                                  URL:url
                                                           parameters:params];
                 NSData *imageData = UIImageJPEGRepresentation(image, 1.f);
                [request addMultipartData:imageData
                          withName:@"media[]"
                            type:@"image/jpeg"
                      filename:@"image.jpg"];
                [request setAccount:[accounts lastObject]];
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
        
        TextView.text = @"";
         LabelCountSymbol.text=@"140";
    }
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    

        image = info[UIImagePickerControllerOriginalImage];
     [ImageView setImage:image];
    [photoButton setTitle:@"Убрать Фото" forState:UIControlStateNormal];
     fotoFlag = YES;
    // myimage = info[UIImagePickerController	];
    //[img setImage:myimage];
    

    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)attachPhoto:(id)sender {
    
    if (fotoFlag==YES) {
        NSLog(@"FOTO selected");
        ImageView.image = nil;
        fotoFlag = NO;
        [photoButton setTitle:@"Добавить Фото" forState:UIControlStateNormal];
    }
    else if (fotoFlag==NO)
    {
        NSLog(@"FOTO don`t selected");
       
        self.imagePicker = [[UIImagePickerController alloc]init];
        self.imagePicker.delegate = self;
        [self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:self.imagePicker animated:YES completion:nil];
        //[photoButton setTitle:@"Убрать Фото" forState:UIControlStateNormal];

    }

    

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
