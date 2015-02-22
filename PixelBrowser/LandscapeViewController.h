//
//  LandscapeViewController.h
//  PixelBrowser
//
//  Created by  on 12/02/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LandView.h"
#import "MyScrollView.h"
#import <Twitter/TWTweetComposeViewController.h>

@class DrawData;

@interface LandscapeViewController : UIViewController<UIScrollViewDelegate,UIAlertViewDelegate>
{

    NSString *fromURL;    
    //IBOutlet UILabel *label;
    DrawData* _data;
    LandView* landView;
    MyScrollView* scrollview;
    UIAlertView* menuAlert;
    Boolean bShowmenu;
    
    UIView *loadingView;
    UIActivityIndicatorView *indicator;
    CGFloat screenHeight;
    
}
@property (nonatomic,retain)NSString *fromURL;
@property (nonatomic,retain)DrawData *_data;
@property (nonatomic,assign)CGFloat screenHeight;

-(UIImage*)imageFromView:(UIScrollView*)view
                ViewPort:(BOOL)bViewport;

-(void)showIndicatorWithMessage:(NSString*)msg;
-(void)hideIndicator;

@end
