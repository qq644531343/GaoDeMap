//
//  POIAnnotation.h
//  SearchV3Demo
//
//  Created by songjian on 13-8-16.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <AMapNaviKit/MAMapKit.h>
#import <AMapSearchKit/AMapCommonObj.h>

/**
 *  POI标注
 */

@interface POIAnnotation : NSObject <MAAnnotation>

- (id)initWithPOI:(AMapPOI *)poi;

- (id)initWithTip:(AMapTip *)tip;

@property (nonatomic, strong) AMapPOI *poi;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic ,strong) NSString *title;

@property (nonatomic ,strong) NSString *subtitle;

/**
 *  标记
 **/
@property (nonatomic, readwrite) NSUInteger tag;

@end
