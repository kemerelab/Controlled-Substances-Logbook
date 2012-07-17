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

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (nonatomic, retain) GDataServiceGoogleSpreadsheet* service;

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
