//
//  XCXMLParse.h
//  XCDevKit
//
//  Created by 钧泰科技 on 15/4/17.
//  Copyright (c) 2015年 wxc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XCXMLElement;

@interface XCXMLParse : NSObject<NSXMLParserDelegate>

- (XCXMLElement *)parse:(NSString *)xml;
@end

@interface XCXMLElement : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *text;
@property (nonatomic,strong) NSMutableDictionary *attributes;
@property (nonatomic,strong) NSMutableArray *subElements;
@property (nonatomic,weak) XCXMLElement *parent;
@end