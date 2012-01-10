//
//  ViewController.h
//  ReportGarbageSMS
//
//  Created by haodong qiu on 12年1月4日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTRevealSidebarV2Delegate.h"

#define kGarbageSMSUserName @"黑名单"
#define kGarbageSMSPhoneLabelName @"垃圾号码"

@class SidebarViewController;

@interface ViewController : UIViewController <JTRevealSidebarV2Delegate, UITableViewDelegate>


@property (nonatomic, strong) SidebarViewController *leftSidebarViewController;
@property (nonatomic, strong) UITableView *rightSidebarView;
@property (nonatomic, strong) NSIndexPath *leftSelectedIndexPath;
@property (nonatomic, strong) UILabel     *label;

@end
