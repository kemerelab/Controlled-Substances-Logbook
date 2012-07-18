//
//  Substance.h
//  Controlled-Substances-Logbook
//
//  Created by Help Desk on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Substance : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *containers;
@end

@interface Substance (CoreDataGeneratedAccessors)

- (void)addContainersObject:(NSManagedObject *)value;
- (void)removeContainersObject:(NSManagedObject *)value;
- (void)addContainers:(NSSet *)values;
- (void)removeContainers:(NSSet *)values;

@end
