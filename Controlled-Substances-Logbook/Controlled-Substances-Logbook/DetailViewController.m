//
//  DetailViewController.m
//  Controlled-Substances-Logbook
//
//  Created by Help Desk on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "MBProgressHUD.h"
#import "Consumption.h"
#import "Transfer.h"
#import "ConsumptionCell.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize tableView, masterViewController;
@synthesize managedObjectContext, transactions;
@synthesize transfer, consume, takePicture;
@synthesize nameLabel, currVolLabel, initialVolLabel, expirLabel, volLabel;
@synthesize image, stepper, segcontrol;
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
    self.initialVolLabel.text = [NSString stringWithFormat:@"%4.2f mL", [givenContainer.initialVol doubleValue]];
    self.currVolLabel.text = [NSString stringWithFormat:@"%4.2f mL", [givenContainer.currentVol doubleValue]];
    
    container = givenContainer;
    self.volLabel.text = @"0 mL";
    
    if (self.transactions) ;
    
    
    [self.tableView reloadData];
}

- (NSArray*)transactions
{
    
    NSLog(@"getting transactions...");
    NSLog(@"consumptions - %@ : transfers - %@", self.container.consumptions, self.container.transfers);
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    NSSet *trans = [self.container.consumptions setByAddingObjectsFromSet:self.container.transfers];
    
    transactions = [trans sortedArrayUsingDescriptors:sortDescriptors];

    NSLog(@"%@", transactions);

    return transactions;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.transactions.count;
}

- (UITableViewCell *)tableView:(UITableView *)givenTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [givenTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ConsumptionCell" owner:self options:NULL];
        cell = (ConsumptionCell*)[nib objectAtIndex:0];
    }
    
    NSManagedObject *obj = [self.transactions objectAtIndex:indexPath.row];
    
    if ([[[obj entity]name] isEqualToString:@"Consumption"]){
        Consumption *cons = (Consumption *)obj;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"M/d/yy 'at' H:mm"];
        ((ConsumptionCell*)cell).dateLabel.text = [formatter stringFromDate:cons.date];
        ((ConsumptionCell*)cell).personLabel.text = @"Person";
        [((ConsumptionCell*)cell).image setImage:[UIImage imageNamed:@"consumption.png"]];
        ((ConsumptionCell*)cell).amountLabel.text = [[cons.volume stringValue] stringByAppendingString:@" mL"];
        ((ConsumptionCell*)cell).resultAmountLabel.text = [[cons.resultAmt stringValue] stringByAppendingString:@" mL"];
        
    }
    
    if ([[[obj entity]name] isEqualToString:@"Transfer"]){
        Transfer *trans = (Transfer *)obj;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"M/d/yy 'at' H:mm"];
        ((ConsumptionCell*)cell).dateLabel.text = [formatter stringFromDate:trans.date];
        ((ConsumptionCell*)cell).personLabel.text = trans.person;
        ((ConsumptionCell*)cell).procedureLabel.text = trans.procedure;
        ((ConsumptionCell*)cell).destinationLabel.text = @"";
        [((ConsumptionCell*)cell).image setImage:[UIImage imageNamed:@"transfer.png"]];
        ((ConsumptionCell*)cell).amountLabel.text = [[trans.amount stringValue] stringByAppendingString:@" mL"];
        ((ConsumptionCell*)cell).resultAmountLabel.text = [[trans.resultAmt stringValue] stringByAppendingString:@" mL"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}

-(IBAction)buttonPressed:(id)sender{
    
    if (sender == self.stepper){
        NSLog(@"HELLLO!");
        double oldValue = [[self.volLabel.text stringByReplacingOccurrencesOfString:@" mL" withString:@""] doubleValue];
        self.volLabel.text = [NSString stringWithFormat:@"%3.2f mL", oldValue + [[self.segcontrol titleForSegmentAtIndex:self.segcontrol.selectedSegmentIndex] doubleValue]];
    }
    
    if (sender == self.segcontrol){
        NSLog(@"HOLA %@", [self.segcontrol titleForSegmentAtIndex:self.segcontrol.selectedSegmentIndex]);
    }
    
    if (sender == self.transfer){
        if (self.container == nil) return;
        
        NSLog(@"Creating new transfer...");
        
        NSManagedObjectContext *context = self.managedObjectContext;
        
        // Going to default new container name for now
        
        Container* newContainer = [self.masterViewController addContainerWithSubstance:self.container.substance orNewSubstance:nil initialVol:self.stepper.value name:@"Transfer Container"];
        
        Transfer *newTransfer = [NSEntityDescription insertNewObjectForEntityForName:@"Transfer" inManagedObjectContext:context];
        
        newTransfer.date = [NSDate date];
        double newAmt = [[self.volLabel.text stringByReplacingOccurrencesOfString:@" mL" withString:@""] doubleValue];
        newTransfer.amount = [NSNumber numberWithDouble:newAmt];
        newTransfer.person = @"Transfer Student"; // lol i'm so funny
        newTransfer.procedure = @"Transfer Procedure";
        newTransfer.resultAmt = [NSNumber numberWithDouble:[self.container.currentVol doubleValue] - newAmt];
        newTransfer.origin =  self.container;
        newTransfer.destination = newContainer;
        
        [self.container addTransfersObject:newTransfer];
        self.container.currentVol = [NSNumber numberWithDouble:[self.container.currentVol doubleValue] - newAmt];

        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        NSLog(@"reloading table...");
        
        self.currVolLabel.text = [NSString stringWithFormat:@"%4.2f mL", [self.container.currentVol doubleValue]];
        
        [self.tableView reloadData];
    }
    
    if (sender == self.consume){
        if (self.container == nil) return;
        
        NSLog(@"Creating new consumption...");
        
        NSManagedObjectContext *context = self.managedObjectContext;
        
        Consumption *newConsumption = [NSEntityDescription insertNewObjectForEntityForName:@"Consumption" inManagedObjectContext:context];
        
        newConsumption.date = [NSDate date];
        double newAmt = [[self.volLabel.text stringByReplacingOccurrencesOfString:@" mL" withString:@""] doubleValue];
        newConsumption.volume = [NSNumber numberWithDouble:newAmt];
        newConsumption.container = self.container;
        newConsumption.resultAmt = [NSNumber numberWithDouble:[self.container.currentVol doubleValue] - newAmt];
        
        [self.container addConsumptionsObject:newConsumption];
        self.container.currentVol = [NSNumber numberWithDouble:[self.container.currentVol doubleValue] - newAmt];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        NSLog(@"reloading table...");
        
        self.currVolLabel.text = [NSString stringWithFormat:@"%4.2f mL", [self.container.currentVol doubleValue]];
        
        [self.tableView reloadData];
    }
    
    /*if (sender == self.takePicture){
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self presentModalViewController:imagePicker animated:YES];
    }*/
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * newImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [image setImage:newImage];
    
    // You have the image. You can use this to present the image in the next view like you require in `#3`.
    [self dismissModalViewControllerAnimated:YES];
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
