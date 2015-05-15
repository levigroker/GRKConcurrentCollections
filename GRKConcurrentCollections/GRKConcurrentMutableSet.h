//
//  GRKConcurrentMutableSet.h
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

#import <Foundation/Foundation.h>

@interface GRKConcurrentMutableSet : NSObject

/**
 * The number of elements in this set.
 */
@property (nonatomic,readonly) NSUInteger count;

/**
 * A class-level convenience method to allocate and initialize a new instance of a GRKConcurrentMutableSet.
 *
 * @return A new GRKConcurrentMutableSet instance.
 */
+ (id)set;

#pragma mark - Read Operations

- (id)member:(id)obj;
- (NSArray *)allObjects;
- (id)anyObject;
- (BOOL)containsObject:(id)anObject;

/**
 * Is the receiver equal to the given set.
 *
 * @param otherSet The set to compare with.
 *
 * @return `YES` only if the caller is the same object as the given set
 * or if the set contents are equal at the time of this call.
 */
- (BOOL)isEqualToSet:(GRKConcurrentMutableSet *)otherSet;

#pragma mark - Augmentitive Operations

#pragma mark Augment

/**
 * Perform operations on the set within a serial block.
 * This can be used to perform any number of serial operations on the underlying mutable
 * set while no other augmentative operations are occurring. This is especially useful
 * for operations which depend on the contents of the set.
 *
 * @param block The block which will be executed to allow batched serial operations to be performed on the set.
 */
- (void)augmentWithBlock:(void(^)(NSMutableSet *set))block;

#pragma mark Add

- (void)addObject:(id)obj;
- (void)addObjectsFromArray:(NSArray *)array;

#pragma mark Remove

- (void)removeAllObjects;
- (void)removeObject:(id)object;

#pragma mark Set Operations

- (void)unionSet:(NSSet *)otherSet;
- (void)minusSet:(NSSet *)set;
- (void)intersectSet:(NSSet *)otherSet;

#pragma mark Identity

- (void)setSet:(NSSet *)otherSet;

#pragma mark Filter

- (void)filterUsingPredicate:(NSPredicate *)predicate;

#pragma mark - Snapshot

/**
 * Returns a new NSSet object containing all the objects within this GRKConcurrentMutableSet
 *
 * @return A new NSSet object containing all the objects within this GRKConcurrentMutableSet
 */
- (NSSet *)nonConcurrentSet;

@end
