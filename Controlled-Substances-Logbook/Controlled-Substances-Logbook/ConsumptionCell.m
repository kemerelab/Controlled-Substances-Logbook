//
//  ConsumptionCell.m
//  Controlled-Substances-Logbook
//
//  Created by Help Desk on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConsumptionCell.h"

@implementation ConsumptionCell

@synthesize dateLabel, personLabel, amountLabel, procedureLabel, destinationLabel, resultAmountLabel;

@synthesize image;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
