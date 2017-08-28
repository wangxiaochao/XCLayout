//
//  XCActionPool.m
//  XLT
//
//  Created by 钧泰科技 on 15/6/9.
//  Copyright (c) 2015年 wxc. All rights reserved.
//

#import "XCActionPool.h"
#import "XCLayoutUtil.h"
#import "XCPrimitiveFilter.h"
#import "XCPrimitiveAction.h"

@implementation XCActionPool
{
    NSMutableDictionary *_actionPool;
    NSMutableDictionary *_filterPool;
}
+ (XCActionPool *)sharedXCActionPool
{
    static XCActionPool *sharedXCActionPool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedXCActionPool = [[super alloc] init];
    });
    return sharedXCActionPool;
}


- (void)systemAction
{
    
    [self addFilter:xcF_FloatFilter tag:[XCPrimitiveFilter class] sel:@selector(floatFilter:)];
    [self addFilter:xcF_BoolFilter tag:[XCPrimitiveFilter class] sel:@selector(boolFilter:)];
    [self addFilter:xcF_IntFilter tag:[XCPrimitiveFilter class] sel:@selector(intFilter:)];
    
    [self addAction:xcA_SizeToFitAction tag:[XCPrimitiveAction class] sel:@selector(sizeToFit:)];
}

- (id)init
{
    if (self = [super init])
    {
        _actionPool = [[NSMutableDictionary alloc] init];
        _filterPool = [[NSMutableDictionary alloc] init];
        
        [self systemAction];
    }
    return self;
}

- (void)addFilter:(NSString *)filter tag:(id)tag sel:(SEL)sel
{
    XCActionPoolObj *obj = [[XCActionPoolObj alloc] init];
    obj.sel = sel;
    obj.tag = tag;
    [_filterPool setObject:obj forKey:filter];
}
- (void)addAction:(NSString *)action tag:(id)tag sel:(SEL)sel
{
    XCActionPoolObj *obj = [[XCActionPoolObj alloc] init];
    obj.sel = sel;
    obj.tag = tag;
    [_actionPool setObject:obj forKey:action];
}

- (id)sendAction:(NSString *)action tag:(id)tag
{
    
    NSArray *aS = [action componentsSeparatedByString:@"|"];
    id value = nil;
    
    for (NSString *action in aS)
    {
        NSArray *vs = [action componentsSeparatedByString:@":"];
        XCActionPoolObj *obj = [_actionPool objectForKey:[vs objectAtIndex:0]];
        if (obj == nil)
        {
            return nil;
        }
        
        NSMutableArray *params = [NSMutableArray arrayWithObject:tag];
        NSArray *otherParams = [vs objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, vs.count-1)]];
        if (otherParams.count > 0)
        {
            [params addObjectsFromArray:otherParams];
        }
        
        value = [XCLayoutUtil callBackSel:obj.tag sel:obj.sel parames:params];
    }
    
    return value;
}
- (id)sendFilter:(NSString *)filter params:(id)params
{
    XCActionPoolObj *obj = [_filterPool objectForKey:filter];
    if (obj == nil)
    {
        return nil;
    }
    
    return [XCLayoutUtil callBackSel:obj.tag sel:obj.sel parames:params];
}

- (XCActionPoolObj *)getActionObjForKey:(NSString *)key
{
    XCActionPoolObj *obj = [_actionPool objectForKey:key];
    if (obj == nil)
    {
        return nil;
    }
    return obj;
}
- (XCActionPoolObj *)getFilterObjForKey:(NSString *)key
{
    XCActionPoolObj *obj = [_filterPool objectForKey:key];
    if (obj == nil)
    {
        return nil;
    }
    return obj;
}
@end


@implementation XCActionPoolObj

@end








