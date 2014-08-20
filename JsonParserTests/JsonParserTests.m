//
//  JsonParserTests.m
//  JsonParserTests
//
//  Created by Gustavo on 8/20/14.
//
//

#import <XCTest/XCTest.h>
#import "JsonParser.h"
#import "Entity.h"

@interface JsonParserTests : XCTestCase

@end

@implementation JsonParserTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testParseASimpleEntity{

    JsonParser *parser = [[JsonParser alloc] init];
    NSData *data = [@"{\"Name\" : \"Gustavo\", \"LastName\" : \"Hansen\", \"Age\" : \"26\"}" dataUsingEncoding:NSUTF8StringEncoding];
    
    Entity *result = [parser parseWithData:data forType:Entity.class];
    
    assert([result.Name isEqualToString: @"Gustavo"]);
    assert([result.LastName isEqualToString: @"Hansen"]);
    assert(result.Age == 26);
}

@end
