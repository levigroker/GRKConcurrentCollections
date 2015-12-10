//
//  GRKConcurrentMutableDictionary.m
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

#import "GRKConcurrentMutableDictionary.h"

@interface GRKConcurrentMutableDictionary ()

@property (nonatomic,strong) NSMutableDictionary *encapsulatedDict;
@property (nonatomic,strong) dispatch_queue_t access_queue;

@end

@implementation GRKConcurrentMutableDictionary

#pragma mark - Lifecycle

- (id)init
{
    if ((self = [super init]))
    {
        self.encapsulatedDict = [NSMutableDictionary dictionary];
        self.access_queue = dispatch_queue_create([[NSString stringWithFormat:@"<%@: %p>", NSStringFromClass([self class]), self] cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_CONCURRENT);
    }
    
    return self;
}

#pragma mark - Class Level

+ (id)dictionary
{
    id retVal = [[self alloc] init];
    return retVal;
}

#pragma mark - Read Operations

- (NSUInteger)count
{
    __block NSUInteger retVal;
    dispatch_sync(self.access_queue, ^{
        retVal = self.encapsulatedDict.count;
    });
    return retVal;
}

- (id)objectForKey:(id)key
{
    __block id obj;
    dispatch_sync(self.access_queue, ^{
        obj = [self.encapsulatedDict objectForKey:key];
    });
    return obj;
}

- (BOOL)isEqualToDictionary:(GRKConcurrentMutableDictionary *)otherDictionary
{
    BOOL retVal = [self isEqual:otherDictionary];
    if (!retVal)
    {
        NSDictionary *us = [self nonConcurrentDictionary];
        NSDictionary *them = [otherDictionary nonConcurrentDictionary];
        retVal = [us isEqualToDictionary:them];
    }
    
    return retVal;
}

#pragma mark - Augmentitive Operations

#pragma mark Augment

- (void)augmentWithBlock:(void(^)(NSMutableDictionary *dictionary))block
{
    dispatch_barrier_async(self.access_queue, ^{
        if (block)
        {
            block(self.encapsulatedDict);
        }
    });
}

#pragma mark Add

- (void)addEntriesFromDictionary:(NSDictionary *)dictionary
{
    dispatch_barrier_async(self.access_queue, ^{
        [self.encapsulatedDict addEntriesFromDictionary:dictionary];
    });
}

#pragma mark Set

- (void)setObject:(id)obj forKey:(id<NSCopying>)key
{
    dispatch_barrier_async(self.access_queue, ^{
        [self.encapsulatedDict setObject:obj forKey:key];
    });
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key NS_AVAILABLE(10_8, 6_0)
{
    dispatch_barrier_async(self.access_queue, ^{
        [self.encapsulatedDict setObject:obj forKeyedSubscript:key];
    });
}

#pragma mark Remove

- (void)removeAllObjects
{
    dispatch_barrier_async(self.access_queue, ^{
        [self.encapsulatedDict removeAllObjects];
    });
}

- (void)removeObjectForKey:(id)aKey
{
    dispatch_barrier_async(self.access_queue, ^{
        [self.encapsulatedDict removeObjectForKey:aKey];
    });
}

- (void)removeObjectsForKeys:(NSArray *)keyArray
{
    dispatch_barrier_async(self.access_queue, ^{
        [self.encapsulatedDict removeObjectsForKeys:keyArray];
    });
}

#pragma mark Identity

- (void)setDictionary:(NSDictionary *)otherDictionary
{
    dispatch_barrier_async(self.access_queue, ^{
        [self.encapsulatedDict setDictionary:otherDictionary];
    });
}

#pragma mark - Snapshot

- (NSDictionary *)nonConcurrentDictionary
{
    __block NSDictionary *retVal;
    dispatch_sync(self.access_queue, ^{
        retVal = [NSDictionary dictionaryWithDictionary:self.encapsulatedDict];
    });
    return retVal;
}

- (NSDictionary *)drainIntoNonConcurrentDictionary
{
    __block NSDictionary *retVal;
    dispatch_barrier_sync(self.access_queue, ^{
        retVal = [NSDictionary dictionaryWithDictionary:self.encapsulatedDict];
        [self.encapsulatedDict removeAllObjects];
    });
    
    return retVal;
}

#pragma mark - Overrides

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, count: %d encapsulatedDict: %@ >", NSStringFromClass([self class]), self, (int)self.count, self.encapsulatedDict];
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id __unsafe_unretained [])buffer
                                    count:(NSUInteger)len;{
    __block NSUInteger retVal;
    dispatch_sync(self.access_queue, ^{
        retVal = [[self.encapsulatedDict copy] countByEnumeratingWithState:state objects:buffer count:len];
    });
    return retVal;
}

@end
