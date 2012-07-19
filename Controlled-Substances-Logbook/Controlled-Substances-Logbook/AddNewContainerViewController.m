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

@synthesize nameField, volField;
@synthesize otherField, substanceTable, substances, masterDelegate, selectedSubstance;

- (id) initWithSubstances:(NSArray*)givenSubstances{
    self = [super init];
    self.substances = givenSubstances;
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.contentSizeForViewInPopover = CGSizeMake(310, 485.0);
    self.otherField.placeholder = @"e.x. Water";
    self.nameField.placeholder = @"e.x. Container A-1";
    self.volField.placeholder = @"e.x. 100";
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedSubstance = [self.substances objectAtIndex:indexPath.row];
}


- (IBAction)createPressed
{
    [self.masterDelegate addContainerWithSubstance:self.selectedSubstance orNewSubstance:self.otherField.text initialVol:[self.volField.text doubleValue] name:self.nameField.text];
}


@end
