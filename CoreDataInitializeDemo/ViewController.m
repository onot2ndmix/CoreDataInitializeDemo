//
//  ViewController.m
//  CoreDataInitializeDemo
//
//  Created by onoT on 2012/10/17.
//  Copyright (c) 2012年 onoT. All rights reserved.
//

#import "ViewController.h"
#import "CoreDataManager.h"
#import "Master.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize masters = _masters;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Masterオブジェクトを取得する
    self.masters = [[CoreDataManager sharedManager] sortedMasters];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --- UITableView Data Source ---

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.masters count];
    
}
/*
 - (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // rowの高さは、とりあえず固定で返す
 return 70.0;
 }
 */

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *mindCellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mindCellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mindCellIdentifier];
	}

	// セルの値を更新
    Master* master;
    master = [self.masters objectAtIndex:indexPath.row];
    NSString* filename = master.image;
    UIImage* iconImg = [UIImage imageNamed:filename];
    cell.imageView.image = iconImg;
	cell.textLabel.text = master.title;
    
	return cell;
}


@end
