//
//  LandView.m
//  MountainSurfing
//
//  Created by  on 12/02/16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LandView.h"
#import "DrawData.h"
#import <QuartzCore/QuartzCore.h>
#import "PixelObject.h"

@implementation LandView

@synthesize _data,height,width,screenHeight;

- (id)initWithData:(DrawData *)data Frame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        _data = data;
        // Initialization code
        srand(time(NULL));
        //if (rand() % 10 == 0)
        //if (false)
        //    self.backgroundColor = [UIColor colorWithRed:15/255.0f green:27/255.0f blue:73/255.0f alpha:1.0f];
        //else
        //    self.backgroundColor = [UIColor colorWithRed:128/255.0f green:206/255.0f blue:195/255.0f alpha:1.0f];
        //self.backgroundColor = [UIColor colorWithRed:128/255.0f green:206/255.0f blue:195/255.0f alpha:1.0f];
        //self.backgroundColor = [UIColor redColor];
        
        rate = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"VerticalPixelSize"] intValue];
        p_rate = 1/8.0f;
        height = frame.size.height;
        width = frame.size.width;
        
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(completeDraw) name:@"drawFinish" object:nil];
        
        /*
        POViewArray = [[NSMutableArray alloc]init];
        [POViewArray addObject:[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)]];
        [POViewArray addObject:[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)]];
        [POViewArray addObject:[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)]];
        for (UIView* v in POViewArray){
            v.userInteractionEnabled = YES;
            [self addSubview:v];
        }
         */
        
        DLog(@"LandView初期化");
        [self.layer setMagnificationFilter:kCAFilterNearest];
        
        if (_data._bFinish) [self drawInit];
        else{
            loadingView = [[UIView alloc] initWithFrame:self.bounds];
            loadingView.backgroundColor = [UIColor blackColor];
            loadingView.alpha = 0.5;
            
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
            [indicator setCenter:CGPointMake(loadingView.bounds.size.width / 2, loadingView.bounds.size.height / 2 + 20)];
            [loadingView addSubview:indicator];
            [indicator startAnimating];
            [self addSubview:loadingView];
            
            UILabel* waitLabel = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                           0,
                                                                           loadingView.bounds.size.height / 2 - 40,
                                                                           loadingView.bounds.size.width,
                                                                           20)];
            waitLabel.text = NSLocalizedString(@"Please wait", "");
            waitLabel.backgroundColor = [UIColor clearColor];
            waitLabel.font = [UIFont systemFontOfSize:14];
            waitLabel.textAlignment = UITextAlignmentCenter;
            waitLabel.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
            [loadingView addSubview:waitLabel];
            
            [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0]];
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)completeDraw{
    DLog(@"delay draw!");
    [loadingView removeFromSuperview];
    if (_data._bFinish){
        if ([_data getMax] > 320 / rate - 4)
            height = ([_data getMax] + 4) * rate;
        else
            height = 320;
        width = ([[_data getLandData] count] + 10) * rate;
    }
    UIScrollView* superView = (UIScrollView*)self.superview;
    [superView setContentSize:CGSizeMake(width, height)];
    self.frame = CGRectMake(0, 0, width, height);
    if (height > 320){
        superView.minimumZoomScale = screenHeight / width;
        superView.zoomScale = 320.0 / height;
    }
    else
        superView.minimumZoomScale = screenHeight / width;
    [self drawInit];
}

