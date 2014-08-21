//
//  JsonParser.m
//  JsonParser
//
//  Created by Gustavo on 8/20/14.
//

#import "JsonParser.h"
#import "Property.h"
#import <objc/runtime.h>

@interface JsonParser()

@property (nonatomic, strong) NSMutableArray *arrayToReturn;
@property (nonatomic, strong) NSArray *jsonArray;
@property (nonatomic, strong) NSMutableArray *properties;

@end

@implementation JsonParser

-(id)parseWithData : (NSData*)data forType : (Class) type{
    
    id parseResult;
    self.properties = [self getPropertiesFor:type];
    
    NSArray *jsonResult;
    NSDictionary *dResult = [[NSJSONSerialization JSONObjectWithData:data
                                                             options: NSJSONReadingMutableContainers error:nil] valueForKey:@"d"];
    
    if(dResult.count > 1){
        parseResult = [self parseObjectData:dResult Type:type];
    }
    else if(dResult.count == 1){
        jsonResult = [dResult valueForKey:@"results"];
        
        if(jsonResult.count > 1) parseResult = [self parseArrayData:jsonResult Type:type];
        
    }
    else{
        jsonResult = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error:nil];

        parseResult = [self parseObjectData:jsonResult Type:type];
    }
    
    return parseResult;
}

-(id)parseObjectData : (NSDictionary*) data Type:(Class)type{
    
    id returnType = [[type alloc] init];
    
    for (Property* property in self.properties) {
        [self setValueFor:property Data:data Return:returnType];
    }
    
    return returnType;
}

-(NSMutableArray*)parseArrayData : (NSArray*) data Type : (Class)type{
    
    self.arrayToReturn = [NSMutableArray array];
    
    for (NSDictionary *dictionary in data) {
        [self.arrayToReturn addObject:[self parseObjectData:dictionary Type:type]];
    }
    
    return self.arrayToReturn;
}

-(NSMutableArray*)getPropertiesFor : (Class)type {
    NSMutableArray* result = [NSMutableArray array];
    
    Class class = type;
    
    do {
        unsigned int count, i;
        objc_property_t *properties = class_copyPropertyList(class, &count);
        
        for (i = 0; i < count; i++) {
            
            Property * property = [[Property alloc]initWith:properties[i]];
            
            [result addObject:property];
        }
        
        free(properties);
        class = [class superclass];
    } while ([class superclass]);
    
    return result;
}

-(void)setValueFor : (Property*) property Data : (NSDictionary*) data Return : (id)returnType{
    
    if ([property isComplexType]) {
        
        if([property isString]){
            [returnType setValue:[data valueForKeyPath:property.Name] forKeyPath:property.Name];
        }
        else if([property isDate]){
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssz"];
            
            NSDate *date = [dateFormatter dateFromString:[data valueForKeyPath:property.Name]];
            [returnType setValue:date forKeyPath:property.Name];
            
        }
        else if([property isCollection]){
            Class type = NSClassFromString([property getCollectionEntity]);
            
            NSArray * array = [self getPropertiesFor:type];
            NSArray *newData = [data valueForKeyPath:property.Name];
            NSMutableArray* returnData = [NSMutableArray array];
            
            for (NSDictionary* dicc in newData) {
                
                id entity = [[type alloc] init];
                for (Property* property in array) {
                
                    [self setValueFor:property Data:dicc Return:entity];
                }
                
                [returnData addObject:entity];
                [returnType setValue:returnData forKeyPath:property.Name];
            }
        }
        else{//complex type
            
            Class type = NSClassFromString(property.Type);
            
            NSArray * array = [self getPropertiesFor:type];
            NSDictionary *newData = [data valueForKeyPath:property.Name];
            for (Property* property in array) {
                
                [self setValueFor:property Data:newData Return:returnType];
            }
        }
    }
    else{
        [returnType setValue:[data valueForKeyPath:property.Name] forKeyPath:property.Name];
    }
}
@end