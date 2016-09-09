//
//  GaoMapConfig.h
//  TestGaoDeMap
//
//  Created by libo on 15/9/18.
//  Copyright (c) 2015年 libo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class GaoMapView;

/**
 *  配置
 */

@interface GaoMapConfig : NSObject

+(instancetype)sharedConfig;

/**
 *  初始化设置
 */
-(void)setup;

//高德云图标识
@property (nonatomic,readonly,strong) NSString *tableId;

/**
 *  由于高德地图map对象同时存在两个时会崩溃，所以对map对象进行复用
 *  http://lbsbbs.amap.com/forum.php?mod=viewthread&tid=10149&highlight=%E5%B4%A9%E6%BA%83
 */
-(GaoMapView *)getMapViewWithFrame:(CGRect)frame;

@end
