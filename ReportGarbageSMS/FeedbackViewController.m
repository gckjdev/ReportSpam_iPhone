//
//  FeedbackViewController.m
//  ReportGarbageSMS
//
//  Created by haodong qiu on 12年1月9日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "FeedbackViewController.h"
#import "LocaleUtils.h"

@implementation FeedbackViewController
@synthesize detailTextView;
@synthesize contactTextField;
@synthesize submitButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [submitButton setTitle:NSLS(@"kSubmit") forState:UIControlStateNormal];
    contactTextField.placeholder = NSLS(@"kContactPlaceholder");
}

- (void)viewDidUnload
{
    [self setDetailTextView:nil];
    [self setContactTextField:nil];
    [self setSubmitButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)submit:(id)sender
{
    [detailTextView resignFirstResponder];
    [contactTextField resignFirstResponder];
    
    //在此加入提交操作
    
    
    detailTextView.text = @"";
    contactTextField.text = @"";
}

- (void)dealloc {
    [detailTextView release];
    [contactTextField release];
    [submitButton release];
    [super dealloc];
}
@end
