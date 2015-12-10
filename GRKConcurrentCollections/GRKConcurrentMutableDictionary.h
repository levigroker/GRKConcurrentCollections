//
//  GRKConcurrentMutableDictionary.h
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

@interface GRKConcurrentMutableDictionary : NSObject <NSFastEnumeration>

/**
 * The number of elements in this dictionary.
 */
@property (nonatomic,readonly) NSUInteger count;

/**
 * A class-level convenience method to allocate and initialize a new instance of a GRKConcurrentMutableDictionary.
 *
 * @return A new GRKConcurrentMutableDictionary instance.
 */
+ (id)dictionary;

#pragma mark - Read Operations

- (id)objectForKey:(id)key;

/**
 * Is the receiver equal to the given dictionary.
 *
 * @param otherDictionary The dictionary to compare with.
 *
 * @return `YES` only if the caller is the same object as the given dictionary
 * or if the dictionary contents are equal at the time of this call.
 */
- (BOOL)isEqualToDictionary:(GRKConcurrentMutableDictionary *)otherDictionary;

#pragma mark - Augmentitive Operations

#pragma mark Augment

/**
 * Perform operations on the dictionary within a serial block.
 * This can be used to perform any number of serial operations on the underlying mutable
 * dictionary while no other augmentative operations are occurring. This is especially useful
 * for operations which depend on the contents of the dictionary.
 *
 * @param block The block which will be executed to allow batched serial operations to be performed on the dictionary.
 */
- (void)augmentWithBlock:(void(^)(NSMutableDictionary *dictionary))block;

#pragma mark Add

- (void)addEntriesFromDictionary:(NSDictionary *)dictionary;

#pragma mark Set

- (void)setObject:(id)obj forKey:(id<NSCopying>)key;
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key NS_AVAILABLE(10_8, 6_0);

#pragma mark Remove

- (void)removeAllObjects;
- (void)removeObjectForKey:(id)aKey;
- (void)removeObjectsForKeys:(NSArray *)keyArray;

#pragma mark Identity

- (void)setDictionary:(NSDictionary *)otherDictionary;

#pragma mark - Snapshot

/**
 * Returns a new NSDictionary object containing all the objects within this GRKConcurrentMutableDictionary.
 *
 * @return A new NSDictionary instance containing all the objects in this dictionary.
 */
- (NSDictionary *)nonConcurrentDictionary;

/**
 * Empties this dictionary into a new NSDictionary object which is not concurrent
 *
 * @return A new NSDictionary instance with the contents of this dictionary.
 */
- (NSDictionary *)drainIntoNonConcurrentDictionary;

@end
