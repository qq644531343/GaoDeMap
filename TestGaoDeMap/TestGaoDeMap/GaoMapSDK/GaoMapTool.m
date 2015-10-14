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

+(NSString *)secondsToFormatString:(NSInteger)seconds
{
    if (seconds < 60) {
        return [NSString stringWithFormat:@"%ld秒",seconds];
    }else if(seconds < 60*60){
        return [NSString stringWithFormat:@"%ld分钟",seconds/60];
    }else if(seconds < 60*60*24){
        NSInteger hour = seconds / (60*60);
        NSInteger minute = (seconds % (60*60))/60;
        return [NSString stringWithFormat:@"%ld小时%ld分钟",hour,minute];
    }else {
        NSInteger days = seconds / (60*60*24);
        NSInteger hours = seconds % (60*60*24) / (60*60);
        return [NSString stringWithFormat:@"%ld天%ld小时",days,hours];
    }
    return nil;
}

+(NSString *)meterToFormatString:(NSInteger)meter
{
    if (meter < 1000) {
        return [NSString stringWithFormat:@"%ld米",meter];
    }else {
        return [NSString stringWithFormat:@"%.1f公里",meter/1000.0];
    }
    return nil;
}

+(NSString *)generateBusline:(AMapTransit *)transit
{
    
    NSMutableString *str = [[NSMutableString alloc] init];
    
    for (AMapSegment *seg in transit.segments) {
        NSMutableString *aStep = [[NSMutableString alloc] init];
        for (AMapBusLine *line in seg.buslines) {
            
            NSMutableString *lineName = [NSMutableString stringWithString:line.name];
            [self deleteStopNames:lineName];
            [aStep appendFormat:@"%@/",lineName];
        }
        if (aStep.length > 0) {
            [aStep deleteCharactersInRange:NSMakeRange(aStep.length - 1, 1)];
        }else {
            continue;
        }
        [str appendFormat:@"%@ - ",aStep];
    }
    
    if (str.length > 3) {
        [str deleteCharactersInRange:NSMakeRange(str.length - 3, 3)];
    }
    
    return str;
}

//删除路线中的站点信息
+(void)deleteStopNames:(NSMutableString *)names
{
    if ([names isKindOfClass:[NSMutableString class]]) {
        NSRange rangeleft = [names rangeOfString:@"("];
        NSRange rangeright = [names rangeOfString:@")"];
        if (rangeleft.location != NSNotFound && rangeright.location != NSNotFound && rangeleft.location < rangeright.location) {
            [names deleteCharactersInRange:NSMakeRange(rangeleft.location, rangeright.location+1-rangeleft.length-rangeleft.location + 1)];
        }
    }
}

@end
