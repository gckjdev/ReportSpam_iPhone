//
//  Contact.m
//  ReportGarbageSMS
//
//  Created by haodong qiu on 12年1月7日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "Contact.h"

@implementation Contact

@synthesize person;
@synthesize phoneLabel;
@synthesize phone;

- (id)initWithPerson:(NSString *)personValue PhoneLabel:(NSString *)phoneLabelValue phone:(NSString *)phoneValue
{
    self = [super init];
    if (self) {
        self.person = personValue;
        self.phoneLabel = phoneLabelValue;
        self.phone = phoneValue;
    }
    return self;
}

- (void)dealloc
{
    [person release];
    [phoneLabel release];
    [phone release];
    [super dealloc];
}



@end
