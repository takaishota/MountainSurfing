//
//  HTMLData.h
//  PixelBrowser
//
//  Created by  on 12/02/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTMLNode.h"
#import "HTMLParser.h"
#import "PixelObject.h"

@interface DrawData : NSObject{
@private
    //NSString* _URL;
    //NSString* _title;
    NSString* _source;
    UIWebView* _webview;
    NSMutableArray* _landArray;
    NSMutableArray* _POArray;
    NSUInteger rate;
    NSUInteger _dataMax;
    CGImageRef _image;
    UIImage* _uiimage;
    //Boolean _bFinish;
    NSNotification* _n;
}

@property (nonatomic,retain)NSString* _URL;
@property (nonatomic,retain)NSString* _title;
@property (nonatomic,assign)Boolean _bFinish;

- (id)initWithSource:(NSString*)source;
- (id)initWithWebview:(UIWebView*)webView;

- (void)parseWebView;
- (void)parseHTML:(NSString*)source;
- (void)parseElem:(HTMLNode*)elem
        nodeLevel:(NSInteger)level;

- (void)analyzeLand;
- (void)createPO;
- (void)drawImage;

-(void)addPOArray:(POType)_type
                x:(NSInteger)_x
                y:(NSInteger)_y
            index:(NSInteger)_index;

-(void)addPOArray:(POType)_type
                x:(NSInteger)_x
                y:(NSInteger)_y
            index:(NSInteger)_index
              ref:(NSUInteger)_ref;

-(void)addPOArray:(POType)_type
                x:(NSInteger)_x
                y:(NSInteger)_y
                z:(NSInteger)_z
            index:(NSInteger)_index
              ref:(NSUInteger)_ref;

- (NSMutableArray*)getLandData;
- (NSMutableArray*)getPOData;
- (NSUInteger)getMax;
- (CGImageRef)getImage;
- (UIImage*)getUIImage;

- (UIImage*)mirrorImage:(UIImage*)img;


+(NSMutableDictionary*)getPODef;
+(void)setPODef:(NSMutableDictionary*)_arr;

@end
