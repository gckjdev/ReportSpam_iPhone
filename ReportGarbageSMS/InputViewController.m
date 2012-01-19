//
//  InputViewController.m
//  ReportGarbageSMS
//
//  Created by haodong qiu on 12年1月4日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "InputViewController.h"
#import <AddressBook/AddressBook.h>
#import "AddressBookUtils.h"
#import "ASIHTTPRequest.h"
#import "UIDevice+IdentifierAddition.h"
#import "Contact.h"
#import "ContactManager.h"
#import "LocaleUtils.h"
#import "ColorManager.h"

@implementation InputViewController
@synthesize numberLabel;
@synthesize typeLabel;
@synthesize phoneNumberTextField;
@synthesize selectTypeButton;
@synthesize submitButton;

- (void)dealloc {
    [selectTypeButton release];
    [phoneNumberTextField release];
    [numberLabel release];
    [typeLabel release];
    [submitButton release];
    [super dealloc];
}

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
    phoneNumberTextField.placeholder = NSLS(@"kInputPhonePlaceholder");
    numberLabel.text = NSLS(@"kNumber");
    typeLabel.text = NSLS(@"kType");
    [selectTypeButton setTitle:NSLS(@"kType1") forState:UIControlStateNormal];
    [submitButton setTitle:NSLS(@"kReport") forState:UIControlStateNormal];
    
    [numberLabel setTextColor:[ColorManager tipLabelColor]];
    [typeLabel setTextColor:[ColorManager tipLabelColor]];
    
    [phoneNumberTextField setTextColor:[ColorManager defaultTextColor]];
    [selectTypeButton setTitleColor:[ColorManager defaultTextColor] forState:UIControlStateNormal];
    
    [submitButton setTitleColor:[ColorManager buttonTitleColor] forState:UIControlStateNormal];
}

- (void)viewDidUnload
{
    [self setSelectTypeButton:nil];
    [self setPhoneNumberTextField:nil];
    [self setNumberLabel:nil];
    [self setTypeLabel:nil];
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

- (IBAction)selectType:(id)sender
{
    UIActionSheet * typeActionSheet = [[UIActionSheet alloc] initWithTitle:NSLS(@"kSelectType") 
                                                             delegate:self 
                                                         cancelButtonTitle:NSLS(@"kBack")
                                                    destructiveButtonTitle:NSLS(@"kType1") 
                                                         otherButtonTitles:NSLS(@"kType2"), NSLS(@"kType3"), NSLS(@"kType4"), NSLS(@"kType5"), nil];
    
    [typeActionSheet showInView:self.view];
    [typeActionSheet release];
}




- (IBAction)submit:(id)sender
{
    if ([phoneNumberTextField.text length] == 0){
        // 
        return;
    }
    
    [phoneNumberTextField resignFirstResponder];
    
    NSString *phone = phoneNumberTextField.text;
    NSString *phoneLabel =  selectTypeButton.titleLabel.text;
    
    Contact *contact = [[Contact alloc] initWithPerson:kGarbageSMSUserName PhoneLabel:phoneLabel  phone:phone];
    ContactManager *contactManager = [[ContactManager alloc] init];
    
    [contactManager addContact:contact];
    
    [contactManager release];
    [contact release];
    
    
    [self addPhoneNumber:phone]; 
    
    phoneNumberTextField.text = @"";
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [phoneNumberTextField resignFirstResponder];
    
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        return ;
    }
    [selectTypeButton setTitle:[actionSheet buttonTitleAtIndex:buttonIndex] forState:UIControlStateNormal ];
}

#pragma mark - Network
- (void)addPhoneNumber:(NSString*)phoneNumber
{
    UIDevice *device = [[UIDevice alloc] init];
    NSString *deviceIdentifier = [device uniqueGlobalDeviceIdentifier];
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.dipan100.com/api/i?m=rsn&mobile=%@&device=%@&type=1", phoneNumber, deviceIdentifier];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
    
    [device release];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    // Use when fetching binary data
    NSData *responseData = [request responseData];
    
    NSLog(@"responseString is :%@",responseString);
    NSLog(@"responseDat is :%@",responseData);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"error is :%@",error);
}


@end
