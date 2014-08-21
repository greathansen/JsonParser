//
//  Entity.h
//  JsonParser
//
//  Created by Gustavo on 8/20/14.
//
//

#import <Foundation/Foundation.h>

@interface Entity : NSObject

@property NSString *Name;
@property int Age;
@property NSString *LastName;
@property NSDate *LastLogIn;

@end

//To Handle Typed Collections
@protocol Entity

@end