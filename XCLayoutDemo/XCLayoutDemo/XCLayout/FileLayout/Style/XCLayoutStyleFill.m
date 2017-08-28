//
//  XCLayoutStyleFill.m
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/4.
//  Copyright © 2016年 wxc. All rights reserved.
//

#import "XCLayoutStyleFill.h"
#import "XCResourceManage.h"
#import "XCLayoutFileConfig.h"
#import "XCLayoutUtil.h"

#import "XCLayoutXMLPropertySimpI.h"

#import "XCValueFiller.h"

#import "XCLayoutView+Ext+Inner.h"
#import "XCLayoutView+Ext.h"

#import "XCActionPool.h"

#import "XCLayoutViewXMLObject.h"

#import "UIColor+RGB.h"
@implementation XCLayoutStyleFill

/**
 *样式填充 obj 填充对象 style要填充的样式列表 摘取的 动态属性列表 runtionDic
 */
+ (void)fillStyleGetRuntimeProperty:(UIView *)view style:(NSMutableDictionary *)style runtionDic:(NSMutableDictionary *)runtionDic viewXML:(XCLayoutViewXMLObject *)viewXML
{
    if (![view isKindOfClass:[UIView class]])
        return;
    if (view.xc_sizeClass == nil)
        return;
    
    for (NSString *key in style.allKeys)
    {
        id value = [style objectForKey:key];
        if (value == nil)        //没有
            continue;
        
        if ([value rangeOfString:@"{{"].location != NSNotFound)
        {
            [runtionDic setValue:value forKeyPath:key];
        }
        
        value = [XCValueFiller comDataImmit:value data:viewXML.dataSource];
        
        [self fillStyle:view key:key value:value];              //圆角阴影什么的再说 阴影什么的再说
    }
}

+ (void)fillStyle:(UIView *)view key:(NSString *)key value:(NSString *)value
{
    //将简写 转换为 正常值
    NSString *orginKey = [[XCLayoutXMLPropertySimpI sharedSimp].simp objectForKey:key];
    if (orginKey)
        key = orginKey;
    
    if ([key isEqualToString:@"x-beginSEL"])
    {
        XCActionPoolObj *poolObj = [[XCActionPool sharedXCActionPool] getActionObjForKey:value];
        if (poolObj)
        {
            [view xc_setLayoutBeginSEL:poolObj.tag sel:poolObj.sel];
        }
        
        return;
    }
    if ([key isEqualToString:@"x-endSEL"])
    {
        XCActionPoolObj *poolObj = [[XCActionPool sharedXCActionPool] getActionObjForKey:value];
        if (poolObj)
        {
            [view xc_setLayoutEndSEL:poolObj.tag sel:poolObj.sel];
        }
        return;
    }
    if ([key isEqualToString:@"xc_size"])
    {
        [self setSize:value view:view];
        return;
    }
    if ([key isEqualToString:@"xc_Width"])
    {
        [self setWidth:value view:view];
        return;
    }
    if ([key isEqualToString:@"xc_Hidth"])
    {
        [self setHeight:value view:view];
        return;
    }
    if ([key isEqualToString:@"xc_tlbr"] || [key isEqualToString:@"xc_padding"] || [key isEqualToString:@"xc_margin"])
    {
        UIEdgeInsets edge = [self getEdge:value];
        [XCLayoutUtil setObjProperty:view key:key value:[NSValue valueWithUIEdgeInsets:edge]];
        return;
    }
    if ([key isEqualToString:@"xc_display"] || [key isEqualToString:@"xc_position"] || [key isEqualToString:@"xc_center"])
    {
        [XCLayoutUtil setObjProperty:view key:key value:[NSNumber numberWithInteger:[value integerValue]]];
        return;
    }
    //边框和圆角 和 阴影
    if ([key isEqualToString:@"border_radius"])  //圆角
    {
        view.clipsToBounds = YES;
        view.layer.cornerRadius = [value floatValue];
        return;
    }
    if ([key isEqualToString:@"border"])
    {
        [self setBorder:value view:view];
        return;
    }
    if ([key isEqualToString:@"border_shadow"])
    {
        [self setBorderShadow:value view:view];
        return;
    }
    if ([key isEqualToString:@"xc_borderLine"] || [key isEqualToString:@"xc_leftBorderLine"] || [key isEqualToString:@"xc_rightBorderLine"]
         || [key isEqualToString:@"xc_topBorderLine"] || [key isEqualToString:@"xc_bottomBorderLine"])
    {
        XCBorderLineDraw *border = [self getBorderLineDraw:value];
        [XCLayoutUtil setObjProperty:view key:key value:border];
        return;
    }
    
    NSRange range = [key rangeOfString:@".."];       //是否是状态型赋值
    if (range.location == NSNotFound)           //不是状态赋值
    {
        range = [key rangeOfString:@"-"];       //格式化
        if (range.location == NSNotFound)       //不需要格式化
        {
            [XCLayoutUtil setObjProperty:view key:key value:value];
            return;
        }
        else
        {
            id data = [self propertyFormat:key value:value view:view];
            [XCLayoutUtil setObjProperty:view key:[key substringToIndex:range.location] value:data];
            return;
        }
    }
    else
    {
        [self setObjPropertyState:view key:[key substringToIndex:range.location] value:value state:[key substringFromIndex:range.location+2]];
        return;
    }
}

