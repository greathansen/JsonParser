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
  
  JsonParser* parser = [[JsonParser alloc] init];
  
  //Representation of data throught NSData
  NSData *data =  [@"{d : {results :{Name : 'gustavo'}}}" dataUsingEncoding:NSUTF8StringEncoding];
  
  //The result is the id to the object, 
  // could be a NSArray (each item is a entity object) or the entity
  id result = [parser parseWithData:data forType:Entity.class]; 
  
