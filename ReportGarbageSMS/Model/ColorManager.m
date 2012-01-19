//
//  ColorManager.m
//  ReportGarbageSMS
//
//  Created by haodong qiu on 12年1月19日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "ColorManager.h"

@implementation ColorManager

+ (UIColor*)defaultTextColor
{
    return [UIColor colorWithRed:0x30/255.0 
                          green:0x30/255.0 
                           blue:0x30/255.0
                          alpha:1];
}

+ (UIColor*)helpTextColor
{
    return [UIColor colorWithRed:0x20/255.0 
                           green:0x20/255.0 
                            blue:0x20/255.0
                           alpha:1];
}

+ (UIColor*)buttonTitleColor
{
    return [UIColor colorWithRed:0x32/255.0 
                           green:0x4F/255.0 
                            blue:0x85/255.0
                           alpha:1];
}

+ (UIColor*)tipLabelColor
{
    return [UIColor colorWithRed:0x25/255.0 
                           green:0x49/255.0 
                            blue:0x72/255.0
                           alpha:1];
}

@end
