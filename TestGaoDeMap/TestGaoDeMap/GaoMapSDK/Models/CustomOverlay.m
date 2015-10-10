//
//  CustomOverlay.m
//  DevDemo2D
//
//  Created by 刘博 on 14-1-16.
//  Copyright (c) 2014年 xiaoming han. All rights reserved.
//

#import "CustomOverlay.h"

@interface CustomOverlay ()

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite) MAMapRect boundingMapRect;
@property (nonatomic, readwrite) CLLocationDistance radius;

@end

@implementation CustomOverlay

@synthesize coordinate      = _coordinate;
@synthesize boundingMapRect = _boundingMapRect;
@synthesize radius          = _radius;

#pragma mark - Initalize

- (id)initWithCenter:(CLLocationCoordinate2D)center radius:(CLLocationDistance)radius
{
    if (self = [super init])
    {
        self.coordinate     = center;
        self.radius         = radius;
        
        MAMapPoint point    = MAMapPointForCoordinate(center);
        double width_2      = MAMapPointsPerMeterAtLatitude(center.latitude) * radius;
        
        self.boundingMapRect = MAMapRectMake(point.x - width_2, point.y - width_2, width_2 * 2, width_2 * 2);
    }
    
    return self;
}

@end
