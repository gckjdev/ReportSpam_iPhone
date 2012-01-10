//
//  InputViewController.h
//  ReportGarbageSMS
//
//  Created by haodong qiu on 12年1月4日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"


@interface InputViewController : ViewController<UIActionSheetDelegate>

@property (retain, nonatomic) IBOutlet UILabel *numberLabel;
@property (retain, nonatomic) IBOutlet UILabel *typeLabel;


@property (retain, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (retain, nonatomic) IBOutlet UIButton *selectTypeButton;
@property (retain, nonatomic) IBOutlet UIButton *submitButton;


- (IBAction)selectType:(id)sender;
- (IBAction)submit:(id)sender;

- (void)addPhoneNumber:(NSString*)phoneNumber;

@end
