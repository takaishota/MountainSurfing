//
//  WebNavigationBar.m
//  MountainSurfing
//
//  Created by  on 12/03/28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WebNavigationBar.h"
#import <QuartzCore/QuartzCore.h>

@implementation WebNavigationBar

@synthesize prompt;
@synthesize TFurl;//,TFsearch;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        TFurl = [[UITextField alloc] initWithFrame:CGRectMake(8, 22, 304, 30)];
        TFurl.placeholder = NSLocalizedString(@"Search Keyword or URL","");
        TFurl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        TFurl.borderStyle = UITextBorderStyleRoundedRect;
        TFurl.font = [UIFont systemFontOfSize:15];
        TFurl.textColor = [UIColor darkGrayColor];
        TFurl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        TFurl.returnKeyType = UIReturnKeyGo;
        TFurl.keyboardType = UIKeyboardTypeURL;
        TFurl.clearButtonMode = UITextFieldViewModeWhileEditing;
        TFurl.autocapitalizationType = UITextAutocapitalizationTypeNone;
        TFurl.autocorrectionType = UITextAutocorrectionTypeNo;

        [self addSubview:TFurl];
        
        promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 6, 300, 12)];
        promptLabel.textAlignment = UITextAlignmentCenter;
        promptLabel.font = [UIFont boldSystemFontOfSize:12];
        promptLabel.backgroundColor = [UIColor clearColor];
        promptLabel.textColor = [UIColor colorWithRed:60/255.0 green:70/255.0 blue:81/255.0 alpha:1];
        promptLabel.shadowColor = [UIColor colorWithRed:193/255.0 green:203/255.0 blue:216/255.0 alpha:1];
        promptLabel.shadowOffset = CGSizeMake(0, 1);
        [self addSubview:promptLabel];
        
        /*
        TFsearch = [[UISearchBar alloc] initWithFrame:CGRectMake(210, 22, 105, 30)];
        TFsearch.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        TFsearch.keyboardType = UIKeyboardTypeDefault;
        //TFsearch.
        TFsearch.placeholder = @"Google";
        //TFsearch.delegate = 
        
        for (UIView *v in TFsearch.subviews) {
            if ([NSStringFromClass(v.class) isEqualToString:@"UISearchBarBackground"]) {
                [v removeFromSuperview];
            }
            if ([NSStringFromClass(v.class) isEqualToString:@"UISearchBarTextField"]) {
                UIView *nilView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
                ((UITextField *)v).leftView = nilView;
            }

        }
        //UIView *backView = [TFsearch.subviews objectAtIndex:0];
        //backView.hidden = YES;
        [self addSubview:TFsearch];
         */
        
    }
    return self;
}


-(void)setText:(NSString *)text_{
    //self.text = text;
    TFurl.text = text_;
}

-(NSString*)getText{
    return TFurl.text;
}

-(void)setPrompt:(NSString *)prompt_{
    //self.text = text;
    promptLabel.text = prompt_;
}

-(NSString*)getPrompt{
    return promptLabel.text;
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
