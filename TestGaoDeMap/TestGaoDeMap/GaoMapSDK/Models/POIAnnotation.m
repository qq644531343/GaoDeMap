//
//  POIAnnotation.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-16.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "POIAnnotation.h"

@interface POIAnnotation ()

@end

@implementation POIAnnotation

#pragma mark - MAAnnotation Protocol

#pragma mark - Life Cycle

- (id)initWithPOI:(AMapPOI *)poi
{
    if (self = [super init])
    {
        self.poi = poi;
    }
    
    return self;
}

-(id)initWithTip:(AMapTip *)tip
{
    if (self = [super init]) {
        AMapPOI *poi = [[AMapPOI alloc] init];
        poi.uid = tip.uid;
        poi.name = tip.name;
        poi.adcode = tip.adcode;
        poi.district = tip.district;
        poi.location = tip.location;
        self.poi = poi;
    }
    return self;
}

-(void)setPoi:(AMapPOI *)poi
{
    _poi = poi;
    self.title = self.poi.name;
    self.subtitle = self.poi.address;
    self.coordinate =  CLLocationCoordinate2DMake(self.poi.location.latitude, self.poi.location.longitude);
}

@end
