//
//  GCSubstanceSectionController.m
//  Controlled-Substances-Logbook
//
//  Created by Help Desk on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GCSubstanceSectionController.h"
#import "Container.h"
#import "MasterViewController.h"
#import "DetailViewController.h"

@implementation GCSubstanceSectionController

@synthesize substance, sortedContainers;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;

- (id) initWithSubstance:(Substance*)subs inViewController:(UIViewController*)viewcon
{
    if ((self = [super initWithViewController:viewcon])) {
        self.substance = subs;
        NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"lastUse" ascending:NO]];
        self.sortedContainers = [subs.containers sortedArrayUsingDescriptors:sortDescriptors];
    }
    return self;
}

- (NSArray*)sortedContainers
{
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"lastUse" ascending:NO]];
    return [self.substance.containers sortedArrayUsingDescriptors:sortDescriptors];
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
    return [@"    " stringByAppendingString:c.name];
}

- (UITableViewCell*)contentCellForRow:(NSUInteger)row
{
    //UITableViewCell* ret = [super contentCellForRow:row];
    NSString* contentCellIdentifier = [NSStringFromClass([self class]) stringByAppendingString:@"content"];
	
	UITableViewCell *ret = [self.tableView dequeueReusableCellWithIdentifier:contentCellIdentifier];
	if (ret == nil) {
    
        ret = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:contentCellIdentifier];
    }
    
    ret.accessoryType = UITableViewCellAccessoryNone;
    UIColor* aliceBlue = [UIColor colorWithRed:176.0/255 green:226.0/255 blue:255.0/255 alpha:0.5];
    ret.contentView.backgroundColor = aliceBlue;
    ret.textLabel.backgroundColor = [UIColor clearColor];
    
    Container *c = [self.sortedContainers objectAtIndex:row];
    
    ret.textLabel.text = [@"     " stringByAppendingString:c.name];
    ret.detailTextLabel.backgroundColor = [UIColor clearColor];
    ret.detailTextLabel.text = [NSString stringWithFormat:@"%4.2f mL", [c.currentVol doubleValue]];
    return ret;
}

- (void)didSelectContentCellAtRow:(NSUInteger)row {
    //[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]
                 //                 animated:YES];
    NSLog(@"clicked...");
    MasterViewController* master = (MasterViewController *)self.viewController;
    DetailViewController* detail = master.detailViewController;
    detail.container = [self.sortedContainers objectAtIndex:row];
}

- (void)dealloc {
    //self.content = nil;
    //self.title = nil;
}    

@end
