//
//  PixelObject.h
//  MountainSurfing
//
//  Created by  on 12/02/17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PixelObjectDef.h"
#import "POImageView.h"

@interface PixelObject : NSObject
{
    //@public
    //NSInteger x;
    //NSInteger y;
    //PixelObjectDef* def;
    //∫NSUInteger ref;
}

@property (nonatomic,assign)NSInteger x;
@property (nonatomic,assign)NSInteger y;
@property (nonatomic,retain)PixelObjectDef* def;
@property (nonatomic,assign)NSUInteger ref;
@property (nonatomic,assign)BOOL bShow;
@property (nonatomic,retain)POImageView* imageView;
@property (nonatomic,assign)NSInteger z;


-(id) initWithDef:(PixelObjectDef*)_def
                x:(NSUInteger)_x
                y:(NSUInteger)_y
                z:(NSUInteger)_z
                ref:(NSUInteger)_ref;

@end
