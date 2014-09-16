//
//  JsonParserTests.m
//  JsonParserTests
//
//  Created by Gustavo on 8/20/14.
//
//

#import "EntityWithComplexType.h"
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
    NSData *data = [@"{\"Name\" : \"Gustavo\", \"LastName\" : \"Hansen\", \"Age\" : \"26\", \"LastLogIn\" : \"2014-05-20T17:07:16Z\"} " dataUsingEncoding:NSUTF8StringEncoding];
    
    Entity *result = [parser parseWithData:data forType:Entity.class selector:nil];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssz"];
    NSDate *date = [dateFormatter dateFromString:@"2014-05-20T17:07:16Z"];
    
    assert([result.Name isEqualToString: @"Gustavo"]);
    assert([result.LastName isEqualToString: @"Hansen"]);
    assert(result.Age == 26);
    assert([result.LastLogIn isEqualToDate:date]);
}

-(void)testParseCollectionsEntity{
    
    JsonParser *parser = [[JsonParser alloc] init];
    NSData *data = [@"{\"Peoples\":[{\"Name\" : \"Gustavo\", \"LastName\" : \"Hansen\", \"Age\" : \"26\", \"LastLogIn\" : \"2014-05-20T17:07:16Z\"}, {\"Name\" : \"Homer\", \"LastName\" : \"Simpson\", \"Age\" : \"36\", \"LastLogIn\" : \"2014-05-20T17:07:16Z\"}]}" dataUsingEncoding:NSUTF8StringEncoding];
    
    EntityWithComplexType *result = [parser parseWithData:data forType:EntityWithComplexType.class selector:nil];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssz"];
    NSDate *date = [dateFormatter dateFromString:@"2014-05-20T17:07:16Z"];
    
    assert(result.Peoples.count == 2);
    
    Entity* people = [result.Peoples objectAtIndex:0];
    assert([people.Name isEqualToString: @"Gustavo"]);
    assert([people.LastName isEqualToString: @"Hansen"]);
    assert(people.Age == 26);
    assert([people.LastLogIn isEqualToDate:date]);
    
    people = [result.Peoples objectAtIndex:1];
    assert([people.Name isEqualToString: @"Homer"]);
    assert([people.LastName isEqualToString: @"Simpson"]);
    assert(people.Age == 36);
    assert([people.LastLogIn isEqualToDate:date]);
}

-(void)testToJsonString{
    JsonParser *parser = [[JsonParser alloc] init];
    Entity *people = [[Entity alloc] init];
    people.Name = @"gustavo";
    people.LastName = @"hansen";
    
    NSString* result = [parser toJsonString:people :Entity.class];
    
    assert([@"{\"Name\" : \"gustavo\",\"Age\" : \"0\",\"LastName\" : \"hansen\"}" isEqualToString:result]);
}

-(void)testToJsonString2{
    JsonParser *parser = [[JsonParser alloc] init];
    Entity *people = [[Entity alloc] init];
    people.Name = @"gustavo";
    people.LastName = @"hansen";
    
    NSArray* peoples = [[NSArray alloc] initWithObjects:people, nil];
    
    EntityWithComplexType *complex= [[EntityWithComplexType alloc] init];
    complex.Peoples = peoples;
    
    NSString* result = [parser toJsonString:complex :EntityWithComplexType.class];
    
    assert([@"{\"Peoples\" : [{\"Name\" : \"gustavo\",\"Age\" : \"0\",\"LastName\" : \"hansen\"}]}" isEqualToString:result]);
}

-(void)testToJsonString3{
    JsonParser *parser = [[JsonParser alloc] init];
    Entity *people = [[Entity alloc] init];
    people.Name = @"gustavo";
    people.LastName = @"hansen";
    
    NSArray* peoples = [[NSArray alloc] initWithObjects:people,people, nil];
    
    EntityWithComplexType *complex= [[EntityWithComplexType alloc] init];
    complex.Peoples = peoples;
    
    NSString *result = [parser toJsonString:complex :EntityWithComplexType.class];
    
    assert([@"{\"Peoples\" : [{\"Name\" : \"gustavo\",\"Age\" : \"0\",\"LastName\" : \"hansen\"},{\"Name\" : \"gustavo\",\"Age\" : \"0\",\"LastName\" : \"hansen\"}]}" isEqualToString:result]);
}

-(void)testToJsonString4{
   /* JsonParser *parser = [[JsonParser alloc] init];
    Entity *people = [[Entity alloc] init];
    people.Name = @"gustavo";
    people.LastName = @"hansen";
    
    NSMutableArray<Entity>* peoples = [[NSMutableArray alloc] initWithObjects:people,people, nil];
    
    NSString* result = [parser toJsonString:peoples : [peoples class]];
    
    assert([@"{\"peoples\" : [{\"Name\" : \"gustavo\",\"Age\" : \"0\",\"LastName\" : \"hansen\"},{\"Name\" : \"gustavo\",\"Age\" : \"0\",\"LastName\" : \"hansen\"}]}" isEqualToString:result]);
*/
}

-(void)testToJsonString5{
    JsonParser *parser = [[JsonParser alloc] init];
    NSString * name = @"Gustavo";
    NSString* result = [parser toJsonString:name Property:@"name"];
    
    assert([@"{\"name\" : \"Gustavo\"}" isEqualToString:result]);
}

@end