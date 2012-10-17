//
//  CoreDataManager.h
//  CoreDataInitializeDemo
//
//  Created by onoT on 2012/10/17.
//  Copyright (c) 2012年 onoT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Master.h"

@interface CoreDataManager : NSObject

// プロパティ
@property (nonatomic, readonly) NSManagedObjectContext* managedObjectContext;

// 初期化
+ (CoreDataManager*)sharedManager;

// Masterの操作
- (NSArray*)sortedMasters;
- (NSUInteger)initMasters;
- (Master*)insertNewMaster;

// 永続化
- (void)save;

@end
