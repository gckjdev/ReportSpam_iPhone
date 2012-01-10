//
//  ViewController.m
//  ReportGarbageSMS
//
//  Created by haodong qiu on 12年1月4日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "SidebarViewController.h"
#import "JTRevealSidebarV2Delegate.h"
#import "InputViewController.h"
#import "MyReportsViewController.h"
#import "HelpViewController.h"
#import "FeedbackViewController.h"




@interface ViewController (Private) <UITableViewDataSource, UITableViewDelegate, SidebarViewControllerDelegate>
@end



@implementation ViewController

@synthesize leftSidebarViewController;
@synthesize rightSidebarView;
@synthesize leftSelectedIndexPath;
@synthesize label;

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
    
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ButtonMenu.png"]  style:UIBarButtonItemStyleBordered target:self action:@selector(revealLeftSidebar:)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    [leftButtonItem release];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"help.png"]  style:UIBarButtonItemStylePlain target:self action:@selector(about)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    [rightButtonItem release];
    
    
    self.navigationItem.revealSidebarDelegate = self;

}

- (void)about
{
    HelpViewController *help = [[HelpViewController alloc] init];
    [self.navigationController pushViewController:help animated:YES];
    [help release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark JTRevealSidebarDelegate

// This is an examle to configure your sidebar view through a custom UIViewController
- (UIView *)viewForLeftSidebar {
    CGRect mainFrame = [[UIScreen mainScreen] applicationFrame];
    UITableViewController *controller = self.leftSidebarViewController;
    if ( ! controller) {
        self.leftSidebarViewController = [[SidebarViewController alloc] init];
        self.leftSidebarViewController.sidebarDelegate = self;
        controller = self.leftSidebarViewController;
        controller.view.frame = CGRectMake(0, mainFrame.origin.y, 270, mainFrame.size.height);
        controller.title = @"功能列表";
        controller.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    }
    return controller.view;
}



#pragma mark Action

- (void)revealLeftSidebar:(id)sender {
    JTRevealedState state = JTRevealedStateLeft;
    if (self.navigationController.revealedState == JTRevealedStateLeft) {
        state = JTRevealedStateNo;
    }
    [self.navigationController setRevealedState:state];
}

- (void)revealRightSidebar:(id)sender {
    JTRevealedState state = JTRevealedStateRight;
    if (self.navigationController.revealedState == JTRevealedStateRight) {
        state = JTRevealedStateNo;
    }
    [self.navigationController setRevealedState:state];
}


@end


@implementation ViewController (Private)

#pragma mark UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ( ! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.rightSidebarView) {
        return @"RightSidebar";
    }
    return nil;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController setRevealedState:JTRevealedStateNo];
    if (tableView == self.rightSidebarView) {
        self.label.text = [NSString stringWithFormat:@"Selected %d at RightSidebarView", indexPath.row];
    }
}

#pragma mark SidebarViewControllerDelegate

- (void)sidebarViewController:(SidebarViewController *)sidebarViewController didSelectObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath {
    
    [self.navigationController setRevealedState:JTRevealedStateNo];
    
    if (indexPath.row == 0) {
        InputViewController *controller = [[InputViewController alloc] init];
        //controller.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
        controller.title = (NSString *)object;
        controller.leftSidebarViewController  = sidebarViewController;
        controller.leftSelectedIndexPath      = indexPath;
        controller.label.text = [NSString stringWithFormat:@"Selected %@ from LeftSidebarViewController", (NSString *)object];
        sidebarViewController.sidebarDelegate = controller;
        [self.navigationController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
        [controller release];
    }
    else if (indexPath.row == 1){
        MyReportsViewController *controller = [[MyReportsViewController alloc] init];
        //controller.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
        controller.title = (NSString *)object;
        controller.leftSidebarViewController  = sidebarViewController;
        controller.leftSelectedIndexPath      = indexPath;
        controller.label.text = [NSString stringWithFormat:@"Selected %@ from LeftSidebarViewController", (NSString *)object];
        sidebarViewController.sidebarDelegate = controller;
        [self.navigationController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
        [controller release];
    }
    else if (indexPath.row == 2){
        FeedbackViewController *controller = [[FeedbackViewController alloc] init];
        //controller.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
        controller.title = (NSString *)object;
        controller.leftSidebarViewController  = sidebarViewController;
        controller.leftSelectedIndexPath      = indexPath;
        controller.label.text = [NSString stringWithFormat:@"Selected %@ from LeftSidebarViewController", (NSString *)object];
        sidebarViewController.sidebarDelegate = controller;
        [self.navigationController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
        [controller release];
    }
    
}

- (NSIndexPath *)lastSelectedIndexPathForSidebarViewController:(SidebarViewController *)sidebarViewController {
    return self.leftSelectedIndexPath;
}

@end
