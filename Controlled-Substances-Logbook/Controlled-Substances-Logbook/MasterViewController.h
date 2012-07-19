//
//  MasterViewController.h
//  Controlled-Substances-Logbook
//
//  Created by Help Desk on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

#import <CoreData/CoreData.h>
#import "GData.h"
#import "Substance.h"
#import "Container.h"

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) NSMutableArray* substanceRetractableControllers;

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (nonatomic, retain) Substance *selectedSubstance;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) UIPopoverController *pop;

- (void) addContainerWithSubstance:(Substance*)s orNewSubstance:(NSString*)new initialVol:(double)vol name:(NSString*)name;

@end
