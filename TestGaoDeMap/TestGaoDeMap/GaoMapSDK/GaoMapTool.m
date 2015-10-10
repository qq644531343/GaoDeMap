//
//  GaoMapTool.m
//  TestGaoDeMap
//
//  Created by libo on 15/9/29.
//  Copyright (c) 2015年 libo. All rights reserved.
//

#import "GaoMapTool.h"
#import "GaoMapHeaders.h"

@implementation GaoMapTool

+(UIImage *)takeSnapInMap:(GaoMapView *)map rect:(CGRect)rect
{
    return [map takeSnapshotInRect:rect];
}

double getDistance(double lat1, double lon1, double lat2, double lon2)
{
    //1.将两个经纬度点转成投影点
    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(lat1,lon1));
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(lat2,lon2));
    
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    return distance;
}


@end
