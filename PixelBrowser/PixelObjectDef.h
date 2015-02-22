//
//  PixelObjectDef.h
//  MountainSurfing
//
//  Created by  on 12/02/17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
	POHuman,
	POCar,
	POBird,
	POFish,
	POHouse,
    POApart,
    POBuilding,
	POBridge,
	POTree,
	POSafari,
	POCow,
	POCloud,
	POStar,
    POFence,
    POTower,
    POSea,
    POSafariTree,
    PORainbow,
    POBoat,
    POAnimal,
    POFarm,
	POEtc
} POType;

@interface PixelObjectDef : NSObject
{
    //@private
    NSUInteger width;
    NSUInteger height;
    POType type;
    NSString* name;
    NSInteger baseLine;
    NSInteger offset;
    UIImage* img;
}

@property (nonatomic,assign)NSUInteger width;
@property (nonatomic,assign)NSUInteger height;
@property (nonatomic,assign)POType type;
@property (nonatomic,assign)NSInteger baseLine;
@property (nonatomic,assign)NSInteger offset;
@property (nonatomic,retain)UIImage* img;

-(id) initWithType:(POType)_type
             Width:(NSUInteger)_width
            Height:(NSUInteger)_height
             Image:(UIImage*)_img
              Name:(NSString*)_name
          BaseLine:(NSInteger)_baseLine
          Offset:(NSInteger)_offSet;

-(id) initWithType:(POType)_type
             Image:(UIImage*)_img
          BaseLine:(NSInteger)_baseLine
            Offset:(NSInteger)_offSet;

-(id) initWithType:(POType)_type
             Image:(UIImage*)_img
          BaseLine:(NSInteger)_baseLine;

-(id) initWithType:(POType)_type
             Image:(UIImage*)_img
          BaseLine:(NSInteger)_baseLine
         Centering:(bool)_bCenter;

@end
