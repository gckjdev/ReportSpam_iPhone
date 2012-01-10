//
//  FeedbackViewController.h
//  ReportGarbageSMS
//
//  Created by haodong qiu on 12年1月9日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface FeedbackViewController : ViewController

@property (retain, nonatomic) IBOutlet UITextView *detailTextView;
@property (retain, nonatomic) IBOutlet UITextField *contactTextField;
@property (retain, nonatomic) IBOutlet UIButton *submitButton;


- (IBAction)submit:(id)sender;

@end
