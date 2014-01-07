//
//  LentaList.h
//  Project
//
//  Created by Admin on 1/7/14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface LentaList : NSManagedObject
@property (nonatomic, retain) NSString * screen_name;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSData * image;


@end
