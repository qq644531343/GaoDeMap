//
//  GaoBaseAnnotation.h
//  TestGaoDeMap
//
//  Created by libo on 15/9/21.
//  Copyright (c) 2015年 libo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapNaviKit/MAMapKit.h>

@protocol MAAnnotation;

/**
 *  标注数据模型基础类
 */

@interface GaoBaseAnnotation : NSObject <MAAnnotation>

/*!
 @brief 标注view中心坐标
 */
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@property (nonatomic ,strong) NSString *title;

@property (nonatomic ,strong) NSString *subtitle;

@end
