//
//  HTMLData.m
//  PixelBrowser
//
//  Created by  on 12/02/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DrawData.h"
#import "HTMLParser.h"
#import "PixelObject.h"
#import <QuartzCore/QuartzCore.h>

#define kGreenThresh 3
#define kSnowThresh 10
#define kSampleNum 10

@implementation DrawData

@synthesize _URL,_title,_bFinish;

static id PODefArray;

+(NSMutableDictionary*)getPODef {
    
    return PODefArray;
    
}

+(void)setPODef:(NSMutableDictionary*)_arr {
    
    PODefArray = _arr;
    
}

- (id)init
{
    self = [super init];
    if( self )
    {
        rate = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"VerticalPixelSize"] intValue];
        _dataMax = 0;
        _n = [NSNotification notificationWithName:@"drawFinish" object:self];
        srand(time(NULL));
    }
    
    return self;
}

-(id)initWithSource:(NSString*)source
{
    self = [self init];
    if( self )
    {
        _source = [source copy];        
        
        [self parseHTML:source];
    }
    return self;
}

-(id)initWithWebview:(UIWebView*)webView
{
    self = [self init];
    if( self )
    {
        _webview = webView;
    }
    
    return self;
}

- (void)parseWebView
{
    _title = [_webview stringByEvaluatingJavaScriptFromString:@"document.title"];
    _URL = [_webview stringByEvaluatingJavaScriptFromString:@"document.URL"];
    _source = [_webview stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    //NSLog(@"%@",_source);
    _landArray = [[NSMutableArray alloc] init];
    _POArray = [[NSMutableArray alloc]init];
    //NSLog(@"%@",_source);
    [self parseHTML:_source];
    //source = [(DOMHTMLElement*)[[[webView mainFrame] DOMDocument] documentElement]outerHTML];    
    [self analyzeLand];
    [self createPO];
    [self drawImage];
    DLog(@"done!");
    _bFinish = YES;
    [[NSNotificationCenter defaultCenter] postNotification:_n];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)analyzeLand{
    NSInteger i = 0;
    
    NSMutableDictionary* flagDict = [NSMutableDictionary dictionary];
    [flagDict setObject:[NSNumber numberWithInteger:0] forKey:@"snowbase"];
    [flagDict setObject:[NSNumber numberWithInteger:0] forKey:@"sea"];
    [flagDict setObject:[NSNumber numberWithInteger:0] forKey:@"seatree"];
    [flagDict setObject:[NSNumber numberWithInteger:0] forKey:@"snowflat"];
    [flagDict setObject:[NSNumber numberWithInteger:0] forKey:@"fence"];
    [flagDict setObject:[NSNumber numberWithInteger:0] forKey:@"farm"];
    [flagDict setObject:[NSNumber numberWithInteger:0] forKey:@"updown"];
    [flagDict setObject:[NSNumber numberWithInteger:0] forKey:@"building"];
    
    NSUInteger aloneArray[3][3] = {{0,0,0},{0,0,0},{0,0,0}};
    NSUInteger noPlacedCount = 0;
    
    for (NSMutableArray* arr in _landArray) {
        memcpy(aloneArray[0],aloneArray[1],sizeof(aloneArray[1]));
        memcpy(aloneArray[1],aloneArray[2],sizeof(aloneArray[2]));
        aloneArray[2][0] = 0;
        aloneArray[2][1] = 0;
        aloneArray[2][2] = 0;
        for (int j = 0; j < [arr count]; j++){
            if (j < kGreenThresh + i % 2){
                [arr replaceObjectAtIndex:j withObject:[NSNumber numberWithInt:0]];
                aloneArray[2][0] += 1;
            }
            else if ((j >= kGreenThresh + i % 2 && j < kSnowThresh + i % 2)){
                [arr replaceObjectAtIndex:j withObject:[NSNumber numberWithInt:1]];
                aloneArray[2][1] += 1;
            }
            else if (j >= kSnowThresh + i % 2){
                [arr replaceObjectAtIndex:j withObject:[NSNumber numberWithInt:2]];
                aloneArray[2][2] += 1;
            }
        }
        //NSLog(@"%d%d%d",aloneArray[1][2],aloneArray[1][1],aloneArray[1][0]);
        
        if (i > 0){
            NSMutableArray* beforeArr = [_landArray objectAtIndex:i - 1];
            if (aloneArray[1][1] > 0 && aloneArray[1][1] < 3 && aloneArray[0][1] == 0 && aloneArray[2][1] == 0){
                for (int num = 1; num < aloneArray[1][1] + 1; num++){
                    [beforeArr replaceObjectAtIndex:[beforeArr count] - num withObject:[NSNumber numberWithInt:0]]; 
                }
            }
            if (aloneArray[1][2] > 0 && aloneArray[1][2] < 3 && aloneArray[0][2] == 0 && aloneArray[2][2] == 0){
                for (int num = 1; num < aloneArray[1][2] + 1; num++){
                    [beforeArr replaceObjectAtIndex:[beforeArr count] - num withObject:[NSNumber numberWithInt:1]]; 
                }
            }
        }
        
        if (i >= kSampleNum - 1){
            NSUInteger j = i - (kSampleNum - 1);
            NSArray* areaArr = [_landArray subarrayWithRange:NSMakeRange(j, kSampleNum)];
            NSUInteger n[kSampleNum] = { 0,0,0,0,0,0,0,0,0,0 };
            n[0] = [(NSMutableArray*)[areaArr objectAtIndex:0] count];
            n[1] = [(NSMutableArray*)[areaArr objectAtIndex:1] count];
            n[2] = [(NSMutableArray*)[areaArr objectAtIndex:2] count];
            n[3] = [(NSMutableArray*)[areaArr objectAtIndex:3] count];
            n[4] = [(NSMutableArray*)[areaArr objectAtIndex:4] count];
            n[5] = [(NSMutableArray*)[areaArr objectAtIndex:5] count];
            n[6] = [(NSMutableArray*)[areaArr objectAtIndex:6] count];
            n[7] = [(NSMutableArray*)[areaArr objectAtIndex:7] count];
            n[8] = [(NSMutableArray*)[areaArr objectAtIndex:8] count];
            n[9] = [(NSMutableArray*)[areaArr objectAtIndex:9] count];
            
            //sea
            if (n[0] == n[7] && n[1] == n[6] && n[2] == n[5] && n[3] == n[4] && n[0] == n[1] + 1 && n[1] == n[2] + 1 && n[2] == n[3] + 1){
                if (n[3] < 4){
                    [self addPOArray:POSea x:(j + 3) * rate y:(n[4] + 0) * rate index:0];
                    [self addPOArray:POSea x:(j + 4) * rate y:(n[3] + 0) * rate index:0];
                    [self addPOArray:POSea x:(j + 2) * rate y:(n[5] + 0) * rate index:1];
                    [self addPOArray:POSea x:(j + 3) * rate y:(n[4] + 1) * rate index:1];
                    [self addPOArray:POSea x:(j + 4) * rate y:(n[3] + 1) * rate index:1];
                    [self addPOArray:POSea x:(j + 5) * rate y:(n[2] + 0) * rate index:1];
                    
                    if (rand() % 4 == 0){
                        [self addPOArray:POBoat x:(j + 2) * rate y:n[1] * rate index:-1];
                        [self addPOArray:POTower x:(j + 1) * rate y:n[1] * rate index:2];
                    }
                    else{
                        [self addPOArray:POBridge x:(j + 1) * rate y:n[1] * rate index:-1];
                    }
                    [flagDict setObject:[NSNumber numberWithInteger:j] forKey:@"sea"];
                    noPlacedCount = 0;
                }
                if (n[3] >= 5 && n[3] < kSnowThresh){
                    [self addPOArray:POTree x:(j + 4) * rate y:n[4] * rate index:0];
                    [self addPOArray:POTree x:(j + 7.5) * rate y:n[7] * rate index:0];
                    [flagDict setObject:[NSNumber numberWithInteger:j] forKey:@"seatree"];
                    noPlacedCount = 0;
                }
            }
            
            //9block flat 
            if (n[8] == n[7] && n[7] == n[6] && n[6] == n[5] && n[5] == n[4] && n[4] == n[3] && n[3] == n[2] && n[2] == n[1] && n[1] == n[0] && [[flagDict objectForKey:@"building"] intValue] < j - 8){
                [self addPOArray:POBuilding x:j * rate y:(n[0]) * rate index:-1 ref:0];
                if (rand() % 3 == 0)
                    [self addPOArray:POTower x:(j + 2 + 2 * (rand() % 8) / 8) * rate y:(n[0]) * rate index:rand()%2];
                [flagDict setObject:[NSNumber numberWithInteger:j] forKey:@"building"];
                noPlacedCount = 0;
            }
            
            //4block flat 
            if (n[3] == n[2] && n[2] == n[1] && n[1] == n[0] && [[flagDict objectForKey:@"building"] intValue] < j - 8 && [[flagDict objectForKey:@"apart"] intValue] < j - 7){
                if (n[0] >= kSnowThresh + 2 && [[flagDict objectForKey:@"snowflat"] intValue] < j - 3){
                    [self addPOArray:POAnimal x:(j + 1 + (rand()%20) / 20 * 2) * rate y:n[0] * rate index:-1 ref:2];
                    [flagDict setObject:[NSNumber numberWithInteger:j] forKey:@"snowflat"];
                    noPlacedCount = 0;
                }
                if (n[0] >= 5 && n[0] < kSnowThresh && [[flagDict objectForKey:@"fence"] intValue] < j - 3){
                    if (rand() % 3 == 0) [self addPOArray:POFarm x:(j + (rand() % 3) / 3.0) * rate y:n[0] * rate index:0];
                    [self addPOArray:POCow x:(j + 1 + (rand() % 25) / 10.0) * rate y:n[0] * rate index:-1 ref:2];
                    [self addPOArray:POFence x:j * rate y:n[0] * rate z:2 index:-1 ref:0];
                    [flagDict setObject:[NSNumber numberWithInteger:j] forKey:@"fence"];
                    noPlacedCount = 0;
                }
                if (n[0] >= kGreenThresh && n[0] < 5 && [[flagDict objectForKey:@"farm"] intValue] < j - 3){
                    [self addPOArray:POHouse x:(j + 1) * rate y:(n[0]) * rate index:-1];
                    [self addPOArray:POFarm x:(j + 1.5) * rate y:n[0] * rate index:1];
                    [flagDict setObject:[NSNumber numberWithInteger:j] forKey:@"farm"];
                    noPlacedCount = 0;
                }
                if (n[0] < kGreenThresh){
                    [self addPOArray:POSafariTree x:(j + 2 + ((rand() % 10) / 20.0)) * rate y:(n[0]) * rate index:-1 ref:2];
                    if (rand() % 2 == 0){
                        [self addPOArray:POSafari x:(j + 0.5 + ((rand() % 20) / 20.0)) * rate y:(n[0]) * rate index:-1 ref:2];
                    }
                    if (rand() % 3 == 0){
                        [self addPOArray:POHuman x:(j + 0.5 + ((rand() % 20) / 20.0)) * rate y:(n[0]) * rate index:0 ref:2];
                    }
                    noPlacedCount = 0;
                }
            }
            
            //upddown
            if (((n[4] == n[3] + 1 && n[3] == n[2] + 1 && n[2] == n[1] + 1 && n[1] == n[0] + 1 && n[4] < 12) ||
                 (n[4] == n[3] - 1 && n[3] == n[2] - 1 && n[2] == n[1] - 1 && n[1] == n[0] - 1 && n[4] < 12))
                && [[flagDict objectForKey:@"updown"] intValue] < j - 4){
                NSUInteger treenum = 3;
                if (n[1] == n[8] && n[2] == n[7] && n[3] == n[6] && n[4] == n[5]) treenum = 2;
                for (int k = 0; k < treenum; k++){
                    //float posx = (rand() % 200) / 200.0;
                    if ([[flagDict objectForKey:@"sea"] intValue] < j + k - 4 &&  [[flagDict objectForKey:@"seatree"] intValue] != j + k - 6){
                        [self addPOArray:POTree x:(j + 1.5 + k) * rate - 2 y:(n[1 + k]) * rate index:1];
                    }
                }
                [flagDict setObject:[NSNumber numberWithInteger:j] forKey:@"updown"];
                noPlacedCount = 0;
            }
            
            //house //snow base 2+2
            if (n[3] == n[2] && n[1] == n[0] && n[2] == n[1] + 1){
                if (n[3] > kGreenThresh && n[3] < kSnowThresh - 2){
                    //[self addPOArray:POHouse x:(i - 2.5 + ((rand() % 20) / 20.0)) * rate y:(n[4]) * rate index:-1];
                    [self addPOArray:POHouse x:(j + 1) * rate y:(n[0]) * rate index:-1];
                    noPlacedCount = 0;
                }
                if (n[3] > kSnowThresh + 1){
                    [self addPOArray:POHouse x:(j + 1) * rate y:(n[0]) * rate index:-1];
                    if (rand() % 3 == 0) [self addPOArray:POHuman x:(j + 1)*rate y:n[0] * rate index:1];
                    noPlacedCount = 0;
                }
            }
            
            //apart 1+6+1
            if (n[6] == n[5] && n[5] == n[4] && n[4] == n[3] && n[3] == n[2] && n[2] == n[1] && n[7] == n[0] && (n[1] == n[0] + 1 || n[1] == n[0] - 1)){
                [self addPOArray:POApart x:(j + 1) * rate + 3 y:(n[2]) * rate index:-1 ref:0];
                [flagDict setObject:[NSNumber numberWithInteger:j] forKey:@"apart"];
                noPlacedCount = 0;
            }
                        
            //rainbow
            if (n[7] == n[6] + 1 && n[6] == n[0] && n[7] > 6 && rand() % 200 == 0){
                [self addPOArray:PORainbow x:j * rate y:(n[6]) * rate index:-1 ref:0];
                noPlacedCount = 0;
            }
            
            
            //human
            //if (
            
            //animal
            
            if (noPlacedCount > 10){
                if (n[0] > kGreenThresh && n[0] < kSnowThresh && rand() % 20 > 12){
                    [self addPOArray:POTree x:(j + 0.5) * rate y:n[0] * rate index:1];
                }
                if (n[0] < kGreenThresh){
                    if (rand() % 20 > 12)
                        [self addPOArray:POSafariTree x:(j + 0.5) * rate y:n[0] * rate index:-1 ref:2];
                    else if (rand() % 20 > 12)
                        [self addPOArray:POSafari x:(j + 0.5) * rate y:n[0] * rate index:-1 ref:2];
                }
            }
            noPlacedCount++;

        }
        i++;
	}
    

}

//POArrayを作る一番重いメソッド
-(void)createPO{
    NSUInteger i = 0;
    NSUInteger frameHeight = 20;
    if (_dataMax + 4 > frameHeight) frameHeight = _dataMax + 4;
    for (NSMutableArray* arr in _landArray) {
        NSInteger height = [arr count];
        
        //Cloud
        if (rand()%20 == 0 && i > 5 && i < [_landArray count] - 6){
            [self addPOArray:POCloud x:(i + 0.5) * rate y:(height + (frameHeight - height) * (0.3 + 0.4 * (rand() % 20) / 20.0)) * rate index:-1];
        }
        
        //plane
        if (rand()%300 == 0 && height < frameHeight / 2){
            NSUInteger dir = rand() % 2;
            NSUInteger planeHieght = frameHeight * 0.7f + (rand()%30)/10.0;
            [self addPOArray:POBird x:(i + 0.5) * rate y:planeHieght * rate index:-1 ref:dir];
            if (rand() % 3 == 0)
                [self addPOArray:POBird x:(i + 1.5) * rate y:(planeHieght + (1-(rand()%2)*2) * 2) * rate index:-1 ref:dir];
                
        }
        i++;
    }
}

-(void)addPOArray:(POType)_type
                x:(NSInteger)_x
                y:(NSInteger)_y
            index:(NSInteger)_index
{
    [self addPOArray:_type x:_x y:_y z:1 index:_index ref:0];
}

-(void)addPOArray:(POType)_type
                x:(NSInteger)_x
                y:(NSInteger)_y
            index:(NSInteger)_index
              ref:(NSUInteger)_ref
{
    [self addPOArray:_type x:_x y:_y z:1 index:_index ref:_ref];
}

-(void)addPOArray:(POType)_type
                x:(NSInteger)_x
                y:(NSInteger)_y
                z:(NSInteger)_z
            index:(NSInteger)_index
              ref:(NSUInteger)_ref
{
    NSInteger pos = _index;
    if (_index < 0)
        pos = (rand() % [(NSMutableArray*)[(NSMutableDictionary*)PODefArray objectForKey:[NSNumber numberWithInt:_type]] count]);
    
    [_POArray addObject:[[PixelObject alloc]initWithDef:[(NSMutableArray*)[(NSMutableDictionary*)PODefArray objectForKey:[NSNumber numberWithInt:_type]] objectAtIndex:pos] x:_x y:_y z:_z ref:_ref]];
}

-(void)drawImage{
    NSUInteger landSize = 8;
    NSUInteger height = 160;
    if (_dataMax > height / landSize - 4)
        height = (_dataMax + 4) * landSize;
    NSUInteger width = (_landArray.count+10) * landSize;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    //self.backgroundColor = [UIColor colorWithRed:128/255.0f green:206/255.0f blue:195/255.0f alpha:1.0f];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);  
    
    CGContextSetRGBFillColor(ctx, 128/255.0f, 206/255.0f, 195/255.0f, 1.0);
    CGContextFillRect(ctx, CGRectMake(0,0,width,height));
    
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
    
    UIImage* groundImage = [UIImage imageNamed:@"ground_05.png"];
    UIImage* greenImage = [UIImage imageNamed:@"green_05.png"];
    UIImage* snowImage = [UIImage imageNamed:@"snow_05.png"];
    
    UIColor *groundColor = [[UIColor alloc] initWithPatternImage:groundImage];
    UIColor *greenColor = [[UIColor alloc] initWithPatternImage:greenImage];
    UIColor *snowColor = [[UIColor alloc] initWithPatternImage:snowImage];
    
    Boolean bBig = NO;
    if (height > 160) bBig = NO;
    NSInteger i = 0;
    for (NSMutableArray* hArray in _landArray) {
        NSInteger j = 0;
        
        NSInteger preType = -1;
        NSUInteger startNum = 0;
        for (NSNumber* value in hArray){
            //NSLog(@"aa");
            NSUInteger curType = [value intValue];
            if (preType != curType){
                if (preType != -1){
                    CGContextFillRect(ctx, CGRectMake(i * landSize, height - (j) * landSize, landSize, (j - startNum) * landSize));
                    startNum = j;
                }
                switch (curType) {
                    case 0:
                        if (!bBig)
                            CGContextSetFillColorWithColor(ctx, groundColor.CGColor);
                        else
                            CGContextSetRGBFillColor(ctx, 164/255.0, 121/255.0, 71/255.0, 1.0);
                        break;
                    case 1:
                        if (!bBig)
                            CGContextSetFillColorWithColor(ctx, greenColor.CGColor);
                        else
                            CGContextSetRGBFillColor(ctx, 31/255.0, 140/255.0, 60/255.0, 1.0);
                        break;
                    case 2:
                        if (!bBig)
                            CGContextSetFillColorWithColor(ctx, snowColor.CGColor);
                        else
                            CGContextSetRGBFillColor(ctx, 222/255.0, 212/255.0, 192/255.0, 1.0);
                        break;
                    default:
                        break;
                }
            }
            //CGContextFillRect(ctx, CGRectMake(i * landSize, height - (j + 1) * landSize, landSize, landSize));
            preType = curType;
            j++;
        }
        if (preType != -1){
            CGContextFillRect(ctx, CGRectMake(i * landSize, height - (j) * landSize, landSize, (j - startNum) * landSize));
        }
        i++;
	}
    
    //pixel object を使わない場合のプレ描画処理
    //LandviewのsetPOdataAreaから流用
    for (PixelObject* obj in _POArray) {
        NSInteger reverse = 1;
        if (obj.ref == 1) reverse = -1;
        if (obj.ref == 2) reverse = 1 - (rand() % 2 * 2);
        UIImage *image;
        if (reverse == -1)
            image = [self mirrorImage:obj.def.img];
        else
            image = obj.def.img;
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        frame.origin = CGPointMake((NSInteger)(obj.x / 2.0 - obj.def.offset), (NSInteger)(height - obj.y / 2.0 + obj.def.baseLine - obj.def.height));
        [image drawInRect:frame];
        
        //CGAffineTransform affine = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0); 
        //affine.ty = image.size.height + frame.origin.y*2.0 ;
        //CGContextConcatCTM(ctx, affine);
        //CGContextDrawImage(ctx, frame, [image CGImage]);
        
	}

    
    _uiimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); 
    DLog(@"draw done:Size = %f:%f",_uiimage.size.width,_uiimage.size.height);
    //_image = newImage.CGImage;
    //_landArray = [[NSMutableArray alloc]init ];
    _POArray = [[NSMutableArray alloc]init ];
}

