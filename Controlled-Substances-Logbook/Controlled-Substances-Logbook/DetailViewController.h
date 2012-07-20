//
//  DetailViewController.h
//  Controlled-Substances-Logbook
//
//  Created by Help Desk on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GData.h"
#import "MBProgressHUD.h"
#import "Container.h"
#import "MasterViewController.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) GDataServiceGoogleSpreadsheet* service;

@property (nonatomic, retain) MasterViewController *masterViewController;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) id detailItem;

@property (nonatomic, retain) NSArray *transactions;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (nonatomic, retain) IBOutlet UILabel *nameLabel, *initialVolLabel, *currVolLabel, *expirLabel, *volLabel;

@property (nonatomic, retain) IBOutlet UIImageView *image;

@property (nonatomic, retain) IBOutlet UIButton *transfer, *consume, *takePicture;

@property (nonatomic, retain) IBOutlet UIStepper *stepper;

@property (nonatomic, retain) Container* container;

@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (IBAction)buttonPressed:(id)sender;

@end