+ (id)propertyFormat:(NSString *)key value:(id)value view:(UIView *)view
{
    NSRange range = [key rangeOfString:@"-"];
    if (range.location == NSNotFound)
    {
        return value;
    }
    
    if ([key hasSuffix:@"-Color"])
    {
        UIColor *color=nil;
        color = [self getColor:value];
        return color;
    }
    else if ([key hasSuffix:@"-Image"])
    {
        UIImage *image = [self getImage:value];
        return image;
    }
    else if ([key hasSuffix:@"-Font"])
    {
        UIFont *font=nil;
        font =[self getFont:value];
        return font;
    }
    else if ([key hasSuffix:@"-Action"])
    {
        if (value)
        {
            return [[XCActionPool sharedXCActionPool] sendAction:value tag:view];
        }
    }
    
    return value;
}


//size
+ (void)setSize:(NSString *)value view:(UIView *)view
{
    NSArray *array = [value componentsSeparatedByString:@","];
    if (array.count != 2)
    {
        return;
    }
    
    NSString *width = [array objectAtIndex:0];
    NSString *height = [array objectAtIndex:1];
    
    [self setWidth:width view:view];
    [self setHeight:height view:view];
}
+ (void)setWidth:(NSString *)value view:(UIView *)view
{
    if ([value isEqualToString:@"-"])            //根据frame
    {
        view.xc_width.equalToFrame();
        return;
    }
    if ([value isEqualToString:@"auto"])            //填充模式
    {
        view.xc_width.equalToAuto();
        return;
    }
    if ([value isEqualToString:@"*"])            //适应模式
    {
        view.xc_width.equalToFit();
        return;
    }
    if ([value hasSuffix:@"%"])     //百分比
    {
        value = [value substringToIndex:[value rangeOfString:@"%"].location];
        view.xc_width.ratio([value floatValue]/100);
        return;
    }
    if ([value hasSuffix:@"+"])     //根据设备 适应值
    {
        value = [value substringToIndex:[value rangeOfString:@"+"].location];
        view.xc_width.equalToDevice([value floatValue]);
        return;
    }
    
    CGFloat val = [value floatValue];
    if (val == 0)           //铺满
    {
        view.xc_width.equalToSuper();
        return;
    }
    
    view.xc_width.equalTo(val);
}
+ (void)setHeight:(NSString *)value view:(UIView *)view
{
    if ([value isEqualToString:@"-"])            //根据frame
    {
        view.xc_height.equalToFrame();
        return;
    }
    if ([value isEqualToString:@"auto"])            //填充模式
    {
        view.xc_height.equalToAuto();
        return;
    }
    if ([value isEqualToString:@"*"])            //适应模式
    {
        view.xc_height.equalToFit();
        return;
    }
    if ([value hasSuffix:@"%"])     //百分比
    {
        value = [value substringToIndex:[value rangeOfString:@"%"].location];
        view.xc_height.ratio([value floatValue]/100);
        return;
    }
    if ([value hasSuffix:@"+"])     //根据设备 适应值
    {
        value = [value substringToIndex:[value rangeOfString:@"+"].location];
        view.xc_height.equalToDevice([value floatValue]);
        return;
    }
    
    CGFloat val = [value floatValue];
    if (val == 0)           //铺满
    {
        view.xc_height.equalToSuper();
        return;
    }
    
    view.xc_height.equalTo(val);
}