- (UIImage *)mirrorImage:(UIImage *)img{
    CGImageRef imgRef = [img CGImage]; // 画像データ取得
    UIGraphicsBeginImageContext(img.size); // 開始
    CGContextRef context = UIGraphicsGetCurrentContext(); // コンテキスト取得
    CGContextTranslateCTM( context, img.size.width, img.size.height); // コンテキストの原点変更
    CGContextScaleCTM( context, -1.0, -1.0); // コンテキストの軸をXもYも等倍で反転
    CGContextDrawImage( context, CGRectMake( 0, 0, img.size.width, img.size.height), imgRef);// コンテキストにイメージを描画
    UIImage *retImg = UIGraphicsGetImageFromCurrentImageContext();// コンテキストからイメージを取得
    UIGraphicsEndImageContext(); // 終了
    return retImg;
}

-(void)parseHTML:(NSString*)source
{
    _dataMax = 0;
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:source error:&error];
    
    if (error) {
        DLog(@"Error: %@", error);
        return;
    }
    
    HTMLNode *bodyNode = [parser body];
    
    [self parseElem:bodyNode nodeLevel:0];
}

-(void)parseElem:(HTMLNode*)elem
       nodeLevel:(NSInteger)level
{
    if (_dataMax < level){
        _dataMax = level;
    }

    /*
    if ([elem tagName] != NULL)
        NSLog(@"%d:%@",level,[elem tagName]);
    else
        NSLog(@"%d",level);
     */
    NSMutableArray* array = [[NSMutableArray alloc]init];
    for (int i = 0; i < level; i++) [array addObject:[NSNumber numberWithInt:0]];
    [_landArray addObject:array];
    
    if ([[elem childrenNotext] count] > 0){
        for(HTMLNode *childNode in [elem childrenNotext]){
            [self parseElem:childNode nodeLevel:level+1];
        }
        //NSLog(@"%d",level);
        NSMutableArray* array = [[NSMutableArray alloc]init];
        for (int i = 0; i < level; i++) [array addObject:[NSNumber numberWithInt:0]];
        [_landArray addObject:array];
    }
}

-(NSMutableArray*)getLandData{
    return _landArray;
}

-(NSMutableArray*)getPOData{
    return _POArray;
}

-(NSUInteger)getMax{
    return _dataMax;
}

-(CGImageRef)getImage{
    return _image;
}

-(UIImage*)getUIImage{
    return _uiimage;
}

@end
