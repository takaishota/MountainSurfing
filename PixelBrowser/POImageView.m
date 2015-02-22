//
//  POImageView.m
//  MountainSurfing
//
//  Created by  on 12/04/05.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "POImageView.h"
#import "MyScrollView.h"

@implementation POImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code		
        //NSLog(@"init");
        //self.userInteractionEnabled = YES;
        //[self setMultipleTouchEnabled:YES];
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /*
    CGPoint p = self.center;
    [UIView beginAnimations:nil context:nil]; 
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationRepeatCount:3.5];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(AnimationDidStop:finished:context:)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.center = CGPointMake(p.x, p.y - 8);
    [UIView commitAnimations];
     */
    //NSLog(@"%@",NSStringFromClass(self.superview.superview.class));
    ((MyScrollView*)self.superview.superview).ScrollEnabled = NO;
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        //CGPoint p = self.center;
        self.center = [touch locationInView:self.superview];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    ((MyScrollView*)self.superview.superview).ScrollEnabled = YES;
}

- (void)AnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    CGPoint p = self.center;
    [UIView beginAnimations:nil context:nil]; 
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    self.center = CGPointMake(p.x, p.y + 8);
    [UIView commitAnimations];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
