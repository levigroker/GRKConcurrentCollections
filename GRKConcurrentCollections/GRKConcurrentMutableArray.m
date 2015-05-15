//
//  GRKConcurrentMutableArray.m
//
//  See: http://www.mikeash.com/pyblog/friday-qa-2011-10-14-whats-new-in-gcd.html
//
//  Created by Levi Brown on January 16, 2013.
//  Copyright (c) 2013-2015 Levi Brown <mailto:levigroker@gmail.com>
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

#import "GRKConcurrentMutableArray.h"

@interface GRKConcurrentMutableArray ()

@property (nonatomic,strong) NSMutableArray *encapsulatedArray;
@property (nonatomic,strong) dispatch_queue_t access_queue;

@end

@implementation GRKConcurrentMutableArray

#pragma mark - Lifecycle

- (id)init
{
    if ((self = [super init]))
    {
        self.encapsulatedArray = [NSMutableArray array];
        self.access_queue = dispatch_queue_create([[NSString stringWithFormat:@"<%@: %p>", NSStringFromClass([self class]), self] cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_CONCURRENT);
    }
    
    return self;
}

#pragma mark - Class Level

+ (id)array
{
    id retVal = [[self alloc] init];
    return retVal;
}

#pragma mark - Read Operations

- (NSUInteger)count
{
    __block NSUInteger retVal;
    dispatch_sync(self.access_queue, ^{
        retVal = self.encapsulatedArray.count;
    });
    return retVal;
}

- (BOOL)containsObject:(id)anObject
{
    __block BOOL retVal;
    dispatch_sync(self.access_queue, ^{
        retVal = [self.encapsulatedArray containsObject:anObject];
    });
    return retVal;
}

- (BOOL)isEqualToArray:(GRKConcurrentMutableArray *)otherArray
{
    BOOL retVal = [self isEqualTo:otherArray];
    if (!retVal)
    {
        NSArray *us = [self nonConcurrentArray];
        NSArray *them = [otherArray nonConcurrentArray];
        retVal = [us isEqualToArray:them];
    }
    
    return retVal;
}

#pragma mark - Augmentitive Operations

#pragma mark Augment

- (void)augmentWithBlock:(void(^)(NSMutableArray *array))block
{
    dispatch_barrier_async(self.access_queue, ^{
        if (block)
        {
            block(self.encapsulatedArray);
        }
    });
}

#pragma mark Add

- (void)addObject:(id)anObject
{
    dispatch_barrier_async(self.access_queue, ^{
        [self.encapsulatedArray addObject:anObject];
    });
}

- (void)addObjectsFromArray:(NSArray *)otherArray;
{
    dispatch_barrier_async(self.access_queue, ^{
        [self.encapsulatedArray addObjectsFromArray:otherArray];
    });
}

#pragma mark Remove

- (void)removeObject:(id)anObject
{
    dispatch_barrier_async(self.access_queue, ^{
        [self.encapsulatedArray removeObject:anObject];
    });
}

- (void)removeAllObjects
{
    dispatch_barrier_async(self.access_queue, ^{
        [self.encapsulatedArray removeAllObjects];
    });
}

- (void)removeObjectIdenticalTo:(id)anObject
{
    dispatch_barrier_async(self.access_queue, ^{
        [self.encapsulatedArray removeObjectIdenticalTo:anObject];
    });
}

- (void)removeObjectsInArray:(NSArray *)otherArray
{
    dispatch_barrier_async(self.access_queue, ^{
        [self.encapsulatedArray removeObjectsInArray:otherArray];
    });
}

#pragma mark Identity

- (void)setArray:(NSArray *)otherArray
{
    dispatch_barrier_async(self.access_queue, ^{
        [self.encapsulatedArray setArray:otherArray];
    });
}

#pragma mark Sort

- (void)sortUsingFunction:(NSInteger (*)(id, id, void *))compare context:(void *)context
{
    dispatch_barrier_async(self.access_queue, ^{
        [self.encapsulatedArray sortUsingFunction:compare context:context];
    });
}

- (void)sortUsingSelector:(SEL)comparator
{
    dispatch_barrier_async(self.access_queue, ^{
        [self.encapsulatedArray sortUsingSelector:comparator];
    });
}

- (void)sortUsingComparator:(NSComparator)cmptr NS_AVAILABLE(10_6, 4_0)
{
    dispatch_barrier_async(self.access_queue, ^{
        [self.encapsulatedArray sortUsingComparator:cmptr];
    });
}

- (void)sortWithOptions:(NSSortOptions)opts usingComparator:(NSComparator)cmptr NS_AVAILABLE(10_6, 4_0)
{
    dispatch_barrier_async(self.access_queue, ^{
        [self.encapsulatedArray sortWithOptions:opts usingComparator:cmptr];
    });
}

#pragma mark Filter

- (void)filterUsingPredicate:(NSPredicate *)predicate
{
    dispatch_barrier_async(self.access_queue, ^{
        [self.encapsulatedArray filterUsingPredicate:predicate];
    });
}

#pragma mark - Snapshot

- (NSArray *)nonConcurrentArray
{
    __block NSArray *retVal;
    dispatch_sync(self.access_queue, ^{
        retVal = [NSArray arrayWithArray:self.encapsulatedArray];
    });
    return retVal;
}

- (NSArray *)drainIntoNonConcurrentArray
{
    __block NSArray *retVal;
    dispatch_barrier_sync(self.access_queue, ^{
        retVal = [NSArray arrayWithArray:self.encapsulatedArray];
        [self.encapsulatedArray removeAllObjects];
    });
    
    return retVal;
}

#pragma mark - Overrides

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, count: %d encapsulatedArray: %@ >", NSStringFromClass([self class]), self, (int)self.count, self.encapsulatedArray];
}

@end