//UIEdgeInsets
+ (UIEdgeInsets)getEdge:(NSString *)value
{
    NSArray *array = [value componentsSeparatedByString:@","];
    if (array.count == 0 || array.count > 4)
    {
        return UIEdgeInsetsMake(0,0,0,0);
    }
    float top,left,down,right;
    if (array.count == 1)
    {
        NSString * oneObj =[array  objectAtIndex:0];
        top =[oneObj floatValue];
        
        return UIEdgeInsetsMake(top, top, top, top);
    }
    if (array.count == 2)
    {
        NSString * oneObj =[array  objectAtIndex:0];
        NSString * twoObj =[array  objectAtIndex:1];
        
        top =[oneObj floatValue];
        left =[twoObj floatValue];
        
        return UIEdgeInsetsMake(top, left, top, left);
    }
    if (array.count == 3)
    {
        NSString * oneObj =[array  objectAtIndex:0];
        NSString * twoObj =[array  objectAtIndex:1];
        NSString * threeObj =[array  objectAtIndex:2];
        
        top =[oneObj floatValue];
        left =[twoObj floatValue];
        down=[threeObj floatValue];
        
        return UIEdgeInsetsMake(top, left, down, left);
        
    }
    if (array.count == 4)
    {
        NSString * oneObj =[array  objectAtIndex:0];
        NSString * twoObj =[array  objectAtIndex:1];
        NSString * threeObj =[array  objectAtIndex:2];
        NSString * fourObj =[array  objectAtIndex:3];
        
        top =[oneObj floatValue];
        left =[twoObj floatValue];
        down=[threeObj floatValue];
        right=[fourObj floatValue];
        
        return UIEdgeInsetsMake(top, left, down, right);
    }
    return UIEdgeInsetsMake(0,0,0,0);
}

//color
+ (UIColor *)getColor:(NSString *)value
{
    NSString *str = [[[XCLayoutFileConfig sharedXCLayoutFileConfig] colorDic] objectForKey:value];
    if (str)
        value = str;
    
    if ([value hasPrefix:@"#"])
    {
        return [UIColor UIColorFromRGB:value];
    }
    if ([value hasSuffix:@".png"])
    {
        UIImage *image = [self getImage:value];
        return [UIColor colorWithPatternImage:image];
    }
    
    NSArray *array = nil;
    if (value)
    {
        if ([value isEqualToString:@"0"])
        {
            return [UIColor clearColor];
        }
        array = [value componentsSeparatedByString:@","];
    }
    if (array.count != 4)
    {
        return [UIColor clearColor];
    }
    float red,green,blue,alpha;
    red = [(NSString *)[array objectAtIndex:0] floatValue];
    green = [(NSString *)[array objectAtIndex:1] floatValue];
    blue = [(NSString *)[array objectAtIndex:2] floatValue];
    alpha = [(NSString *)[array objectAtIndex:3] floatValue];
    
    return [UIColor colorWithRed:red/255.0 green:green/255. blue:blue/255. alpha:alpha];
}

//font
+ (UIFont *)getFont:(NSString *)value
{
    NSString *str = [[[XCLayoutFileConfig sharedXCLayoutFileConfig] fontDic] objectForKey:value];
    if (str)
        value = str;
    
    NSArray *array = [value componentsSeparatedByString:@","];
    
    if (array.count == 0 || array.count > 2)
    {
        return [UIFont systemFontOfSize:12];
    }
    if (array.count == 1)
    {
        return [UIFont systemFontOfSize:[[array objectAtIndex:0] floatValue]];
    }
    
    NSString *fontName = [array objectAtIndex:0];
    float fontSize = [(NSString *)[array objectAtIndex:1] floatValue];
    
    if ([fontName isEqualToString:@"B"])
    {
        return [UIFont boldSystemFontOfSize:fontSize];
    }
    
    return [UIFont fontWithName:fontName size:fontSize];
}

