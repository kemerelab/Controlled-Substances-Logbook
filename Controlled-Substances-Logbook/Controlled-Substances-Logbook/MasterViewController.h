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

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>


@property (nonatomic, retain) GDataEntrySpreadsheet* spreadsheet;
@property (nonatomic, retain) GDataEntryWorksheet* worksheet;
@property (nonatomic, retain) NSMutableArray* substances;

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
