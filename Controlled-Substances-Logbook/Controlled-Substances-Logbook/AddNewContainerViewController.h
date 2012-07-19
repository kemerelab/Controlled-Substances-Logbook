//
//  AddNewContainerViewController.h
//  Controlled-Substances-Logbook
//
//  Created by Help Desk on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"
#import "Substance.h"

@interface AddNewContainerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITextField *otherField;

@property (nonatomic, retain) IBOutlet UITextField *volField;

@property (nonatomic, retain) IBOutlet UITextField *nameField;

@property (nonatomic, retain) IBOutlet UITableView *substanceTable;

@property (nonatomic, retain) NSArray *substances;

@property (nonatomic, retain) Substance *selectedSubstance;

@property (nonatomic, retain) MasterViewController* masterDelegate;

- (id) initWithSubstances:(NSArray*)givenSubstances;

- (IBAction)createPressed;

@end
