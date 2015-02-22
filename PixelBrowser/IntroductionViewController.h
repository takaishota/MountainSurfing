//
//  IntroductionViewController.h
//  MountainSurfing
//
//  Created by Takai Shota on 13/01/09.
//
//

#import <UIKit/UIKit.h>

@interface IntroductionViewController : UIViewController <UIScrollViewDelegate> {
}

@property (nonatomic,retain)UIScrollView *scrollView;
@property (nonatomic,retain)UIPageControl *pageControl;

- (void)modalBtnAction:(UIButton*)sender;

@end
