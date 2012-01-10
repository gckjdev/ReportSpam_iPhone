//
//  MyReportsCell.m
//  ReportGarbageSMS
//
//  Created by haodong qiu on 12年1月7日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "MyReportsCell.h"

@implementation MyReportsCell

@synthesize phone;
@synthesize phoneLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [phone release];
    [phoneLabel release];
    [super dealloc];
}

@end
