//
//  GRKConcurrentMutableDictionaryTests.m
//  GRKConcurrentCollectionsTest
//
//  Created by Levi Brown on 5/15/15.
//  Copyright (c) 2015 Levi Brown. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GRKConcurrentMutableDictionary.h"

@interface GRKConcurrentMutableDictionaryTests : XCTestCase

@property (nonatomic,strong) GRKConcurrentMutableDictionary *dict;
@end

@implementation GRKConcurrentMutableDictionaryTests

- (void)setUp {
    [super setUp];
    //This method is called before the invocation of each test method in the class.
    
    self.dict = [GRKConcurrentMutableDictionary dictionary];
}

- (void)tearDown {
    
    self.dict = nil;
    
    //This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConcurrent100 {
    
    NSDictionary *input = @{@"zero" : @(0), @"one" : @(1), @"two" : @(2), @"three" : @(3), @"four" : @(4)};
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *key = @"zero";
        [self.dict setObject:input[key] forKey:key];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *key = @"one";
        [self.dict setObject:input[key] forKey:key];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *key = @"two";
        [self.dict setObject:input[key] forKey:key];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *key = @"three";
        [self.dict setObject:input[key] forKey:key];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *key = @"four";
        [self.dict setObject:input[key] forKey:key];
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    //Does the dict have the right number of items?
    XCTAssertTrue(self.dict.count == 5);
    
    //Does the dict have each of our items?
    
    for (id key in [input allKeys])
    {
        id value = input[key];
        XCTAssertTrue([[self.dict objectForKey:key] isEqual: value]);
    }
}

- (void)testFastEnumeration
{
    NSDictionary *input = @{@"zero" : @(0), @"one" : @(1), @"two" : @(2), @"three" : @(3), @"four" : @(4), @"five" : @(5)};
    NSDictionary *output = @{@"zero" : @(0), @"one" : @(1), @"two" : @(2), @"more" : @(3)};

    [self.dict addEntriesFromDictionary:input];

    dispatch_group_t group = dispatch_group_create();

    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (id object in self.dict) {
            // Mutate while enumerating
            XCTAssert(object);
            NSNumber *object = [NSNumber numberWithInt:3];
            NSString *key = [NSString stringWithFormat:@"more"];
            [self.dict setObject:object forKey:key];
        }
    });

    [self.dict removeObjectForKey:@"three"];
    [self.dict removeObjectForKey:@"four"];
    [self.dict removeObjectForKey:@"five"];

    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);

    XCTAssertTrue([[self.dict nonConcurrentDictionary] isEqualToDictionary:output]);
}


@end
