//
//  HelpViewController.m
//  ReportGarbageSMS
//
//  Created by haodong qiu on 12年1月9日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "HelpViewController.h"
#import "LocaleUtils.h"
#import "ColorManager.h"

@implementation HelpViewController
@synthesize contentTextView;

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
    self.title = NSLS(@"kHelpTitle");
    contentTextView.text = NSLS(@"kHelpContent");
    contentTextView.textColor = [ColorManager helpTextColor];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:NSLS(@"kBack") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setContentTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [contentTextView release];
    [super dealloc];
}
@end
