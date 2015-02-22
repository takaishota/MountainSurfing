//
//  LandscapeViewController.m
//  PixelBrowser
//
//  Created by  on 12/02/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LandscapeViewController.h"
#import "DrawData.h"
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation LandscapeViewController

@synthesize fromURL,_data,screenHeight;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [UIApplication sharedApplication].statusBarHidden = YES;
    bShowmenu = NO;
	[super loadView];
    self.view.frame = CGRectMake(0,0,screenHeight,320);
    NSInteger rate = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"VerticalPixelSize"] intValue];
    NSUInteger height = 320;
    NSUInteger width = screenHeight;
    if (_data._bFinish){
        if ([_data getMax] > 320 / rate - 4)
            height = ([_data getMax] + 4) * rate;
        width = ([[_data getLandData] count] + 10) * rate;
    }
	landView = [[LandView alloc] initWithData:self._data Frame:CGRectMake(0, 0, width, height)];
    landView.screenHeight = screenHeight;
  	//landView = [[LandView alloc] initWithFrame:CGRectMake(0, 0, 3960, height)];
        
	scrollview = [[MyScrollView alloc]
                                initWithFrame:CGRectMake(0, 0, screenHeight, 320)];
    scrollview.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    //[scrollview setShowBackgroundShadow:YES];
    
	[self.view addSubview:scrollview];
    DLog(@"addSubView:scrollView");
    
    //[scrollview setContentSize:landView.frame.size];
    [scrollview setContentSize:CGSizeMake(width, height)];
    DLog(@"setContentSize");
	[scrollview addSubview:landView];
    DLog(@"addSubView:landView");
        
    scrollview.delegate = self;
    scrollview.maximumZoomScale = 1.0;
	scrollview.bouncesZoom = NO;
    scrollview.alwaysBounceVertical = NO;
    if (height > 320){
        scrollview.minimumZoomScale = screenHeight / width;
        scrollview.zoomScale = 320.0 / height;
        CGRect r = landView.frame;
        r.origin.x = 0; r.origin.y = 0;
        landView.frame = r;
    }
    else
        scrollview.minimumZoomScale = screenHeight / width;
    

    DLog(@"property set");
    [(ViewController*)[self presentingViewController] setBShowLand:YES];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView.subviews objectAtIndex:0]; // １番目のオブジェクトを返すので画像とラベルを含んだviewが拡大縮小される
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollview.zoomScale < 320.0 / landView.height){
        //NSLog(@"%f",landView.frame.size.height);
        CGRect r = landView.frame;
        //r.origin.y = landView.height / 4 * (scrollview.zoomScale / (320.0 / landView.height));
        r.origin.y = (320 - landView.frame.size.height) / 2;
        landView.frame = r;
    }
    else{
        CGRect r = landView.frame;
        r.origin.y = 0;
        landView.frame = r;
    }
    //pixel objectを使わない場合はコメントアウト
    //[landView setPOdataScrollView:scrollView];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Notificationを送信する
    NSNotification* notification = [NSNotification notificationWithName:@"didDrawLandView" object:self userInfo:nil];
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center postNotification:notification];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotate:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    //[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    //NSLog(@"%d",[destLand getData]);
    //[landView drawPixel:10 y:10];
    //landView._data = self._data;
}

- (void)rotateToPortrait
{
    [menuAlert dismissWithClickedButtonIndex:0 animated:NO];
    DLog(@"To Portrait");
    ViewController* vc = (ViewController*)[self presentingViewController];
    [vc setBShowLand:NO];
    [self dismissViewControllerAnimated:YES completion:^{
        //callback
    }];
    
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight+UIInterfaceOrientationMaskLandscapeLeft;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return false;
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight ||
            interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}
- (void) didRotate:(NSNotification *)notification {
    UIDeviceOrientation orientation = [[notification object] orientation];
    
    if (orientation == UIDeviceOrientationLandscapeLeft) {
    } else if (orientation == UIDeviceOrientationLandscapeRight) {
    } else if (orientation == UIDeviceOrientationPortrait) {
        [self rotateToPortrait];
    } else if (orientation == UIDeviceOrientationPortraitUpsideDown) {    
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_data._bFinish) return;
    for (UITouch *touch in touches) {
        if (touch.tapCount >= 2 && !bShowmenu) {
            DLog(@"double tap");
            /*
            UIActionSheet *as = [[UIActionSheet alloc] init];
            as.delegate = self;
            as.title = @"Landscape To...";
            [as addButtonWithTitle:@"Twitter"];
            [as addButtonWithTitle:@"Save Image"];
            [as addButtonWithTitle:@"Cancel"];
            as.cancelButtonIndex = 2;
            [as showInView:self.view];
             */
            [self showIndicatorWithMessage:nil];
            bShowmenu = YES;
            menuAlert= [[UIAlertView alloc]  
                                  initWithTitle:nil
                                  message:nil
                                  delegate:self 
                                  cancelButtonTitle:NSLocalizedString(@"Cancel", "")
                                  otherButtonTitles:
                                  NSLocalizedString(@"Twitter", ""), 
                                  NSLocalizedString(@"Save Panorama", ""), nil];
            [menuAlert show];
            [self hideIndicator];
        } 
    }
}


