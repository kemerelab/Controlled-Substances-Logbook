//
//  GCSubstanceSectionController.m
//  Controlled-Substances-Logbook
//
//  Created by Help Desk on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GCSubstanceSectionController.h"
#import "Container.h"

@implementation GCSubstanceSectionController

@synthesize substance, sortedContainers;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;

- (id) initWithSubstance:(Substance*)subs inViewController:(UIViewController*)viewcon
{
    if ((self = [super initWithViewController:viewcon])) {
        self.substance = subs;
        NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
        self.sortedContainers = [subs.containers sortedArrayUsingDescriptors:sortDescriptors];
    }
    return self;
}

- (NSString *)title {
    return self.substance.name;
}

- (NSUInteger)contentNumberOfRow {
    //return [self.content count];
    return [self.substance.containers count];
}

- (NSString *)titleContentForRow:(NSUInteger)row {
    //eturn [self.content objectAtIndex:row];    
    Container *c = [self.sortedContainers objectAtIndex:row];
    return c.name;
}

- (void)didSelectContentCellAtRow:(NSUInteger)row {
    //[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]
                 //                 animated:YES];
}

- (void)dealloc {
    //self.content = nil;
    //self.title = nil;
}    

@end
