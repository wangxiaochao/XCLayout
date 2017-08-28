//
//  XCDevKit_Object_Runtime.m
//  XCDevKit
//
//  Created by 钧泰科技 on 15/11/30.
//  Copyright © 2015年 wxc. All rights reserved.
//

#import "XCDevKit_Object_Runtime.h"
#import <objc/runtime.h>

@implementation NSObject(XCDevKit_Object_Runtime)
+ (NSArray *)loadedClassNames
{
    static dispatch_once_t		once;
    static NSMutableArray *		classNames;
    
    dispatch_once( &once, ^
                  {
                      classNames = [[NSMutableArray alloc] init];
                      
                      unsigned int 	classesCount = 0;
                      Class *		classes = objc_copyClassList( &classesCount );
                      
                      for ( unsigned int i = 0; i < classesCount; ++i )
                      {
                          Class classType = classes[i];
                          
                          if ( class_isMetaClass( classType ) )
                              continue;
                          
                          Class superClass = class_getSuperclass( classType );
                          
                          if ( nil == superClass )
                              continue;
                          
                          [classNames addObject:[NSString stringWithUTF8String:class_getName(classType)]];
                      }
                      
                      [classNames sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                          return [obj1 compare:obj2];
                      }];
                      
                      free( classes );
                  });
    
    return classNames;
}

+ (NSArray *)subClasses
{
    NSMutableArray * results = [[NSMutableArray alloc] init];
    
    for ( NSString * className in [self loadedClassNames] )
    {
        Class classType = NSClassFromString( className );
        if ( classType == self )
            continue;
        
        if ( NO == [classType isSubclassOfClass:self] )
            continue;
        
        [results addObject:[classType description]];
    }
    
    return results;
}

+ (NSArray *)methods
{
    return [self methodsUntilClass:[self superclass]];
}

+ (NSArray *)methodsUntilClass:(Class)baseClass
{
    NSMutableArray * methodNames = [[NSMutableArray alloc] init];
    
    Class thisClass = self;
    
    baseClass = baseClass ?: [NSObject class];
    
    while ( NULL != thisClass )
    {
        unsigned int	methodCount = 0;
        Method *		methodList = class_copyMethodList( thisClass, &methodCount );
        
        for ( unsigned int i = 0; i < methodCount; ++i )
        {
            SEL selector = method_getName( methodList[i] );
            if ( selector )
            {
                const char * cstrName = sel_getName(selector);
                if ( NULL == cstrName )
                    continue;
                
                NSString * selectorName = [NSString stringWithUTF8String:cstrName];
                if ( NULL == selectorName )
                    continue;
                
                [methodNames addObject:selectorName];
            }
        }
        
        free( methodList );
        
        thisClass = class_getSuperclass( thisClass );
        
        if ( nil == thisClass || baseClass == thisClass )
        {
            break;
        }
    }
    
    return methodNames;
}

+ (NSArray *)methodsWithPrefix:(NSString *)prefix
{
    return [self methodsWithPrefix:prefix untilClass:[self superclass]];
}

+ (NSArray *)methodsWithPrefix:(NSString *)prefix untilClass:(Class)baseClass
{
    NSArray * methods = [self methodsUntilClass:baseClass];
    
    if ( nil == methods || 0 == methods.count )
    {
        return nil;
    }
    
    if ( nil == prefix )
    {
        return methods;
    }
    
    NSMutableArray * result = [[NSMutableArray alloc] init];
    
    for ( NSString * selectorName in methods )
    {
        if ( NO == [selectorName hasPrefix:prefix] )
        {
            continue;
        }
        
        [result addObject:selectorName];
    }
    
    [result sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
    return result;
}

+ (NSArray *)properties
{
    return [self propertiesUntilClass:[self superclass]];
}

+ (NSArray *)propertiesUntilClass:(Class)baseClass
{
    NSMutableArray * propertyNames = [[NSMutableArray alloc] init];
    
    Class thisClass = self;
    
    baseClass = baseClass ?: [NSObject class];
    
    while ( NULL != thisClass )
    {
        unsigned int		propertyCount = 0;
        objc_property_t *	propertyList = class_copyPropertyList( thisClass, &propertyCount );
        
        for ( unsigned int i = 0; i < propertyCount; ++i )
        {
            const char * cstrName = property_getName( propertyList[i] );
            if ( NULL == cstrName )
                continue;
            
            NSString * propName = [NSString stringWithUTF8String:cstrName];
            if ( NULL == propName )
                continue;
            
            [propertyNames addObject:propName];
        }
        
        free( propertyList );
        
        thisClass = class_getSuperclass( thisClass );
        
        if ( nil == thisClass || baseClass == thisClass )
        {
            break;
        }
    }
    
    return propertyNames;
}

+ (NSArray *)propertiesWithPrefix:(NSString *)prefix
{
    return [self propertiesWithPrefix:prefix untilClass:[self superclass]];
}

+ (NSArray *)propertiesWithPrefix:(NSString *)prefix untilClass:(Class)baseClass
{
    NSArray * properties = [self propertiesUntilClass:baseClass];
    
    if ( nil == properties || 0 == properties.count )
    {
        return nil;
    }
    
    if ( nil == prefix )
    {
        return properties;
    }
    
    NSMutableArray * result = [[NSMutableArray alloc] init];
    
    for ( NSString * propName in properties )
    {
        if ( NO == [propName hasPrefix:prefix] )
        {
            continue;
        }
        
        [result addObject:propName];
    }
    
    [result sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
    return result;
}

+ (NSArray *)classesWithProtocolName:(NSString *)protocolName
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    Protocol * protocol = NSProtocolFromString(protocolName);
    for ( NSString *className in [self loadedClassNames] )
    {
        Class classType = NSClassFromString( className );
        if ( classType == self )
            continue;
        
        if ( NO == [classType conformsToProtocol:protocol] )
            continue;
        
        [results addObject:[classType description]];
    }
    
    return results;
}

+ (void *)replaceSelector:(SEL)sel1 withSelector:(SEL)sel2
{
    Method method = class_getInstanceMethod( self, sel1 );
    
    IMP implement = (IMP)method_getImplementation( method );
    IMP implement2 = class_getMethodImplementation( self, sel2 );
    
    method_setImplementation( method, implement2 );
    
    return (void *)implement;
}
@end
