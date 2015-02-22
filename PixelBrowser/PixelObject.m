//
//  PixelObject.m
//  MountainSurfing
//
//  Created by  on 12/02/17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PixelObject.h"

@implementation PixelObject

@synthesize x,y,def,ref,bShow,imageView,z;
- (id)init
{
    self = [super init];
    if( self )
    {
    }
    
    return self;
}

-(id)initWithDef:(PixelObjectDef *)_def 
               x:(NSUInteger)_x  
               y:(NSUInteger)_y
               z:(NSUInteger)_z
             ref:(NSUInteger)_ref
{
    self = [super init];
    if( self )
    {
        def = _def;
        x = _x;
        y = _y;
        z = _z;
        ref = _ref;
        bShow = NO;
        imageView = nil;
    }
    return self;
}

@end
