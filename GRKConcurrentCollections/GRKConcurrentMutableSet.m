//
//  GRKConcurrentMutableSet.m
//
//  See: http://www.mikeash.com/pyblog/friday-qa-2011-10-14-whats-new-in-gcd.html
//
//  Created by Levi Brown on December 14, 2012.
//  Copyright (c) 2012-2015 Levi Brown <mailto:levigroker@gmail.com>
//  This work is licensed under the Creative Commons Attribution 3.0
//  Unported License. To view a copy of this license, visit
//  http://creativecommons.org/licenses/by/3.0/ or send a letter to Creative
//  Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041,
//  USA.
//
//  The above attribution and the included license must accompany any version
//  of the source code. Visible attribution in any binary distributable
//  including this work (or derivatives) is not required, but would be
//  appreciated.
//

#import "GRKConcurrentMutableSet.h"

@interface GRKConcurrentMutableSet ()

@property (nonatomic,strong) NSMutableSet *encapsulatedSet;
@property (nonatomic,strong) dispatch_queue_t access_queue;

@end

@implementation GRKConcurrentMutableSet

#pragma mark - Lifecycle

- (id)init
{
    if ((self = [super init]))
    {
        self.encapsulatedSet = [NSMutableSet set];
        self.access_queue = dispatch_queue_create([[NSString stringWithFormat:@"<%@: %p>", NSStringFromClass([self class]), self] cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_CONCURRENT);
    }
    
    return self;
}

#pragma mark - Class Level

+ (id)set
{
    id retVal = [[self alloc] init];
    return retVal;
}

#pragma mark - Read Operations

- (NSUInteger)count
{
    __block NSUInteger retVal;
    dispatch_sync(self.access_queue, ^{
        retVal = self.encapsulatedSet.count;
    });
    return retVal;
}

- (id)member:(id)obj
{
    __block id retVal;
    dispatch_sync(self.access_queue, ^{
        retVal = [self.encapsulatedSet member:obj];
    });
    return retVal;
}

- (NSArray *)allObjects
{
    __block NSArray *retVal;
    dispatch_sync(self.access_queue, ^{
        retVal = [self.encapsulatedSet allObjects];
    });
    return retVal;
}

- (id)anyObject
{
    __block id retVal;
    dispatch_sync(self.access_queue, ^{
        retVal = [self.encapsulatedSet anyObject];
    });
    return retVal;
}

- (BOOL)containsObject:(id)anObject
{
    __block BOOL retVal;
    dispatch_sync(self.access_queue, ^{
        retVal = [self.encapsulatedSet containsObject:anObject];
    });
    return retVal;
}

- (BOOL)isEqualToSet:(GRKConcurrentMutableSet *)otherSet
{
    BOOL retVal = [self isEqual:otherSet];
    if (!retVal)
    {
        NSSet *us = [self nonConcurrentSet];
        NSSet *them = [otherSet nonConcurrentSet];
        retVal = [us isEqualToSet:them];
    }
    
    return retVal;
}

#pragma mark - Augmentitive Operations

#pragma mark Augment

- (void)augmentWithBlock:(void(^)(NSMutableSet *set))block
{
    dispatch_barrier_async(self.access_queue, ^{
        if (block)
        {
            block(self.encapsulatedSet);
        }
    });
}

#pragma mark Add

- (void)addObject:(id)obj
{
    dispatch_barrier_async(self.access_queue, ^{
        [self.encapsulatedSet addObject:obj];
    });
}

- (void)addObjectsFromArray:(NSArray *)array
{
    dispatch_barrier_async(self.access_queue, ^{
        [self.encapsulatedSet addObjectsFromArray:array];
    });
}

#pragma mark Remove

- (void)removeAllObjects
{
    dispatch_barrier_async(self.access_queue, ^{
        [self.encapsulatedSet removeAllObjects];
    });
}

- (void)removeObject:(id)object
{
    dispatch_barrier_async(self.access_queue, ^{
        [self.encapsulatedSet removeObject:object];
    });
}

#pragma mark Set Operations

- (void)unionSet:(NSSet *)otherSet;
{
    dispatch_barrier_async(self.access_queue, ^{
        [self.encapsulatedSet unionSet:otherSet];
    });
}

- (void)minusSet:(NSSet *)set
{
    dispatch_barrier_async(self.access_queue, ^{
        [self.encapsulatedSet minusSet:set];
    });
}

- (void)intersectSet:(NSSet *)otherSet
{
    dispatch_barrier_async(self.access_queue, ^{
        [self.encapsulatedSet intersectSet:otherSet];
    });
}

#pragma mark Identity

- (void)setSet:(NSSet *)otherSet
{
    dispatch_barrier_async(self.access_queue, ^{
        [self.encapsulatedSet setSet:otherSet];
    });
}

#pragma mark Filter

- (void)filterUsingPredicate:(NSPredicate *)predicate
{
    dispatch_barrier_async(self.access_queue, ^{
        [self.encapsulatedSet filterUsingPredicate:predicate];
    });
}

#pragma mark - Snapshot

- (NSSet *)nonConcurrentSet
{
    __block NSSet *retVal;
    dispatch_sync(self.access_queue, ^{
        retVal = [NSSet setWithSet:self.encapsulatedSet];
    });
    return retVal;
}

#pragma mark - Overrides

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, count: %d encapsulatedSet: %@ >", NSStringFromClass([self class]), self, (int)self.count, self.encapsulatedSet];
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id __unsafe_unretained [])buffer
                                    count:(NSUInteger)len;{
    __block NSUInteger retVal;
    dispatch_sync(self.access_queue, ^{
        retVal = [[self.encapsulatedSet copy] countByEnumeratingWithState:state objects:buffer count:len];
    });
    return retVal;
}
@end
