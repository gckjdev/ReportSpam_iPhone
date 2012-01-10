//
//  Contact.h
//  ReportGarbageSMS
//
//  Created by haodong qiu on 12年1月7日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property (nonatomic, retain) NSString *person;
@property (nonatomic, retain) NSString *phoneLabel;
@property (nonatomic, retain) NSString *phone;

- (id)initWithPerson:(NSString *)personValue PhoneLabel:(NSString *)phoneLabelValue phone:(NSString *)phoneValue;

@end
