//
//  ViewController.h
//  PixelBrowser
//
//  Created by  on 12/02/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebNavigationBar.h"

@class DrawData;

@interface ViewController : UIViewController<UIWebViewDelegate, UISearchBarDelegate, UITextFieldDelegate>{
    IBOutlet UIWebView *web;
    IBOutlet UIBarButtonItem *backButton;
    IBOutlet UIBarButtonItem *fwdButton;
    //IBOutlet UISearchBar *search;
    WebNavigationBar* navBar;
    //NSString *browserURL;
    NSString *innerHTML;
    DrawData *_data;
    NSTimer* loadChecker;
    double finalCheckTime;
    BOOL bLoading;
    BOOL bEditReturn;
    BOOL bShowIntro;
    BOOL bShowLand;
    BOOL bInitLoading;
    NSString *oldURL;
    CGFloat screenHeight;
}

@property (nonatomic,retain)WebNavigationBar *navBar;
@property (nonatomic,retain)UIBarButtonItem *backButton;
@property (nonatomic,retain)UIBarButtonItem *fwdButton;
@property (nonatomic,retain)NSString *firstLoad; // 201301 s-takai add

- (IBAction) pushBackButton:(id)sender;
- (IBAction) pushFwdButton:(id)sender;
- (IBAction) pushInfoButton:(id)sender; // 201301 s-takai add
- (void)initPODef;
- (void)startLoading;
- (void)startLoading:(NSString *)url;
- (void)loadCheckerStart;
//- (NSString *)urlencode:(NSString *)plainString;
- (void)saveURL:(NSString*)urlStr;
- (void)appearIntroductionView;
- (void)setBShowIntro:(BOOL)_bShowIntro;
- (void)setBShowLand:(BOOL)_bShowLand;
@end
