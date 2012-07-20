//
//  ConsumptionCell.h
//  Controlled-Substances-Logbook
//
//  Created by Help Desk on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsumptionCell : UITableViewCell


@property (nonatomic, retain) IBOutlet UILabel *dateLabel, *personLabel, *amountLabel, 
                                               *procedureLabel, *destinationLabel, *resultAmountLabel;

@property (nonatomic, retain) IBOutlet UIImageView *image;

@end
