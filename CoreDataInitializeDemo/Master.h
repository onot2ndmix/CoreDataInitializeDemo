//
//  Master.h
//  CoreDataInitializeDemo
//
//  Created by onoT on 2012/10/17.
//  Copyright (c) 2012年 onoT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Master : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * sortOrder;

@end
