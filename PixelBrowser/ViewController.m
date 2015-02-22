//
//  ViewController.m
//  PixelBrowser
//
//  Created by  on 12/02/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "LandscapeViewController.h"
#import "DrawData.h"
#import "PixelObjectDef.h"

#import "IntroductionViewController.h"

#define kHeightOfAddressBar 60.0f
@implementation ViewController

@synthesize backButton,fwdButton,navBar, firstLoad; // 201301 s-takai add

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    DLog(@"init main view");
    bLoading = NO;
    bShowIntro = NO;
    bShowLand = NO;
    bInitLoading = NO;
    
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    navBar = [[WebNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, kHeightOfAddressBar)];
       
    for (UIView* subview in web.scrollView.subviews) {
        if ([NSStringFromClass(subview.class) isEqualToString:@"UIWebBrowserView"]) {
            CGRect webFrame = subview.frame;
            webFrame.origin.y = webFrame.origin.y + kHeightOfAddressBar;
            subview.frame = webFrame;
        }
    }
    
    [web.scrollView addSubview:navBar];
    web.scrollView.backgroundColor = [UIColor darkGrayColor];
    //navBar.TFsearch.delegate = self;
    navBar.TFurl.delegate = self;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotate:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *savedURL = [defaults stringForKey:@"savedURL"];
    if (savedURL == nil) savedURL = NSLocalizedString(@"http://tinyurl.com/mtsurfing", "");
    
    //loadChecker
    //[self loadCheckerStart];
    
    //初期画面
    navBar.text = savedURL;
    //navBar.text = @"http://web.archive.org/web/20080118004954/http://www.meti.go.jp/speeches/data_ed/ed041222-2j.html";
    navBar.prompt = @"Loading";
    
    _data = [[DrawData alloc] initWithWebview:web];
    [self initPODef];
    
    [self startLoading];
}

