//
//  XCXMLParse.m
//  XCDevKit
//
//  Created by 钧泰科技 on 15/4/17.
//  Copyright (c) 2015年 wxc. All rights reserved.
//
#if !__has_feature(objc_arc)
#error must be built with ARC.
#endif

#import "XCXMLParse.h"
@interface XCXMLParse ()
{
    XCXMLElement *_rootElement;
    XCXMLElement *_currentElementPointer;
}
@end
@implementation XCXMLParse

- (XCXMLElement *)parse:(NSString *)xml
{
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    xmlParser.delegate = self;
    [xmlParser parse];
    
    return _rootElement;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    _rootElement = nil;
    _currentElementPointer = nil;
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if(_rootElement == nil)
    {
        _rootElement = [[XCXMLElement alloc] init];
        _currentElementPointer = _rootElement;
    }
    else
    {
        XCXMLElement *newElement = [[XCXMLElement alloc]init];
        newElement.parent = _currentElementPointer;
        [_currentElementPointer.subElements addObject:newElement];
        
        _currentElementPointer = newElement;
        
    }
    
    _currentElementPointer.name = elementName;
    _currentElementPointer.attributes = [NSMutableDictionary dictionaryWithDictionary:attributeDict];
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    _currentElementPointer = _currentElementPointer.parent;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if([_currentElementPointer.text length] > 0)
    {
        _currentElementPointer.text = [_currentElementPointer.text stringByAppendingString:string];
    }
    else
    {
        _currentElementPointer.text = [NSMutableString stringWithString:string];
    }
}
@end



@implementation XCXMLElement
- (void)dealloc
{
}
- (id)init
{
    if (self = [super init])
    {
        _subElements = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
