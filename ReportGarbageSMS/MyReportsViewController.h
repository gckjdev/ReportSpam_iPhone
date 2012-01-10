//
//  MyReportsViewController.h
//  ReportGarbageSMS
//
//  Created by haodong qiu on 12年1月4日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface MyReportsViewController : ViewController <UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate>
{
    NSMutableArray *listData;
    NSMutableArray *showListData;
}
@property (nonatomic, retain) NSMutableArray *listData;
@property (nonatomic, retain) NSMutableArray *showListData;

@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UITableView *reportsTableView;

- (void)update:(NSString *)keyword;
- (void)initData;

@end
