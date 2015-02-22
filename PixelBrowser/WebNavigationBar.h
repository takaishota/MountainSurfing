//
//  WebNavigationBar.h
//  MountainSurfing
//
//  Created by  on 12/03/28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebNavigationBar : UINavigationBar{
    //NSString* text;
    //NSString* prompt;
    UITextField *TFurl;
    //UISearchBar *TFsearch;
    UILabel *promptLabel;
}

@property (nonatomic,assign,setter = setText:,getter = getText)NSString *text;
@property (nonatomic,retain,setter = setPrompt:,getter = getPrompt)NSString *prompt;

@property (nonatomic,retain)UITextField* TFurl;
//@property (nonatomic,retain)UISearchBar* TFsearch;


@end