- (void)initPODef{
    NSMutableDictionary* PODefArray = [NSMutableDictionary dictionary];
    
    NSMutableArray* array;
    
    //Tree
    array = [[NSMutableArray alloc]init]; 
    [PODefArray setObject:array forKey:[NSNumber numberWithInt:POTree]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POTree Image:[UIImage imageNamed:@"tree_02.png"] BaseLine:1 Centering:YES]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POTree Image:[UIImage imageNamed:@"tree_01.png"] BaseLine:1 Centering:YES]];
    
    //safariTree
    array = [[NSMutableArray alloc]init]; 
    [PODefArray setObject:array forKey:[NSNumber numberWithInt:POSafariTree]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POSafariTree Image:[UIImage imageNamed:@"tree_03.png"] BaseLine:1 Centering:YES]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POSafariTree Image:[UIImage imageNamed:@"tree_04.png"] BaseLine:1 Centering:YES]];
    
    //safari
    array = [[NSMutableArray alloc]init]; 
    [PODefArray setObject:array forKey:[NSNumber numberWithInt:POSafari]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POSafari Image:[UIImage imageNamed:@"giraffe_00.png"] BaseLine:2 Centering:YES]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POSafari Image:[UIImage imageNamed:@"lion_00.png"] BaseLine:2 Centering:YES]];
    
    //cow
    array = [[NSMutableArray alloc]init];
    [PODefArray setObject:array forKey:[NSNumber numberWithInt:POCow]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POCow Image:[UIImage imageNamed:@"cow_00.png"] BaseLine:1 Centering:YES]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POCow Image:[UIImage imageNamed:@"cow_01.png"] BaseLine:1 Centering:YES]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POCow Image:[UIImage imageNamed:@"pig_00.png"] BaseLine:1 Centering:YES]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POCow Image:[UIImage imageNamed:@"sheep_00.png"] BaseLine:1 Centering:YES]];
    
    //house
    array = [[NSMutableArray alloc]init]; 
    [PODefArray setObject:array forKey:[NSNumber numberWithInt:POHouse]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POHouse Image:[UIImage imageNamed:@"house_00.png"] BaseLine:0 Centering:YES]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POHouse Image:[UIImage imageNamed:@"house_01.png"] BaseLine:0 Centering:YES]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POHouse Image:[UIImage imageNamed:@"house_02.png"] BaseLine:0 Centering:YES]];
    
    //apart
    array = [[NSMutableArray alloc]init]; 
    [PODefArray setObject:array forKey:[NSNumber numberWithInt:POApart]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POApart Image:[UIImage imageNamed:@"apartment_00.png"] BaseLine:0 Centering:NO]];
    
    //building
    array = [[NSMutableArray alloc]init]; 
    [PODefArray setObject:array forKey:[NSNumber numberWithInt:POBuilding]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POBuilding Image:[UIImage imageNamed:@"building_00.png"] BaseLine:0 Centering:NO]];
    
    //fence
    array = [[NSMutableArray alloc]init]; 
    [PODefArray setObject:array forKey:[NSNumber numberWithInt:POFence]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POFence Image:[UIImage imageNamed:@"fence_00.png"] BaseLine:1]];
    
    //cloud
    array = [[NSMutableArray alloc]init]; 
    [PODefArray setObject:array forKey:[NSNumber numberWithInt:POCloud]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POCloud Image:[UIImage imageNamed:@"cloud_00.png"] BaseLine:0 Centering:YES]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POCloud Image:[UIImage imageNamed:@"cloud_01.png"] BaseLine:0 Centering:YES]];
    
    //Bridge
    array = [[NSMutableArray alloc]init]; 
    [PODefArray setObject:array forKey:[NSNumber numberWithInt:POBridge]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POBridge Image:[UIImage imageNamed:@"bridge_00.png"] BaseLine:0]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POBridge Image:[UIImage imageNamed:@"bridge_01.png"] BaseLine:0]];
    
    //Bird
    array = [[NSMutableArray alloc]init]; 
    [PODefArray setObject:array forKey:[NSNumber numberWithInt:POBird]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POBird Image:[UIImage imageNamed:@"airplane_00.png"] BaseLine:0 Centering:YES]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POBird Image:[UIImage imageNamed:@"airplane_01.png"] BaseLine:0 Centering:YES]];
    
    //Farm
    array = [[NSMutableArray alloc]init]; 
    [PODefArray setObject:array forKey:[NSNumber numberWithInt:POFarm]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POFarm Image:[UIImage imageNamed:@"tower_00.png"] BaseLine:0 Offset:1]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POFarm Image:[UIImage imageNamed:@"farm_00.png"] BaseLine:0]];

    /*
    //Star
    array = [[NSMutableArray alloc]init]; 
    [PODefArray setObject:array forKey:[NSNumber numberWithInt:POStar]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POStar Image:[UIImage imageNamed:@"star_00.png"] BaseLine:0 Centering:YES]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POStar Image:[UIImage imageNamed:@"star_01.png"] BaseLine:0 Centering:YES]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POStar Image:[UIImage imageNamed:@"star_03.png"] BaseLine:0 Centering:YES]];
     */
    
    //Sea
    array = [[NSMutableArray alloc]init]; 
    [PODefArray setObject:array forKey:[NSNumber numberWithInt:POSea]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POSea Image:[UIImage imageNamed:@"lake_03.png"] BaseLine:0]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POSea Image:[UIImage imageNamed:@"upperlake_02.png"] BaseLine:0]];
        
    //Rainbow
    array = [[NSMutableArray alloc]init]; 
    [PODefArray setObject:array forKey:[NSNumber numberWithInt:PORainbow]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POSea Image:[UIImage imageNamed:@"rainbow_03.png"] BaseLine:0]];
    
    //Boat
    array = [[NSMutableArray alloc]init]; 
    [PODefArray setObject:array forKey:[NSNumber numberWithInt:POBoat]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POBoat Image:[UIImage imageNamed:@"boat_00.png"] BaseLine:3 Offset:1]];
    
    //Tower
    array = [[NSMutableArray alloc]init]; 
    [PODefArray setObject:array forKey:[NSNumber numberWithInt:POTower]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POTower Image:[UIImage imageNamed:@"tower_01.png"] BaseLine:0]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POTower Image:[UIImage imageNamed:@"tower_02.png"] BaseLine:0]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POTower Image:[UIImage imageNamed:@"tower_03.png"] BaseLine:0]];
    
    //Human
    array = [[NSMutableArray alloc]init]; 
    [PODefArray setObject:array forKey:[NSNumber numberWithInt:POHuman]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POHuman Image:[UIImage imageNamed:@"human_00.png"] BaseLine:0]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POHuman Image:[UIImage imageNamed:@"human_01.png"] BaseLine:0]];
    
    //Animal
    array = [[NSMutableArray alloc]init]; 
    [PODefArray setObject:array forKey:[NSNumber numberWithInt:POAnimal]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POAnimal Image:[UIImage imageNamed:@"bear_00.png"] BaseLine:0]];
    [array addObject:[[PixelObjectDef alloc]initWithType:POAnimal Image:[UIImage imageNamed:@"bear_01.png"] BaseLine:0]];
    
    [DrawData setPODef:PODefArray];
}
/*
- (void)searchBarSearchButtonClicked:(UISearchBar *)activeSearchBar {
    [activeSearchBar resignFirstResponder];
    //if (![navBar.text hasPrefix:@"http://"]) navBar.text = [NSString stringWithFormat:@"http://%@",navBar.text];
    navBar.text = [NSString stringWithFormat:@"http://www.google.com/search?q=%@&ie=utf-8&oe=utf-8",activeSearchBar.text];
    [self startLoading];
}
 */

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //NSLog(@"return");
    bEditReturn = YES;
    [textField resignFirstResponder];
    if (![navBar.text hasPrefix:@"http://"]) {
        navBar.text = [NSString stringWithFormat:@"http://www.google.com/search?q=%@&ie=utf-8&oe=utf-8",navBar.text];
    }
    [self startLoading];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    bEditReturn = NO;
    oldURL = navBar.text;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"edited did");
    if (!bEditReturn)
        navBar.text = oldURL;
    bEditReturn = NO;
}