//image
+ (UIImage *)getImage:(NSString *)value
{
    NSString *str = [[[XCLayoutFileConfig sharedXCLayoutFileConfig] colorDic] objectForKey:value];
    if (str)
        value = str;
    
    if ([value hasPrefix:@"#"] || [value rangeOfString:@","].location != NSNotFound)
    {
        UIColor *color = [self getColor:value];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIImage *image = [XCLayoutUtil imageWithColor:color andSize:window.frame.size];
        return image;
    }
    return [UIImage imageWithContentsOfFile:[[XCResourceManage sharedXCResourceManage] getImagesPath:value]];
}
//btn
+ (void)setObjPropertyState:(id)obj key:(NSString *)key value:(NSString *)value state:(NSString *)state
{
    id tag = obj;
    NSArray *array = [key componentsSeparatedByString:@"."];
    if (array.count > 1)
    {
        tag = [obj valueForKeyPath:[[array objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count-1)]] componentsJoinedByString:@"."]];
    }
    if (tag == nil || tag == [NSNull null])
        return;
    
    if (![tag isKindOfClass:[UIControl class]])
        return;
    
    id data = [self propertyFormat:key value:value view:obj];
    char s = [state UTF8String][0];
    
    NSString *skye = [array lastObject];
    NSRange range = [key rangeOfString:@"-"];
    if (range.location != NSNotFound)
    {
        skye = [skye substringToIndex:range.location];
    }
    
    if ([skye isEqualToString:@"bgImage"])
    {
        switch (s)
        {
            case 'n':
                [obj setBackgroundImage:data forState:UIControlStateNormal];
                break;
            case 'h':
                [obj setBackgroundImage:data forState:UIControlStateHighlighted];
                break;
            case 'd':
                [obj setBackgroundImage:data forState:UIControlStateDisabled];
                break;
            case 's':
                [obj setBackgroundImage:data forState:UIControlStateSelected];
                break;
            case 'a':
                [obj setBackgroundImage:data forState:UIControlStateApplication];
                break;
            case 'r':
                [obj setBackgroundImage:data forState:UIControlStateReserved];
                break;
            default:
                break;
        }
        return;
    }
    if ([skye isEqualToString:@"title"])
    {
        switch (s)
        {
            case 'n':
                [obj setTitle:data forState:UIControlStateNormal];
                break;
            case 'h':
                [obj setTitle:data forState:UIControlStateHighlighted];
                break;
            case 'd':
                [obj setTitle:data forState:UIControlStateDisabled];
                break;
            case 's':
                [obj setTitle:data forState:UIControlStateSelected];
                break;
            case 'a':
                [obj setTitle:data forState:UIControlStateApplication];
                break;
            case 'r':
                [obj setTitle:data forState:UIControlStateReserved];
                break;
            default:
                break;
        }
        return;
    }
    if ([skye isEqualToString:@"image"])
    {
        switch (s)
        {
            case 'n':
                [obj setImage:data forState:UIControlStateNormal];
                break;
            case 'h':
                [obj setImage:data forState:UIControlStateHighlighted];
                break;
            case 'd':
                [obj setImage:data forState:UIControlStateDisabled];
                break;
            case 's':
                [obj setImage:data forState:UIControlStateSelected];
                break;
            case 'a':
                [obj setImage:data forState:UIControlStateApplication];
                break;
            case 'r':
                [obj setImage:data forState:UIControlStateReserved];
                break;
            default:
                break;
        }
        return;
    }
    if ([skye isEqualToString:@"titleColor"])
    {
        switch (s)
        {
            case 'n':
                [obj setTitleColor:data forState:UIControlStateNormal];
                break;
            case 'h':
                [obj setTitleColor:data forState:UIControlStateHighlighted];
                break;
            case 'd':
                [obj setTitleColor:data forState:UIControlStateDisabled];
                break;
            case 's':
                [obj setTitleColor:data forState:UIControlStateSelected];
                break;
            case 'a':
                [obj setTitleColor:data forState:UIControlStateApplication];
                break;
            case 'r':
                [obj setTitleColor:data forState:UIControlStateReserved];
                break;
            default:
                break;
        }
        return;
    }
}

#pragma mark --- 各种边框
//边框
+ (void)setBorder:(NSString *)value view:(UIView *)view
{
    NSArray *s = [value componentsSeparatedByString:@" "];
    if (s.count < 1)
    {
        return;
    }
    CGFloat width = [[s objectAtIndex:0] floatValue];
    UIColor *color = [self getColor:[s objectAtIndex:1]];
    
    view.layer.borderWidth = width;
    view.layer.borderColor = color.CGColor;
}
//阴影
+ (void)setBorderShadow:(NSString *)value view:(UIView *)view
{
    NSArray *s = [value componentsSeparatedByString:@" "];
    if (s.count < 2)
    {
        return;
    }
    CGFloat width = [[s objectAtIndex:0] floatValue];
    UIColor *color = [self getColor:[s objectAtIndex:1]];
    
    view.layer.shadowOpacity = width;
//    view.layer.shadowOffset = size;
    view.layer.shadowColor = color.CGColor;
}
+ (XCBorderLineDraw *)getBorderLineDraw:(NSString *)value
{
    NSArray *s = [value componentsSeparatedByString:@" "];
    if (s.count < 2)
    {
        return nil;
    }
    
    XCBorderLineDraw *border = [XCBorderLineDraw new];
    CGFloat width = [[s objectAtIndex:0] floatValue];
    UIColor *color = [self getColor:[s objectAtIndex:1]];
    
    border.thick = width;
    border.color = color;
    
    if (s.count >= 3)
    {
        CGFloat dash = [[s objectAtIndex:2] floatValue];
        border.dash = dash;
    }
    
    return border;
}
#pragma end
@end










