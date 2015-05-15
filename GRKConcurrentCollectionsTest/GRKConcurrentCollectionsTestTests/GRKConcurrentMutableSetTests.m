//
//  GRKConcurrentMutableSetTests.m
//  GRKConcurrentCollectionsTest
//
//  Created by Levi Brown on 5/15/15.
//  Copyright (c) 2015 Levi Brown. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GRKConcurrentMutableSet.h"

@interface GRKConcurrentMutableSetTests : XCTestCase

@property (nonatomic,strong) GRKConcurrentMutableSet *set;

@end

@implementation GRKConcurrentMutableSetTests

- (void)setUp {
    [super setUp];
    //This method is called before the invocation of each test method in the class.
    
    self.set = [GRKConcurrentMutableSet set];
}

- (void)tearDown {
    
    self.set = nil;
    
    //This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConcurrent100 {
    
    NSArray *input = @[@"zero", @"one", @"two", @"three", @"four"];

    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.set addObject:input[0]];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.set addObject:input[1]];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.set addObject:input[2]];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.set addObject:input[3]];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.set addObject:input[4]];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.set addObject:input[0]];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.set addObject:input[1]];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.set addObject:input[2]];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.set addObject:input[3]];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.set addObject:input[4]];
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    //Does the set have the right number of items?
    XCTAssertTrue(self.set.count == 5);
    
    //Does the set have each of our items?
    for (NSInteger i = 0; i < input.count; ++i)
    {
        XCTAssertTrue([self.set containsObject:input[i]]);
    }
}

@end