- (void)startLoading{
    NSString *urlStr = [navBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSString *urlStr = [self urlencode:navBar.text];
    [self saveURL:navBar.text];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [web loadRequest:request];
    
}

/*
- (NSString *)urlencode:(NSString *)plainString
{
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (__bridge CFStringRef)plainString,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8);
}
 */

- (void)startLoading:(NSString *)url{
    navBar.text = url;
    DLog(@"%@",url);
    [self saveURL:url];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [web loadRequest:request];
}


-(void)saveURL:(NSString *)urlStr{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];            
    [defaults setObject:urlStr forKey:@"savedURL"];
    [defaults synchronize];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    DLog(@"Prepare to land");
    if ([[segue identifier] isEqualToString:@"rotateToLand"]) {
        LandscapeViewController *viewController = (LandscapeViewController*)[segue destinationViewController];
        viewController.fromURL = navBar.text;
        viewController._data = _data;
        viewController.screenHeight = screenHeight;
        //NSLog(@"adas");
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString* URLString = [[[request URL] standardizedURL] absoluteString];
    DLog(@"WebView : shouldStartLoad");
    navBar.text = URLString;
    
    //int direction = self.interfaceOrientation;
    //DLog(@"WebView : Direction is %d",direction);
    //if (direction == 0 || direction == 3 || direction == 4) {
    if (bShowLand){
        DLog(@"WebView : Start Canceled");
        return YES;
    }
    if (!bLoading){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        _data._bFinish = NO;
        bLoading = YES;
        navBar.prompt = @"Loading";
        
        finalCheckTime = 0;
        bInitLoading = YES;
        [self loadCheckerStart];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    DLog(@"WebView : Start Loading");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    DLog(@"WebView : Finish Loading");
    finalCheckTime = CFAbsoluteTimeGetCurrent();
}

- (void)loadCheckerStart{
    DLog(@"timer start");
    loadChecker = [NSTimer 
                   scheduledTimerWithTimeInterval:0.5
                   target:self
                   selector:@selector(loadCheck)
                   userInfo:nil
                   repeats:YES
                   ];
}

- (void) loadCheck{
    DLog(@"Check!");
    if (finalCheckTime != 0 && CFAbsoluteTimeGetCurrent() - finalCheckTime > 0.5){
        bLoading = NO;
        [loadChecker invalidate];
        NSString* title = [web stringByEvaluatingJavaScriptFromString:@"document.title"];
        navBar.prompt = title;
//        if (finalCheckTime == -2){
//            DLog(@"Loading Error 2");
//            UIAlertView *alert =
//            [[UIAlertView alloc]
//             initWithTitle:NSLocalizedString(@"Connection Cancelled","")
//             message:NSLocalizedString(@"Mt.Surfing Cannot complete loading because the connection is cancelled.", "")
//             delegate:self
//             cancelButtonTitle:@"OK"
//             otherButtonTitles:nil];
//            [alert show];
//        } else
        if (finalCheckTime == -1){
            DLog(@"Loading Error 1");
            UIAlertView *alert =
            [[UIAlertView alloc]
             initWithTitle:NSLocalizedString(@"Cannot Open Page","")
             message:NSLocalizedString(@"Mt.Surfing Cannot open the page because the server cannot be found.", "")
             delegate:self
             cancelButtonTitle:@"OK"
             otherButtonTitles:nil];
            [alert show];
        }
        else{
            DLog(@"time check ok : Draw");
            
            navBar.text = [[web stringByEvaluatingJavaScriptFromString:@"document.URL"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [self saveURL:navBar.text];
            //browserURL = navBar.text;
            
        }
        [_data parseWebView];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 201301 s-takai add
    // NSUserDefaultsの取得
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    firstLoad = [defaults stringForKey:@"firstLoad"];
    
    if(firstLoad == nil) {
        // 説明画面の表示
        [self appearIntroductionView];
        
        // NSUserDefaultsに値を設定
        firstLoad = @"loadead";
        [defaults setObject:firstLoad forKey:@"firstLoad"];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

// 201301 s-takai add
- (void)appearIntroductionView {
    //モーダルビューで説明画面を出す
    bShowIntro = YES;
    IntroductionViewController *introductionViewController;
    introductionViewController = [[IntroductionViewController alloc] init];
    // 画面中央に配置
    introductionViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    // 表示スタイル
    introductionViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    // モーダルを表示
    [self presentModalViewController:introductionViewController animated:YES];
}

#pragma mark - ToolBarButtonPushHandler
- (IBAction) pushBackButton:(id)sender {
    // goBackできる状態(戻ることができる状態)なら戻るを実行する
    if (web.canGoBack) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        _data._bFinish = NO;
        bLoading = YES;
        navBar.prompt = @"Loading";
        finalCheckTime = 0;
        [web goBack];
        [self loadCheckerStart];
    }
}

- (IBAction) pushFwdButton:(id)sender {
    // goForwardできる状態(戻ることができる状態)なら戻るを実行する
    if (web.canGoForward) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        _data._bFinish = NO;
        bLoading = YES;
        navBar.prompt = @"Loading";
        finalCheckTime = 0;
        [web goForward];
        [self loadCheckerStart];
    }
}

// 201301 s-takai add
- (IBAction) pushInfoButton:(id)sender {
    // 説明画面の表示
    [self appearIntroductionView];
}

#pragma mark - rotateHandler
- (void)rotateToLand
{
    DLog(@"to Land");
    [self performSegueWithIdentifier:@"rotateToLand" sender:self];
}

- (void)didRotate:(NSNotification *)notification {
    UIDeviceOrientation orientation = [[notification object] orientation];
    DLog(@"didRotate");
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        if (!bShowIntro && !bShowLand && bInitLoading) {
            [self rotateToLand];
        }
    } else if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown) {
    }
}
- (BOOL)shouldAutorotate {
    if (bShowIntro)
        return NO;
    else
        return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - WebView lifecycle
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSInteger err_code = [error code];
    DLog(@"Loading Error:%s", __FUNCTION__);
	if (err_code == NSURLErrorCancelled) {
        finalCheckTime = -2;
		return;
	}
    finalCheckTime = -1;
}

- (void)setBShowIntro:(BOOL)_bShowIntro{
    bShowIntro = _bShowIntro;
}

- (void)setBShowLand:(BOOL)_bShowLand{
    bShowLand = _bShowLand;
}

-(void)dealloc{
    DLog(@"main view dealloc");
}

@end
