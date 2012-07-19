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

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) GDataServiceGoogleSpreadsheet* service;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (nonatomic, retain) IBOutlet UILabel *nameLabel, *initVolLabel, *currVolLabel, *expirLabel, *volLabel;

@property (nonatomic, retain) IBOutlet UIImageView *image;

@property (nonatomic, retain) IBOutlet UIButton *transfer, *consume, *takePicture;

@property (nonatomic, retain) IBOutlet UIStepper *stepper;

@property (nonatomic, retain) Container* container;

- (IBAction)buttonPressed:(id)sender;

@end
