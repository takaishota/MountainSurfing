//
//  PixelObjectDef.m
//  MountainSurfing
//
//  Created by  on 12/02/17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PixelObjectDef.h"

@implementation PixelObjectDef

@synthesize width,height,type,baseLine,img,offset;

- (id)init
{
    self = [super init];
    if( self )
    {
    }
    
    return self;
}

-(id)initWithType:(POType)_type 
            Width:(NSUInteger)_width 
           Height:(NSUInteger)_height 
            Image:(UIImage *)_img 
             Name:(NSString *)_name 
         BaseLine:(NSInteger)_baseLine
           Offset:(NSInteger)_offSet;
{
    self = [super init];
    if( self )
    {
        type = _type;
        width = _width;
        height = _height;
        name = _name;
        img = _img;
        baseLine = _baseLine;
        offset = _offSet;
    }
    return self;
}

-(id)initWithType:(POType)_type  
            Image:(UIImage *)_img 
         BaseLine:(NSInteger)_baseLine
           Offset:(NSInteger)_offSet;
{
    self = [super init];
    if( self )
    {
        type = _type;
        width = _img.size.width;
        height = _img.size.height;
        img = _img;
        baseLine = _baseLine;
        offset = _offSet;
    }
    return self;
}

-(id)initWithType:(POType)_type  
            Image:(UIImage *)_img 
         BaseLine:(NSInteger)_baseLine;
{
    self = [super init];
    if( self )
    {
        type = _type;
        width = _img.size.width;
        height = _img.size.height;
        img = _img;
        baseLine = _baseLine;
        offset = 0;
    }
    return self;
}

-(id)initWithType:(POType)_type  
            Image:(UIImage *)_img 
         BaseLine:(NSInteger)_baseLine
        Centering:(bool)_bCenter;
{
    self = [super init];
    if( self )
    {
        type = _type;
        width = _img.size.width;
        height = _img.size.height;
        img = _img;
        baseLine = _baseLine;
        if (_bCenter)
            offset = (NSInteger)(width / 2);
        else
            offset = 0;
    }
    return self;
}


@end
