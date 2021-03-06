//
//  Transfer.h
//  Controlled-Substances-Logbook
//
//  Created by Help Desk on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Container;

@interface Transfer : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * resultAmt;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * procedure;
@property (nonatomic, retain) NSString * person;
@property (nonatomic, retain) Container *origin;
@property (nonatomic, retain) Container *destination;

@end
