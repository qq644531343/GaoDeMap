//
//  GaoMapManager.m
//  TestGaoDeMap
//
//  Created by libo on 15/9/29.
//  Copyright (c) 2015年 libo. All rights reserved.
//

#import "GaoMapManager.h"
#import "GaoMapHeaders.h"
#import "CusAnnotationView.h"

#import "MANaviPolyline.h"

@implementation GaoMapManager

+(GaoMapManager *)getMapManager
{
    return [[GaoMapManager alloc] init];
}

-(void)setSelectAnnotationView:(GaoBaseAnnotationView *)selectAnnotation
{
    _selectAnnotationView.color = GaoAnnoColorBlue;
    _selectAnnotationView = selectAnnotation;
    selectAnnotation.color = GaoAnnoColorRed;
}

#pragma mark - Annotation

/*!
 @brief 根据anntation生成对应的View
 @param mapView 地图View
 @param annotation 指定的标注
 @return 生成的标注View
 */
- (MAAnnotationView *)mapView:(GaoMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    MAAnnotationView *annotationView = nil;
    
    if ([annotation isKindOfClass:[POIAnnotation class]]) {
        
        annotationView = [self annotationViewForPOI:annotation];
        annotationView.canShowCallout = NO;
        
    }else if([annotation isKindOfClass:[GaoBaseAnnotation class]]){
        
        annotationView = [self annotationViewForBase:annotation];
        annotationView.canShowCallout = NO;
        
    }else if([annotation isKindOfClass:[MAUserLocation class]]){
    
    }else {
        
    }

    //设置中心点偏移，使得标注底部中间点成为经纬度对应点
    annotationView.centerOffset = CGPointMake(0, -18);

    return annotationView;
}

/*!
 @brief 当选中一个annotation views时，调用此接口
 @param mapView 地图View
 @param views 选中的annotation views
 */
- (void)mapView:(GaoMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    if ([view isKindOfClass:NSClassFromString(@"MAUserLocationView")]) {
        return;
    }
    
    self.selectAnnotationView = (GaoBaseAnnotationView *)view;
    XLog(@"%@", [view.annotation class]);
    if (self.clickedAnnotation) {
        self.clickedAnnotation(view.annotation, view);
    }
}

/*!
 @brief 当取消选中一个annotation views时，调用此接口
 @param mapView 地图View
 @param views 取消选中的annotation views
 */
- (void)mapView:(GaoMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view
{
    XLog(@"");
}

/*!
 @brief 标注view的accessory view(必须继承自UIControl)被点击时，触发该回调
 @param mapView 地图View
 @param annotationView callout所属的标注view
 @param control 对应的control
 */
- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    XLog(@"");
}

#pragma mark - Overlay

/*!
 @brief 根据overlay生成对应的View
 @param mapView 地图View
 @param overlay 指定的overlay
 @return 生成的覆盖物View
 */
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineView *polylineRenderer = [[MAPolylineView alloc] initWithPolyline:naviPolyline.polyline];
        
        polylineRenderer.lineWidth = 8;
        
        polylineRenderer.strokeColor=[UIColor
                                      redColor];
        
        return polylineRenderer;
    }

    return nil;
}


#pragma mark - Location

/*!
 @brief 位置或者设备方向更新后，会调用此函数
 @param mapView 地图View
 @param userLocation 用户定位信息(包括位置与设备方向等数据)
 @param updatingLocation 标示是否是location数据更新, YES:location数据更新 NO:heading数据更新
 */
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{

}

/*!
 @brief 定位失败后，会调用此函数
 @param mapView 地图View
 @param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    
}

/**
 *  聚焦用户所在地
 */
-(void)showUserLocationPoint
{
    [self.map setCenterCoordinate:self.map.userLocation.coordinate animated:YES];
}

#pragma mark - POI

/*!
 @brief 当touchPOIEnabled == YES时，单击地图使用该回调获取POI信息
 @param mapView 地图View
 @param pois 获取到的poi数组(由MATouchPoi组成)
 */
- (void)mapView:(MAMapView *)mapView didTouchPois:(NSArray *)pois
{
    XLog(@"");
    
    if (pois.count == 0)
    {
        if (self.clickedAnnotation) {
            self.clickedAnnotation(nil,nil);
        }
        return;
    }
    
    MATouchPoi *touch = [pois lastObject];
    GaoBaseAnnotation *annotation = [[GaoBaseAnnotation alloc] init];
    annotation.coordinate = touch.coordinate;
    annotation.title = touch.name;
    [self.map cleanMapView];
    [self.map addMyAnnotationBase:[NSArray arrayWithObject:annotation]];
}

#pragma mark - ViewTool

-(MAAnnotationView *)annotationViewForPOI:(POIAnnotation *)annotation
{
    
    GaoBaseAnnotationView *view = (GaoBaseAnnotationView *)[_map dequeueReusableAnnotationViewWithIdentifier:@"poi"];
    if (view == nil) {
        view = (GaoBaseAnnotationView *)[[GaoBaseAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"poi"];
    }
    view.labelText.text = [NSString stringWithFormat:@"%lu",[(POIAnnotation *)annotation tag]];
    
    return view;
}

-(MAAnnotationView *)annotationViewForBase:(GaoBaseAnnotation *)annotation
{
    GaoBaseAnnotationView *view = (GaoBaseAnnotationView *)[_map dequeueReusableAnnotationViewWithIdentifier:@"base"];
    if (view == nil) {
        view = (GaoBaseAnnotationView *)[[GaoBaseAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"base"];
    }
    
    return view;
}

@end
