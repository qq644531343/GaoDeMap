//
//  GaoMapTool.h
//  TestGaoDeMap
//
//  Created by libo on 15/9/29.
//  Copyright (c) 2015年 libo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class GaoMapView;

/**
 *  地图工具
 */

@interface GaoMapTool : NSObject

/**
 *  地图截屏
 */

+(UIImage *)takeSnapInMap:(GaoMapView *)map rect:(CGRect)rect;

/**
 *  计算两经纬度的距离
 *  lat纬度  lon经度
 *  @return 单位米
 */
double getDistance(double lat1, double lon1, double lat2, double lon2);

@end
