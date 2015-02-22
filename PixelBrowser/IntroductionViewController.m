//
//  IntroductionViewController.m
//  MountainSurfing
//
//  Created by Takai Shota on 13/01/09.
//
//

#import "IntroductionViewController.h"
#import "ViewController.h"

@implementation IntroductionViewController

@synthesize scrollView,pageControl;

const NSUInteger kNumImages = 5;

- (void)viewDidLoad
{
    NSLog(@"%s", __FUNCTION__);
    [super viewDidLoad];
    //バージョン確認
    NSArray *aOsVersions = [[[UIDevice currentDevice]systemVersion] componentsSeparatedByString:@"."];
    NSInteger iOsVersionMajor = [[aOsVersions objectAtIndex:0] intValue];
    //NSInteger iOsVersionMinor1 = [[aOsVersions objectAtIndex:1] intValue];
    
    // 背景色
    self.view.backgroundColor = [UIColor grayColor];
    
    // ボタンの定義
    UIButton *modalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    modalBtn.frame = CGRectMake(0, 0, 40, 40);
    modalBtn.center = CGPointMake(self.view.frame.size.width - 30, 30);
    [modalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [modalBtn setTitle:@"×" forState:UIControlStateNormal];
    [modalBtn addTarget:self action:@selector(modalBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // ページコントロールの定義
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    pageControl.numberOfPages = kNumImages;
    pageControl.currentPage = 0;
    pageControl.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 20);
    if (iOsVersionMajor == 6){
        pageControl.pageIndicatorTintColor = [UIColor grayColor];
        pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    }
    pageControl.alpha = 0.9;
    
    // scrollViewの定義
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:237.0/255.0 blue:222.0/255.0 alpha:1.0];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    [scrollView setContentSize:CGSizeMake((kNumImages * self.view.frame.size.width), [scrollView bounds].size.height)];
    
    //iPhoneの言語設定判定
    NSArray *langs = [NSLocale preferredLanguages];
    NSString *currentLanguage = [langs objectAtIndex:0];
    NSString *baseFileName;
    if([currentLanguage compare:@"ja"] == NSOrderedSame) {
        // 言語設定が日本語の場合
        baseFileName = @"introImg_ja_";
    } else {
        // 言語設定が日本語意外の場合
        baseFileName = @"introImg_en_";
    }
    // 画像ファイルの表示
    for (int i=0; i < kNumImages; i++) {
        UIImage* image = [UIImage imageNamed:
                          [NSString stringWithFormat:@"%@%d.png", baseFileName, i+1]];
        UIImageView *imgView;
        imgView = [[UIImageView alloc] initWithImage:image];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        imgView.center = CGPointMake(self.view.frame.size.width/2 + (self.view.frame.size.width * i) , self.view.frame.size.height/2);
        [scrollView addSubview:imgView];
    }
    [self.view addSubview:scrollView];
    [self.view addSubview:modalBtn];
    [self.view addSubview:pageControl];
  
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // ページコントロールの設定
    CGFloat pageWidth = scrollView.frame.size.width;
    pageControl.currentPage = floor((scrollView.contentOffset.x - pageWidth/2)/ pageWidth) + 1;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// ボタンアクション
- (void)modalBtnAction:(UIButton*)sender
{
    // モーダルを非表示
    ViewController* vc = (ViewController*)[self presentingViewController];
    [vc setBShowIntro:NO];
    [self dismissModalViewControllerAnimated:YES];
}

@end
