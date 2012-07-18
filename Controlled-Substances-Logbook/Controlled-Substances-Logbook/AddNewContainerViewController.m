//
//  AddNewContainerViewController.m
//  Controlled-Substances-Logbook
//
//  Created by Help Desk on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddNewContainerViewController.h"
#import "Substance.h"

@implementation AddNewContainerViewController

@synthesize otherField, substanceTable, substances, masterDelegate, selectedSubstance;

- (id) initWithSubstances:(NSArray*)givenSubstances{
    self = [super init];
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.contentSizeForViewInPopover = CGSizeMake(310, 400.0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.substances count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }

    Substance *s = [self.substances objectAtIndex:indexPath.row];
    
    cell.textLabel.text = s.name;
    return cell;
}


- (IBAction)createPressed
{
    [self.masterDelegate addContainerWithSubstance:self.selectedSubstance orNewSubstance:self.otherField.text];
}


@end
