JsonParser
==========
Simple json parser for Objective C
Type that can be parser:
  -Complex Object with simple properties:
  -NSString
  -Float
  -bool
  -int
  -Complex type with Superclasses

Pending:
   -NSArray
   -NSDictionary
   -NSDate
   
-How to Use:

  -All the objects must be Plain objects
  
  Objc Code
  
    JsonParser *parser = [[JsonParser alloc] init];
    NSData *data = [@"{\"Name\" : \"Gustavo\", \"LastName\" : \"Hansen\", \"Age\" : \"26\"}" dataUsingEncoding:NSUTF8StringEncoding];
    
    Entity *result = [parser parseWithData:data forType:Entity.class];
  
