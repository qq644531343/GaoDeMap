//
//  FaceOverlay.m
//  CustomOverlayViewDemo
//
//  Created by songjian on 13-3-12.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "FaceOverlay.h"

@interface FaceOverlay ()

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite) MAMapRect boundingMapRect;

@property (nonatomic, readwrite) CLLocationCoordinate2D leftEyeCoordinate;
@property (nonatomic, readwrite) CLLocationCoordinate2D rightEyeCoordinate;
@property (nonatomic, readwrite) CLLocationDistance leftEyeRadius;
@property (nonatomic, readwrite) CLLocationDistance rightEyeRadius;

@end

@implementation FaceOverlay

@synthesize coordinate          = _coordinate;
@synthesize boundingMapRect     = _boundingMapRect;

@synthesize leftEyeCoordinate   = _leftEyeCoordinate;
@synthesize rightEyeCoordinate  = _rightEyeCoordinate;
@synthesize leftEyeRadius       = _leftEyeRadius;
@synthesize rightEyeRadius      = _rightEyeRadius;

#pragma mark - Utility

- (void)constructCoordinate
{
    self.coordinate = CLLocationCoordinate2DMake((self.leftEyeCoordinate.latitude + self.rightEyeCoordinate.latitude)   / 2.f,
                                                 (self.leftEyeCoordinate.longitude + self.rightEyeCoordinate.longitude) / 2.f);
}

- (void)constructBoundingMapRect
{
    CGRect leftEyeRect = [self rectForCenter:[self pointForMapPoint:MAMapPointForCoordinate(self.leftEyeCoordinate)]
                                      radius:self.leftEyeRadius * MAMapPointsPerMeterAtLatitude(self.leftEyeCoordinate.latitude)];
    CGRect rightEyeRect = [self rectForCenter:[self pointForMapPoint:MAMapPointForCoordinate(self.rightEyeCoordinate)]
                                       radius:self.rightEyeRadius * MAMapPointsPerMeterAtLatitude(self.rightEyeCoordinate.latitude)];
    
    CGRect unionRect = CGRectUnion(leftEyeRect, rightEyeRect);
    
    self.boundingMapRect = MAMapRectMake(unionRect.origin.x, unionRect.origin.y, unionRect.size.width, unionRect.size.height);
}

- (CGRect)rectForCenter:(CGPoint)center radius:(double)radius
{
    return CGRectMake(center.x - radius, center.y - radius, 2 * radius, 2 * radius);
}

- (CGPoint)pointForMapPoint:(MAMapPoint)mapPoint
{
    return CGPointMake(mapPoint.x, mapPoint.y);
}

#pragma mark - Static Methods

+ (id)faceWithLeftEyeCoordinate:(CLLocationCoordinate2D)leftEyeCoordinate
                  leftEyeRadius:(CLLocationDistance)leftEyeRadius
             rightEyeCoordinate:(CLLocationCoordinate2D)rightEyeCoordinate
                 rightEyeRadius:(CLLocationDistance)rightEyeRadius;
{
    FaceOverlay *faceOverlay = [[self alloc] init];
    
    faceOverlay.leftEyeCoordinate   = leftEyeCoordinate;
    faceOverlay.rightEyeCoordinate  = rightEyeCoordinate;
    faceOverlay.leftEyeRadius       = leftEyeRadius;
    faceOverlay.rightEyeRadius      = rightEyeRadius;
    
    [faceOverlay constructCoordinate];
    
    [faceOverlay constructBoundingMapRect];
    
    return faceOverlay;
}


@end
