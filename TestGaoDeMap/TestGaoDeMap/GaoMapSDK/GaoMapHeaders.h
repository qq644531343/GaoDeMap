//
//  GaoMapHeaders.h
//  TestGaoDeMap
//
//  Created by libo on 15/9/18.
//  Copyright (c) 2015年 libo. All rights reserved.
//

#ifndef TestGaoDeMap_GaoMapHeaders_h
#define TestGaoDeMap_GaoMapHeaders_h

#import <CoreLocation/CoreLocation.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapNaviKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapCloudKit/AMapCloudAPI.h>

#import "GaoMapConfig.h"
#import "GaoMapView.h"
#import "GaoMapTool.h"
#import "GaoMapManager.h"
#import "GaoMapSearchManager.h"
#import "GaoBaseAnnotationView.h"
#import "POIAnnotation.h"
#import "GaoPOIAnnotationView.h"

//  a54da15acea702a9c1c3209c9ce38d56
//9fa23e2da3ea9ff665e68b2c72bcec3e
#define GAO_APP_KEY @"9fa23e2da3ea9ff665e68b2c72bcec3e"

#define GAO_CLOUD_TABLEID   @"562d9ad7e4b038b7115c26ad"

//搜索通用半径 5000m
#define GAO_BASE_RADIUS 5000

//屏幕尺寸
#define GAO_SIZE  [[UIScreen mainScreen] bounds].size

//颜色转换
#define GaoColorWithRGB(rgbValue) [UIColor                                                    \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0     \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//格式化日志输出
#define XLog(fmt, ...) NSLog((@"GAO: %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#endif
