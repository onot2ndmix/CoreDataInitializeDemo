//
//  CoreDataManager.m
//  CoreDataInitializeDemo
//
//  Created by onoT on 2012/10/17.
//  Copyright (c) 2012年 onoT. All rights reserved.
//

#import "CoreDataManager.h"
#import "Master.h"

@implementation CoreDataManager {
    NSManagedObjectContext* _managedObjectContext;
    BOOL isInit;
}

#pragma mark --- 初期化 ---
static CoreDataManager* _sharedInstance = nil;

+ (CoreDataManager*)sharedManager
{
    // インスタンス生成
    if (!_sharedInstance) {
        _sharedInstance = [[CoreDataManager alloc] init];
    }
    return _sharedInstance;
}

#pragma mark --- プロパティ ---
- (NSManagedObjectContext*)managedObjectContext
{
    NSError* error = nil;
    isInit = NO;
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    // 管理対象オブジェクトモデル作成
    NSManagedObjectModel* managedObjectModel;
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    // 永続化ストアコーディネータ作成
    NSPersistentStoreCoordinator* persistentStoreCoordinator;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                  initWithManagedObjectModel:managedObjectModel];
    
    // ストアURL作成
    NSArray* paths;
    NSString* path = nil;
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"paths : %@", paths);
    if ([paths count] > 0) {
        path = [paths objectAtIndex:0];
        path = [path stringByAppendingPathComponent:@".demo"];
        path = [path stringByAppendingPathComponent:@"demo.db"];
    }
    
    if (!path) {
        return nil;
    }
    
    // ディレクトリ作成
    NSString* dirPath;
    NSFileManager* fileMgr;
    dirPath = [path stringByDeletingLastPathComponent];
    fileMgr = [NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:dirPath]) {
        if (![fileMgr createDirectoryAtPath:dirPath
                withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"Failed to create directory at path %@, error %@",
                  dirPath, [error localizedDescription]);
        }
        isInit = YES;
    }
    
    // ストアURL作成
    NSURL* url = nil;
    url = [NSURL fileURLWithPath:path];
        
    // 永続化ストアの追加
    NSPersistentStore* persistentStore;
    persistentStore = [persistentStoreCoordinator
                       addPersistentStoreWithType:NSSQLiteStoreType
                       configuration:nil URL:url options:nil error:&error];
    //                       configuration:nil URL:url options:nil error:&error];
    if (!persistentStore && error) {
        NSLog(@"Failed to create add persistent store, %@", [error localizedDescription]);
    }
    
    // 管理対象オブジェクトコンテキスト作成
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    
    // 永続コーディネータ設定
    [_managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    
    return _managedObjectContext;
}

#pragma mark --- Masterの操作 ---
- (NSArray*)sortedMasters
{
    // 管理対象オブジェクトコンテキストを取得する
    NSManagedObjectContext* context;
    context = self.managedObjectContext;
    
    // 初期データ投入
    if (isInit) {
        if ([self initMasters] == 0) {
            NSError*    error = nil;
            NSLog(@"initMasters: failed, %@", [error localizedDescription]);
            return nil;
        }
    }
    
    // 取得要求を作成する
    NSFetchRequest*         request;
    NSEntityDescription*    entity;
    NSSortDescriptor*       sortDescriptor;
    request = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:@"Master" inManagedObjectContext:context];
    [request setEntity:entity];
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortOrder" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    // 取得要求を実行する
    NSArray*    result;
    NSError*    error = nil;
    result = [context executeFetchRequest:request error:&error];
    if (!result) {
        // エラー
        NSLog(@"executeFetchRequest: failed, %@", [error localizedDescription]);
        return nil;
    }
    return result;
}

- (Master*)insertNewMaster
{
    // 管理対象オブジェクトコンテキストを取得
    NSManagedObjectContext* context;
    context = self.managedObjectContext;
    
    // Masterを作成
    Master* master;
    master = [NSEntityDescription insertNewObjectForEntityForName:@"Master" inManagedObjectContext:context];
    
    // 識別子の設定
    CFUUIDRef uuid;
    NSString* identifier;
    uuid = CFUUIDCreate(NULL);
    identifier = (__bridge NSString*)CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    master.identifier = identifier;
    
    return master;
    
}

- (NSUInteger)initMasters
{
    // プロパティリストを読み込んで初期データをセットする
    NSString* path = [[NSBundle mainBundle] pathForResource:@"MasterInitialData" ofType:@"plist"];
    NSMutableArray* mastersList = [NSArray arrayWithContentsOfFile:path];
    if (mastersList == nil) {
        // エラー
        NSLog(@"Initialize Data file not found");
        return 0;
    }
    // 管理対象オブジェクトコンテキストを取得
    NSManagedObjectContext* context;
    context = self.managedObjectContext;
    
    int i = 0;
    for (i = 0; i < [mastersList count]; i++) {
        NSDictionary* masterItem = [mastersList objectAtIndex:i];
        // Mindを作成
        Master* master;
        master = [self insertNewMaster];
        master.image = [masterItem objectForKey:@"image"];
        master.title = [masterItem objectForKey:@"title"];
        master.sortOrder = [masterItem objectForKey:@"sortOrder"];
        [self save];
    }
    return i;
}

#pragma mark --- 永続化 ---

- (void)save
{
    // 保存
    NSError*    error;
    if (![self.managedObjectContext save:&error]) {
        // エラー
        NSLog(@"Save Error, %@", error);
    }
}

@end
