//
//  GRKConcurrentMutableArrayTests.m
//  
//
//  Created by Levi Brown on 5/14/15.
//
//

#import <XCTest/XCTest.h>
#import "GRKConcurrentMutableArray.h"

@interface GRKConcurrentMutableArrayTests : XCTestCase

@property (nonatomic,strong) GRKConcurrentMutableArray *array;

@end

@implementation GRKConcurrentMutableArrayTests

- (void)setUp {
    [super setUp];
    // This method is called before the invocation of each test method in the class.
    
    self.array = [GRKConcurrentMutableArray array];
}

- (void)tearDown {
    // This method is called after the invocation of each test method in the class.
    
    self.array = nil;
    
    [super tearDown];
}

- (void)testAddObject100 {
    
    NSString *input = @"zero";
    [self.array addObject:input];
    NSArray *output = [self.array nonConcurrentArray];
    XCTAssertTrue([input isEqualToString:output[0]]);
}

- (void)testAddObjectsFromArray100 {
    
    NSArray *input = @[@"zero", @"one", @"two", @"three"];
    [self.array addObjectsFromArray:input];
    NSArray *output = [self.array nonConcurrentArray];
    XCTAssertTrue([input isEqualToArray:output]);
}

- (void)testConcurrent100 {

    NSArray *input = @[@"zero", @"one", @"two", @"three", @"four"];

    dispatch_group_t group = dispatch_group_create();

    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.array addObject:input[0]];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.array addObject:input[1]];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.array addObject:input[2]];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.array addObject:input[3]];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.array addObject:input[4]];
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    //Does the array have the right number of items?
    XCTAssertTrue(self.array.count == 5);

    //Does the array have each of our items?
    for (NSInteger i = 0; i < input.count; ++i)
    {
        XCTAssertTrue([self.array containsObject:input[i]]);
    }
}

- (void)testDrainIntoNonConcurentArray100
{
    NSArray *input = @[@"zero", @"one", @"two", @"three"];
    [self.array addObjectsFromArray:input];
    NSArray *output = [self.array drainIntoNonConcurrentArray];
    XCTAssertTrue([input isEqualToArray:output]);
    XCTAssertTrue(self.array.count == 0);
}

@end
