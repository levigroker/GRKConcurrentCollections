//
//  GRKConcurrentMutableArray.h
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

#import <Foundation/Foundation.h>

@interface GRKConcurrentMutableArray : NSObject <NSFastEnumeration>

/**
 * The number of elements in this array.
 */
@property (nonatomic,readonly) NSUInteger count;

/**
 * A class-level convenience method to allocate and initialize a new instance of a GRKConcurrentMutableArray.
 *
 * @return A new GRKConcurrentMutableArray instance.
 */
+ (id)array;

#pragma mark - Read Operations

- (BOOL)containsObject:(id)anObject;

/**
 * Is the receiver equal to the given array.
 *
 * @param otherArray The array to compare with.
 *
 * @return `YES` only if the caller is the same object as the given array
 * or if the array contents are equal at the time of this call.
 */
- (BOOL)isEqualToArray:(GRKConcurrentMutableArray *)otherArray;

#pragma mark - Augmentitive Operations

#pragma mark Augment

/**
 * Perform operations on the array within a serial block.
 * This can be used to perform any number of serial operations on the underlying mutable
 * array while no other augmentative operations are occurring. This is especially useful
 * for operations which depend on the index of array elements.
 *
 * @param block The block which will be executed to allow batched serial operations to be performed on the array.
 */
- (void)augmentWithBlock:(void(^)(NSMutableArray *array))block;

#pragma mark Add

- (void)addObject:(id)anObject;
- (void)addObjectsFromArray:(NSArray *)otherArray;

#pragma mark Remove

- (void)removeObject:(id)anObject;
- (void)removeAllObjects;
- (void)removeObjectIdenticalTo:(id)anObject;
- (void)removeObjectsInArray:(NSArray *)otherArray;

#pragma mark Identity

- (void)setArray:(NSArray *)otherArray;

#pragma mark Sort

- (void)sortUsingFunction:(NSInteger (*)(id, id, void *))compare context:(void *)context;
- (void)sortUsingSelector:(SEL)comparator;
- (void)sortUsingComparator:(NSComparator)cmptr NS_AVAILABLE(10_6, 4_0);
- (void)sortWithOptions:(NSSortOptions)opts usingComparator:(NSComparator)cmptr NS_AVAILABLE(10_6, 4_0);

#pragma mark Filter

- (void)filterUsingPredicate:(NSPredicate *)predicate;

#pragma mark - Snapshot

/**
 * Returns a new NSArray object containing all the objects within this GRKConcurrentMutableArray.
 *
 * @return A new NSArray instance containing all the objects in this array.
 */
- (NSArray *)nonConcurrentArray;

/**
 * Empties this array into a new NSArray object which is not concurrent
 *
 * @return A new NSArray instance with the contents of this array.
 */
- (NSArray *)drainIntoNonConcurrentArray;

@end
