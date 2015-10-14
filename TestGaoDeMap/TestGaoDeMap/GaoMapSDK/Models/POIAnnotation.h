//
//  POIAnnotation.h
//  SearchV3Demo
//
//  Created by songjian on 13-8-16.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <AMapNaviKit/MAMapKit.h>
#import <AMapSearchKit/AMapCommonObj.h>
#import "GaoBaseAnnotation.h"

/**
 *  POI标注
 */

@interface POIAnnotation : GaoBaseAnnotation

- (id)initWithPOI:(AMapPOI *)poi;

- (id)initWithTip:(AMapTip *)tip;

@property (nonatomic, strong) AMapPOI *poi;

/**
 *  标记
 **/
@property (nonatomic, readwrite) NSUInteger tag;

@end
