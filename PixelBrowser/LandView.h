//
//  LandView.h
//  MountainSurfing
//
//  Created by  on 12/02/16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawData.h"

@interface LandView : UIView{
    DrawData* _data;
    //CGContextRef ctx;
    NSInteger rate;
    NSUInteger height;
    NSUInteger width;
    float p_rate;
    UIView* loadingView;
    CGFloat screenHeight;
    //NSMutableArray* POViewArray;
}
@property (nonatomic,retain)DrawData *_data;
@property (nonatomic,assign)NSUInteger height;
@property (nonatomic,assign)NSUInteger width;
@property (nonatomic,assign)CGFloat screenHeight;

-(void)drawInit;
-(void)completeDraw;
-(id)initWithData:(DrawData*)data
                Frame:(CGRect)frame;
-(void)setPOdataScrollView:(UIScrollView*)scrollView;
-(void)setPOdataArea:(CGRect)area;

@end