-(void)alertView:(UIAlertView*)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0://cancel
            //NSLog(@"adas");
            bShowmenu = NO;
            break;
        case 1:{//twitter
            [self showIndicatorWithMessage:NSLocalizedString(@"Launch Twitter...", "")];
            TWTweetComposeViewController *viewController = [[TWTweetComposeViewController alloc] init];
            
            [viewController setInitialText:[NSString stringWithFormat:NSLocalizedString(@"Browsing the website(%@) by #MtSurfing", ""),_data._title]];
            [viewController addImage:[self imageFromView:scrollview ViewPort:YES]];
            //[viewController addImage:image];
            //[viewController addURL:[NSURL URLWithString:_data._URL]];
            
            viewController.completionHandler = ^(TWTweetComposeViewControllerResult res) {
                if (res == TWTweetComposeViewControllerResultDone) {
                    //NSLog(@"done");
                    [self dismissModalViewControllerAnimated:YES];
                } else if (res == TWTweetComposeViewControllerResultCancelled) {
                    //NSLog(@"cancel");
                    [self dismissModalViewControllerAnimated:YES];
                }
                bShowmenu = NO;
            };
            
            [self presentModalViewController:viewController animated:YES];
            [self hideIndicator];
            break;
        }
        case 2:{//save image
            [self showIndicatorWithMessage:NSLocalizedString(@"Saving...", "")];
            UIImage* img = [self imageFromView:scrollview ViewPort:NO];
            UIImageWriteToSavedPhotosAlbum(img,self, @selector(savingImageIsFinished:didFinishSavingWithError:contextInfo:),nil);
            break;
        }
        /*
        case 3:{//save image
            [self showIndicatorWithMessage:@"保存中..."];
            UIImage* img = [self imageFromView:scrollview ViewPort:NO];
            UIImageWriteToSavedPhotosAlbum(img,self, @selector(savingImageIsFinished:didFinishSavingWithError:contextInfo:),nil);
            break;
        }
         */
    }
    
}

- (void) savingImageIsFinished:(UIImage *)_image
      didFinishSavingWithError:(NSError *)_error
                   contextInfo:(void *)_contextInfo
{
    bShowmenu = NO;
    [self hideIndicator];
}

-(void)showIndicatorWithMessage:(NSString *)msg{
    loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
    loadingView.backgroundColor = [UIColor blackColor];
    loadingView.alpha = 0.0f;
    
    if (msg != nil){
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                       0,
                                                                       loadingView.bounds.size.height / 2 - 40,
                                                                       loadingView.bounds.size.width,
                                                                       20)];
        label.text = msg;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [loadingView addSubview:label];
    }
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [indicator setCenter:CGPointMake(loadingView.bounds.size.width / 2, loadingView.bounds.size.height / 2)];
    [loadingView addSubview:indicator];
    [indicator startAnimating];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [loadingView setAlpha:0.5];
    [self.view addSubview:loadingView];
    [UIView commitAnimations];
    
    [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0]];
    
}

-(void)hideIndicator{
    [indicator stopAnimating];
    [indicator removeFromSuperview];
    [loadingView removeFromSuperview];
}

- (UIImage*)imageFromView:(UIScrollView*)view ViewPort:(BOOL)bViewport
{
    
    //UIImage* image;
    //NSLog(@"%d",[view.subviews count]);
    CGContextRef context;
    if (bViewport){
        UIGraphicsBeginImageContext(view.frame.size);
        context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, -view.contentOffset.x, -view.contentOffset.y);
        [view.layer renderInContext:context];
    }
    else{
        [landView setPOdataArea:CGRectMake(0, 0, landView.width, landView.height)];
        for (UIView* v in view.subviews){
            if ([NSStringFromClass(v.class) isEqualToString:@"LandView"]){
                UIGraphicsBeginImageContext(CGSizeMake(landView.width, landView.height));
                context = UIGraphicsGetCurrentContext();
                [v.layer renderInContext:context];
            }
        }
    }
    //[view.layer renderInContext:context];
    //CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    //[view.layer drawInContext:context];
    //image = UIGraphicsGetImageFromCurrentImageContext();
    //NSLog(@"%f,%f",image.size.width,image.size.height);
    NSData *pngData = UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext());
    UIImage *screenShotImage = [UIImage imageWithData:pngData];
    
    UIGraphicsEndImageContext();
    
    return screenShotImage;
    
}



@end
