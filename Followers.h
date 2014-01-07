//
//  Followers.h
//  Project
//
//  Created by Admin on 1/8/14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Followers : NSManagedObject
@property (nonatomic, retain) NSString * screen_name;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * image;

@end
