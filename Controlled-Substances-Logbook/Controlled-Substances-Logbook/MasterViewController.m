//
//  MasterViewController.m
//  Controlled-Substances-Logbook
//
//  Created by Help Desk on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "MBProgressHUD.h"

#import "GCSubstanceSectionController.h"
#import "GCRetractableSectionController.h"

#import "AddNewContainerViewController.h"

@implementation MasterViewController

@synthesize substanceRetractableControllers, selectedSubstance, pop;
@synthesize detailViewController = _detailViewController;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Container Log", @"Container Log");
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        self.substanceRetractableControllers = [[NSMutableArray alloc] initWithCapacity:25];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loggedIn) name:@"LoggedIn" object:nil];
    
    NSArray *entries = [self.fetchedResultsController fetchedObjects];
    for (int i = 0; i < [entries count]; i++){
        Substance *s = [entries objectAtIndex:i];
        GCSubstanceSectionController* new = [[GCSubstanceSectionController alloc] initWithSubstance:s inViewController:self];
        new.managedObjectContext = self.managedObjectContext;
        [self.substanceRetractableControllers insertObject:new atIndex:i];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)insertNewObject:(id)sender
{
    NSLog(@"HI");
    NSMutableArray *subs = [[NSMutableArray alloc] init];
    for (GCSubstanceSectionController *con in self.substanceRetractableControllers){
        [subs addObject:con.substance];
    }
    AddNewContainerViewController* newcon = [[AddNewContainerViewController alloc] initWithSubstances:[NSArray arrayWithArray:subs]];
    newcon.masterDelegate = self;
    if (self.pop == nil) {
        self.pop = [[UIPopoverController alloc] initWithContentViewController:newcon];
    }
    else {
        self.pop.contentViewController = newcon;
    }
    if ([self.pop isPopoverVisible]) [self.pop dismissPopoverAnimated:YES];
    else [self.pop presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (void)addContainerWithSubstance:(Substance*)s orNewSubstance:(NSString*)new initialVol:(double)vol name:(NSString*)name
{
    [self.pop dismissPopoverAnimated:YES];
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
    if (s == nil) {
        NSLog(@"No substance selected...");
        // Create new substance.
        Substance *newSubstance = [NSEntityDescription insertNewObjectForEntityForName:@"Substance" inManagedObjectContext:context];
        newSubstance.name = new;
        
        Container *newContainer = [NSEntityDescription insertNewObjectForEntityForName:@"Container" inManagedObjectContext:context];
        newContainer.name = name;
        newContainer.initialVol = [NSNumber numberWithDouble:vol];
        newContainer.currentVol = [NSNumber numberWithDouble:vol];
        newContainer.substance = newSubstance;
        newContainer.lastUse = [NSDate date];
        
        [newSubstance addContainersObject:newContainer];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    } else {
        
        NSLog(@"Creating new container...");
        Container *newContainer = [NSEntityDescription insertNewObjectForEntityForName:@"Container" inManagedObjectContext:context];
        newContainer.name = name;
        newContainer.initialVol = [NSNumber numberWithDouble:vol];
        newContainer.currentVol = [NSNumber numberWithDouble:vol];
        newContainer.substance = s;
        newContainer.lastUse = [NSDate date];
        
        [s addContainersObject:newContainer];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return [[self.fetchedResultsController sections] count];
    return [self.substanceRetractableControllers count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    //return [sectionInfo numberOfObjects];
    GCSubstanceSectionController* sectionController = [self.substanceRetractableControllers objectAtIndex:section];
    return sectionController.numberOfRow;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCSubstanceSectionController* sectionController = [self.substanceRetractableControllers objectAtIndex:indexPath.section];
    UITableViewCell* ret = [sectionController cellForRow:indexPath.row];
    return ret;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCSubstanceSectionController* sectionController = [self.substanceRetractableControllers objectAtIndex:indexPath.section];
    self.selectedSubstance = sectionController.substance;
    [sectionController didSelectCellAtRow:indexPath.row];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    return;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    NSLog(@"Creating fetch request...");
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    //NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    //[fetchRequest setEntity:entity];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Substance" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    //[self.tableView beginUpdates];
    NSLog(@"I WILL CHANGESSSS");
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    NSLog(@"Change section...");
    switch(type) {
        case NSFetchedResultsChangeInsert:
            //[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            {
                NSLog(@"SECTION INSERT");
            }
            break;
            
        case NSFetchedResultsChangeDelete:
            //[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    //UITableView *tableView = self.tableView;
    NSLog(@"Change object... ");
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            {
                NSLog(@"INSERT!");
                Substance *substance = [controller objectAtIndexPath:newIndexPath];
                NSLog(@"I AM A %@", [[[controller objectAtIndexPath:newIndexPath] entity] name]);
                GCSubstanceSectionController *subcon = [[GCSubstanceSectionController alloc] initWithSubstance:substance inViewController:self];
                subcon.managedObjectContext = self.managedObjectContext;
                [self.substanceRetractableControllers insertObject:subcon atIndex:indexPath.row];
            }
            //[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            NSLog(@"DELETE...");
            break;
            
        case NSFetchedResultsChangeUpdate:
            {
              NSLog(@"UPDATE... %@", [[[controller objectAtIndexPath:newIndexPath] entity] name]);  
            }
            //[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            NSLog(@"MOVEEE...");
            //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            //[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    //[self.tableView endUpdates];
    NSLog(@"Finished...");
    [self.tableView reloadData];
    
}

@end
