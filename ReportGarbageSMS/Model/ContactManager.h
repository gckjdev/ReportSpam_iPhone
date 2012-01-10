//
//  ContactManager.h
//  ReportGarbageSMS
//
//  Created by haodong qiu on 12年1月7日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Contact;

@interface ContactManager : NSObject

- (void)addContact:(Contact *)contact;

- (void)deleteContact:(Contact *)contact;

- (NSArray *)getAllPhoneAndLabel:(NSString *)person;

@end
