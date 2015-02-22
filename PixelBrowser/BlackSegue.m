//
//  BlackSegue.m
//  PixelBrowser
//
//  Created by  on 12/02/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BlackSegue.h"

@implementation BlackSegue

- (void)perform {
    UIViewController *sourceViewController = (UIViewController *)self.sourceViewController;
    UIViewController *destinationViewController = (UIViewController *)self.destinationViewController;
    
    /*
    [UIView transitionWithView:sourceViewController.view
                      duration:2.0
                       options:UIModalTransitionStyleCrossDissolve
                    animations:^{
                        [sourceViewController presentModalViewController:destinationViewController animated:NO];
                    }
                    completion:NULL];
     */
    /*
    destinationViewController.view.alpha = 0.0;
    destinationViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve; 
    [sourceViewController presentModalViewController:destinationViewController animated:NO];
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration:1.0];
    sourceViewController.view.alpha = 0.0;
    [UIView setAnimationDuration:6.0];
    destinationViewController.view.alpha = 1.0;
    [UIView commitAnimations];
*/
    
    destinationViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve; 
    [sourceViewController presentModalViewController:destinationViewController animated:YES];
     
}

@end
