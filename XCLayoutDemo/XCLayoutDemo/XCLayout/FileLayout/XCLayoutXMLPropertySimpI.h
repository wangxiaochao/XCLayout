//
//  XCLayoutXMLPropertySimpI.h
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/5.
//  Copyright © 2016年 wxc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCLayoutXMLPropertySimpI : NSObject
@property (nonatomic,readonly) NSMutableDictionary *simp;

+ (XCLayoutXMLPropertySimpI *)sharedSimp;
@end


static void SetXMLPropertySim()
{
    NSMutableDictionary *XMLPROPERTYSIM = [XCLayoutXMLPropertySimpI sharedSimp].simp;
    
    [XMLPROPERTYSIM setObject:@"xc_tlbr" forKey:@"tlbr"];       //将xc_tlbr设置简写为trbl
    [XMLPROPERTYSIM setObject:@"xc_Top" forKey:@"t"];
    [XMLPROPERTYSIM setObject:@"xc_Right" forKey:@"r"];
    [XMLPROPERTYSIM setObject:@"xc_Bottom" forKey:@"b"];
    [XMLPROPERTYSIM setObject:@"xc_Left" forKey:@"l"];
    
    [XMLPROPERTYSIM setObject:@"xc_padding" forKey:@"padding"];
    [XMLPROPERTYSIM setObject:@"xc_PaddingTop" forKey:@"pt"];
    [XMLPROPERTYSIM setObject:@"xc_PaddingRight" forKey:@"pr"];
    [XMLPROPERTYSIM setObject:@"xc_PaddingBottom" forKey:@"pb"];
    [XMLPROPERTYSIM setObject:@"xc_PaddingLeft" forKey:@"pl"];
    
    [XMLPROPERTYSIM setObject:@"xc_margin" forKey:@"margin"];
    [XMLPROPERTYSIM setObject:@"xc_MarginTop" forKey:@"mt"];
    [XMLPROPERTYSIM setObject:@"xc_MarginRight" forKey:@"mr"];
    [XMLPROPERTYSIM setObject:@"xc_MarginBottom" forKey:@"mb"];
    [XMLPROPERTYSIM setObject:@"xc_MarginLeft" forKey:@"ml"];
    
    [XMLPROPERTYSIM setObject:@"xc_size" forKey:@"size"];               //size有扩展算法
    [XMLPROPERTYSIM setObject:@"xc_heightAuto" forKey:@"heightAuto"];   //高度是否可以被子控件撑大
    [XMLPROPERTYSIM setObject:@"xc_Width" forKey:@"width"];
    [XMLPROPERTYSIM setObject:@"xc_Height" forKey:@"height"];
    
    [XMLPROPERTYSIM setObject:@"xc_display" forKey:@"dis"];
    [XMLPROPERTYSIM setObject:@"xc_position" forKey:@"pos"];
    [XMLPROPERTYSIM setObject:@"xc_center" forKey:@"center"];
    
    [XMLPROPERTYSIM setObject:@"xc_inlineBr" forKey:@"inline"];
    
    [XMLPROPERTYSIM setObject:@"backgroundColor-Color" forKey:@"bg"];       //设置背景色
    [XMLPROPERTYSIM setObject:@"xc_highlightedBackgroundColor-Color" forKey:@"hbg"];   //高亮背景色
    
    [XMLPROPERTYSIM setObject:@"xc_backgroundImage-Image" forKey:@"bgImage"];   //设置背景图片
    [XMLPROPERTYSIM setObject:@"xc_highlightedBackgroundImage-Image" forKey:@"hbgImage"];   //设置高亮背景图片
    
    [XMLPROPERTYSIM setObject:@"border_radius" forKey:@"border_radius"];
    [XMLPROPERTYSIM setObject:@"border" forKey:@"border"];
    
    [XMLPROPERTYSIM setObject:@"xc_borderLine" forKey:@"border_line"];
    [XMLPROPERTYSIM setObject:@"xc_topBorderLine" forKey:@"border_line_t"];
    [XMLPROPERTYSIM setObject:@"xc_leftBorderLine" forKey:@"border_line_l"];
    [XMLPROPERTYSIM setObject:@"xc_bottomBorderLine" forKey:@"border_line_b"];
    [XMLPROPERTYSIM setObject:@"xc_rightBorderLine" forKey:@"border_line_r"];
    
}