-(void)drawInit{
    
    DLog(@"drawInit");
    
    //ctx = UIGraphicsGetCurrentContext();
    //CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);  
    
    //gradient background NOT USE //
    /*
     CGGradientRef gradient;
     CGColorSpaceRef colorSpace;
     size_t num_locations = 2;
     CGFloat locations[2] = { 0.0, 1.0 };
     CGFloat components[8] = { 128/255.0f, 206/255.0f, 195/255.0f, 1.0,  // Start color
     1, 1, 1, 1.0 }; // End color
     colorSpace = CGColorSpaceCreateDeviceRGB();
     gradient = CGGradientCreateWithColorComponents(colorSpace, components,
     locations, num_locations);
     
     CGPoint startPoint = CGPointMake(self.frame.size.width/2, 0.0);
     CGPoint endPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height);
     CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
     */
     
    
    //UIImage* backImage = [[UIImage alloc] initWithCGImage:[_data getImage]];
    
    UIImage* backImage = [_data getUIImage];
    DLog(@"Size = %f:%f",backImage.size.width,backImage.size.height);
    DLog(@"LandSize = %d",[[_data getLandData]count]);
    //[backImage drawInRect:CGRectMake(0, 0, backImage.size.width * 2, backImage.size.height * 2)];
    UIImageView* bgiv = [[UIImageView alloc] initWithImage:backImage];
    [bgiv.layer setMagnificationFilter:kCAFilterNearest];
    bgiv.transform = CGAffineTransformMakeScale(2, 2);
    CGRect bgframe = [bgiv frame];
    bgframe.origin = CGPointMake(0,0);
    [bgiv setFrame:bgframe];    
    //[[POViewArray objectAtIndex:0] addSubview:bgiv];
    [self addSubview:bgiv];
    
    /*
    //pixel objectを使う場合の初期配置
    //UIScrollView* scrollView = (UIScrollView*)self.superview;
    for (PixelObject* obj in [_data getPOData]) {
        obj.bShow = NO;
    }
    CGRect area = CGRectMake(0, 0, height * 1.5, height); 
    //CGRect area = CGRectMake(0, 0, width, height);  
    [self setPOdataArea:area];
     */
    
    /*
    NSUInteger i = 0;
    for (PixelObject* obj in [_data getPOData]) {
        UIImage *image = obj.def.img;
        UIImageView *iv = [[UIImageView alloc] initWithImage:image];
        [iv.layer setMagnificationFilter:kCAFilterNearest];
        NSInteger reverse = 1;
        if (obj.ref == 1) reverse = -1;
        if (obj.ref == 2) reverse = 1 - (rand() % 2 * 2);
        iv.transform = CGAffineTransformMakeScale(reverse * rate * p_rate, rate * p_rate);
        
        //NSLog(@"%d",(obj.def.baseLine - obj.def.height) * rate / 8);
        
        CGRect frame = [iv frame];
        frame.origin = CGPointMake(obj.x - obj.def.offset * rate * p_rate, height - obj.y + (NSInteger)(obj.def.baseLine - obj.def.height) * rate * p_rate);
        [iv setFrame:frame];
        
        [self addSubview:iv];
        i++;
	}
     */
    
    UIImage* logoImage = [UIImage imageNamed:@"logo_00.png"];
    UIImageView *iv = [[UIImageView alloc] initWithImage:logoImage];
    
    float logoRate = height / 320.0;
    float logoX = width - (logoImage.size.width + 25) * logoRate;
    float logoY = 80 * logoRate;
    if (height != 320)
        iv.transform = CGAffineTransformMakeScale(logoRate,logoRate);
    CGRect frame = [iv frame];
    frame.origin = CGPointMake(logoX, logoY);
    [iv setFrame:frame];
    //[[POViewArray objectAtIndex:2] addSubview:iv];
    [self addSubview:iv];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               logoX, 
                                                               logoY + (logoImage.size.height + 1) * logoRate, 
                                                               logoImage.size.width * logoRate, 
                                                                    15 * logoRate)];
    UILabel* urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                    logoX, 
                                                                    logoY + (logoImage.size.height + 12) * logoRate, 
                                                                    logoImage.size.width * logoRate, 
                                                                    15 * logoRate)];
    titleLabel.text = _data._title;
    urlLabel.text = _data._URL;
    titleLabel.backgroundColor = [UIColor clearColor];
    urlLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:12 * logoRate];
    urlLabel.font = [UIFont systemFontOfSize:9 * logoRate];
    titleLabel.textAlignment = UITextAlignmentRight;
    urlLabel.textAlignment = UITextAlignmentRight;
    titleLabel.textColor = [UIColor colorWithRed:113/255.0 green:113/255.0 blue:113/255.0 alpha:1.0];
    urlLabel.textColor = [UIColor colorWithRed:113/255.0 green:113/255.0 blue:113/255.0 alpha:1.0];
    //[[POViewArray objectAtIndex:2] addSubview:titleLabel];
    //[[POViewArray objectAtIndex:2] addSubview:urlLabel];
    [self addSubview:titleLabel];
    [self addSubview:urlLabel];
    //[_data._URL drawInRect:CGRectMake(0, 0, 200, 10) withFont:[UIFont systemFontOfSize:20]];
}

-(void)setPOdataScrollView:(UIScrollView*)scrollView{  
    CGPoint p = scrollView.contentOffset;
    CGFloat s = scrollView.zoomScale;
    CGRect area = CGRectMake(p.x/s, p.y/s, screenHeight/s, 320/s);  
    [self setPOdataArea:area];
}

-(void)setPOdataArea:(CGRect)area{
    NSUInteger count = 0;
    for (PixelObject* obj in [_data getPOData]) {
        BOOL bShow = obj.bShow;
        if (!bShow){
            POImageView *iv;
            CGRect frame;
            if (obj.imageView == nil){
                UIImage *image = obj.def.img;
                iv = [[POImageView alloc] initWithImage:image];
                iv.userInteractionEnabled = YES;
                [iv.layer setMagnificationFilter:kCAFilterNearest];
                NSInteger reverse = 1;
                if (obj.ref == 1) reverse = -1;
                if (obj.ref == 2) reverse = 1 - (rand() % 2 * 2);
                iv.transform = CGAffineTransformMakeScale(reverse * rate * p_rate, rate * p_rate);
                obj.imageView = iv;
                frame = [iv frame];
                frame.origin = CGPointMake(obj.x - obj.def.offset * rate * p_rate, height - obj.y + (NSInteger)(obj.def.baseLine - obj.def.height) * rate * p_rate);
                [iv setFrame:frame];
                //NSLog(@"new image!!");
            }
            else{
                iv = obj.imageView;
                frame = [iv frame];
            }
        
            //NSLog(@"%d",(obj.def.baseLine - obj.def.height) * rate / 8);
            //NSLog(@"");
            if (frame.origin.x + frame.size.width > area.origin.x && frame.origin.x < area.origin.x + area.size.width){
                //[[POViewArray objectAtIndex:obj.z] addSubview:iv];
                [self insertSubview:iv atIndex:count+1];
                obj.bShow = YES;
                count++;
            }
        }
        else{
            CGRect frame = [obj.imageView frame];
            if (frame.origin.x + frame.size.width < area.origin.x || frame.origin.x > area.origin.x + area.size.width){
                [obj.imageView removeFromSuperview];
                obj.bShow = NO;
            }else{
                count++;
            }
        }
	}
    //NSLog(@"set PO:%d",[[self subviews]count]);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //NSLog(@"drawRectスタート");
    //NSLog(@"drawRect!");
    
    /*
    CGSize size = CGSizeMake(2000.0f, 320.0f);
    CGRect frame = [self frame];
    frame.size.width = size.width;
    frame.size.height = size.height;
    
    [self setFrame:frame];
     */
    
}
- (void)dealloc{
    DLog(@"LandView:dealloc");
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:@"drawFinish" object:nil];
}

@end
