//
//  MyReportsCell.h
//  ReportGarbageSMS
//
//  Created by haodong qiu on 12年1月7日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyReportsCell : UITableViewCell{
    UILabel *phone;
    UILabel *phoneLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *phone;
@property (nonatomic, retain) IBOutlet UILabel *phoneLabel;

@end
