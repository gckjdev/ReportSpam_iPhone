//
//  MyReportsViewController.m
//  ReportGarbageSMS
//
//  Created by haodong qiu on 12年1月4日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "MyReportsViewController.h"
#import <AddressBook/AddressBook.h>
#import "AddressBookUtils.h"
#import "Contact.h"
#import "ContactManager.h"
#import "MyReportsCell.h"
#import "LocaleUtils.h"
#import "LocaleUtils.h"
#import "ColorManager.h"

@implementation MyReportsViewController

@synthesize listData;
@synthesize showListData;
@synthesize searchBar;
@synthesize reportsTableView;

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
    
    [self initData];
    [self.reportsTableView setEditing:NO animated:YES];
    self.searchBar.placeholder = NSLS(@"kSearchBarPlaceholder");
}

- (void)viewDidUnload
{
    [self setListData:nil];
    [self setShowListData:nil];
    [self setReportsTableView:nil];
    [self setSearchBar:nil];
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
    [listData release];
    [showListData release];
    [reportsTableView release];
    [searchBar release];
    [super dealloc];
}


//根据关键字查询,更新表视图
- (void)update:(NSString *)keyword
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(Contact *contact in self.listData){
        int i=[contact.phone rangeOfString:keyword].location;
        if(i<contact.phone.length){
            [array addObject:contact];
        }
    }
    
    self.showListData = array;
    if(keyword.length==0){
        [self initData];
    }
    [array release];
    [reportsTableView reloadData];
}

//初始化表的内容
- (void)initData
{
    ContactManager *contactManager = [[ContactManager alloc] init];
    NSArray *array = [contactManager getAllPhoneAndLabel:kGarbageSMSUserName]; 
    [contactManager release];
    
    self.listData = [NSMutableArray arrayWithArray:array];
    self.showListData = [NSMutableArray arrayWithArray:array];
}

#pragma mark - tableView data source delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.showListData count];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"myReports";
    
    MyReportsCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyReportsCell" owner:self options:nil];
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[MyReportsCell class]])
                cell = (MyReportsCell *)oneObject;
        }
        
    }
    
    Contact *contact = [showListData objectAtIndex:indexPath.row];
    
    NSString *phone = contact.phone;
    NSString *phoneLabel = contact.phoneLabel;
    
    cell.phone.text = phone;
    cell.phoneLabel.text = phoneLabel;
    
    cell.phone.textColor = [ColorManager defaultTextColor];
    cell.phoneLabel.textColor = [ColorManager defaultTextColor];
    
    return cell;
}

#pragma mark - tableView delegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //隐藏键盘
    [searchBar resignFirstResponder];
    
    return nil;
    //return indexPath;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"手指撮动了");
    return UITableViewCellEditingStyleDelete;
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLS(@"kDelete");
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Contact *contact = [self.showListData objectAtIndex:indexPath.row];
        
        ContactManager *contactManager = [[ContactManager alloc] init];
        [contactManager deleteContact:contact];
        NSArray *array = [contactManager getAllPhoneAndLabel:kGarbageSMSUserName];
        self.listData = [NSMutableArray arrayWithArray:array];
        [contactManager release];
        
        [showListData removeObjectAtIndex:indexPath.row];
        
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
       //[tableView reloadData];

    }
}
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}


#pragma mark - searchbar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self update:self.searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self update:self.searchBar.text];
}



@end
