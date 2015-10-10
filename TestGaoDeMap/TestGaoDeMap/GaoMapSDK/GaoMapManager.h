//
//  GaoMapManager.h
//  TestGaoDeMap
//
//  Created by libo on 15/9/29.
//  Copyright (c) 2015年 libo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapNaviKit/MAMapKit.h>

typedef void(^SelectedAnnotation)(id<MAAnnotation> annotation,MAAnnotationView *annotationView);

@class GaoMapView;
@class GaoBaseAnnotationView;

/**
 *  地图管理工具
 *  主要处理地图代理、浮层等
 */

@interface GaoMapManager : NSObject <MAMapViewDelegate>

+(GaoMapManager *)getMapManager;

@property (nonatomic , weak) GaoMapView *map;

@property (nonatomic, weak) GaoBaseAnnotationView *selectAnnotationView;

/**
 *  Annotation点击响应
 */
@property (nonatomic, copy) SelectedAnnotation clickedAnnotation;

/**
 *  当前位置Annotation
 */
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;

/**
 *  聚焦用户所在地
 */
-(void)showUserLocationPoint;

@end
