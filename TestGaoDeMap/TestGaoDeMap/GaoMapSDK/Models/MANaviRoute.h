//
//  MANaviRoute.h
//  OfficialDemo3D
//
//  Created by yi chen on 1/7/15.
//  Copyright (c) 2015 songjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapNaviKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "MANaviAnnotation.h"
#import "GaoNaviPolyline.h"
#import "LineDashPolyline.h"

/**
 *  用于显示路线方案
 */

@interface MANaviRoute : NSObject

@property (nonatomic, strong) NSArray *routePolylines;
@property (nonatomic, strong) NSArray *naviAnnotations;
@property (nonatomic, strong) UIColor *routeColor;
@property (nonatomic, strong) UIColor *walkingColor;

- (void)addToMapView:(MAMapView *)mapView;

- (void)removeFromMapView;

- (void)setNaviAnnotationVisibility:(BOOL)visible;

+ (instancetype)naviRouteForTransit:(AMapTransit *)transit;
+ (instancetype)naviRouteForPath:(AMapPath *)path withNaviType:(MANaviAnnotationType)type;
+ (instancetype)naviRouteForPolylines:(NSArray *)polylines andAnnotations:(NSArray *)annotations;

- (instancetype)initWithTransit:(AMapTransit *)transit;
- (instancetype)initWithPath:(AMapPath *)path withNaviType:(MANaviAnnotationType)type;
- (instancetype)initWithPolylines:(NSArray *)polylines andAnnotations:(NSArray *)annotations;

@end
