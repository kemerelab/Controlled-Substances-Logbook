//
//  Container.h
//  Controlled-Substances-Logbook
//
//  Created by Help Desk on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Substance;

@interface Container : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSNumber * initialVol;
@property (nonatomic, retain) NSNumber * currentVol;
@property (nonatomic, retain) NSString * name;;
@property (nonatomic, retain) NSDate * expiration;
@property (nonatomic, retain) NSDate * lastUse;
@property (nonatomic, retain) Substance *substance;
@property (nonatomic, retain) NSSet *transfers;
@property (nonatomic, retain) NSSet *consumptions;
@end

@interface Container (CoreDataGeneratedAccessors)

- (void)addTransfersObject:(NSManagedObject *)value;
- (void)removeTransfersObject:(NSManagedObject *)value;
- (void)addTransfers:(NSSet *)values;
- (void)removeTransfers:(NSSet *)values;

- (void)addConsumptionsObject:(NSManagedObject *)value;
- (void)removeConsumptionsObject:(NSManagedObject *)value;
- (void)addConsumptions:(NSSet *)values;
- (void)removeConsumptions:(NSSet *)values;

@end
