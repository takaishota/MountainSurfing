//
//  MyScrollView.m
//  MountainSurfing
//
//  Created by  on 12/03/07.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyScrollView.h"

@implementation MyScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
 */

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {	
    if (!self.dragging) {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {	
    if (!self.dragging) {
        [self.nextResponder touchesEnded:touches withEvent:event]; 
    }
}

@end
