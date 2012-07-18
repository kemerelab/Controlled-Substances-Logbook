//
//  GCSubstanceSectionController.h
//  Controlled-Substances-Logbook
//
//  Created by Help Desk on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GCRetractableSectionController.h"
#import "Substance.h"
#import <CoreData/CoreData.h>

@interface GCSubstanceSectionController : GCRetractableSectionController

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) Substance *substance;
@property (nonatomic, retain) NSArray *sortedContainers;

- (id) initWithSubstance:(Substance*)subs inViewController:(UIViewController*)viewcon;

@end
