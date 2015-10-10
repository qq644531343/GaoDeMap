//
//  FaceOverlay.h
//  CustomOverlayViewDemo
//
//  Created by songjian on 13-3-12.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <AMapNaviKit/MAMapKit.h>

/**
 *  圆形覆盖物
 */

@interface FaceOverlay : MAShape<MAOverlay>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, readonly) MAMapRect boundingMapRect;

+ (id)faceWithLeftEyeCoordinate:(CLLocationCoordinate2D)leftEyeCoordinate
                  leftEyeRadius:(CLLocationDistance)leftEyeRadius
             rightEyeCoordinate:(CLLocationCoordinate2D)rightEyeCoordinate
                 rightEyeRadius:(CLLocationDistance)rightEyeRadius;

@property (nonatomic, readonly) CLLocationCoordinate2D leftEyeCoordinate;
@property (nonatomic, readonly) CLLocationCoordinate2D rightEyeCoordinate;
@property (nonatomic, readonly) CLLocationDistance leftEyeRadius;
@property (nonatomic, readonly) CLLocationDistance rightEyeRadius;

@end
