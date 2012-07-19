//
//  DetailViewController.m
//  Controlled-Substances-Logbook
//
//  Created by Help Desk on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "MBProgressHUD.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize managedObjectContext;
@synthesize transfer, consume, takePicture;
@synthesize nameLabel, currVolLabel, initVolLabel, expirLabel, volLabel;
@synthesize image, stepper;
@synthesize container;
@synthesize service;
@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize masterPopoverController = _masterPopoverController;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"timeStamp"] description];
    }
    /*
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStylePlain target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;*/
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    // add setting button to nav bar
    UIImage* settingsGearImg = [UIImage imageNamed:@"gear.png"];
    CGRect frameimg = CGRectMake(0, 0, settingsGearImg.size.width, settingsGearImg.size.height);
    UIButton *settingsButton = [[UIButton alloc] initWithFrame:frameimg];
    [settingsButton setBackgroundImage:settingsGearImg forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(settingsButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [settingsButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *settingButtonItem =[[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    self.navigationItem.rightBarButtonItem = settingButtonItem;
}

-(void) settingsButtonAction
{
    NSLog(@"hello...");
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Enter your login information below." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.service == nil){
        
        NSString* username = [[alertView textFieldAtIndex:0] text];
        NSString* password = [[alertView textFieldAtIndex:1] text];
        
        self.service = [[GDataServiceGoogleSpreadsheet alloc] init];
        [self.service setShouldCacheResponseData:YES];
        [self.service setUserCredentialsWithUsername:username password:password];
        
        MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Logging in...";
        [self.service authenticateWithDelegate:self didAuthenticateSelector:@selector(ticket:authenticatedWithError:)];
        
    }
}
                                                                                    
- (void)ticket:(GDataServiceTicket *)ticket
authenticatedWithError:(NSError *)error {
    if (error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:@"Incorrect username or password." 
                                                       delegate:nil 
                                              cancelButtonTitle:@"Try Again" 
                                              otherButtonTitles:nil];
        [alert show];
        self.service = nil;
    } else {
        NSLog(@"[DetailView] Successfully logged in.");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoggedIn" object:self];
    }
}                                                                                      

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.detailDescriptionLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Details", @"Details");
    }
    return self;
}

- (void) setContainer:(Container *)givenContainer
{
    NSLog(@"Setting...");
    self.nameLabel.text = givenContainer.name;
    
    container = givenContainer;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}

-(IBAction)buttonPressed:(id)sender{
    
}
							
#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Log", @"Log");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
