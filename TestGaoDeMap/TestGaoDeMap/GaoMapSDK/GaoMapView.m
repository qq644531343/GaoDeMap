//
//  GaoMapView.m
//  TestGaoDeMap
//
//  Created by libo on 15/9/29.
//  Copyright (c) 2015年 libo. All rights reserved.
//

#import "GaoMapView.h"
#import "GaoMapHeaders.h"

#import "MANaviRoute.h"

@interface GaoMapView ()
{
    UIButton *relocateBtn;
    UIView *viewZoomBase;
}
@end

@implementation GaoMapView

#pragma mark - Init

+(GaoMapView *)getMapViewWithFrame:(CGRect)frame parentView:(UIView *)parentView
{
    GaoMapView *map = [[GaoMapView alloc] initWithFrame:frame];
    [parentView addSubview:map];
    return map;
}

-(void)defaultSetting
{
    _mapManager = [GaoMapManager getMapManager];
    _mapManager.map = self;
    
    _searchManager = [GaoMapSearchManager getSearchManager];
    _searchManager.map = self;
    
    //地图代理
    self.delegate = self.mapManager;
    
    //地图类型
    self.mapType = MAMapTypeStandard;
    
    //实时交通
    self.showTraffic = YES;
    
    //显示指南针
    self.showsCompass = NO;
    
    //显示用户位置
    self.showsUserLocation = YES;
    
    //用户位置跟踪模式
    [self setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    
    //比例尺
    self.showsScale = NO;
    
    //地图旋转手势
    self.rotateEnabled = YES;
    
    //地图倾斜手势
    self.rotateCameraEnabled = NO;

    //单击地图获取POI信息
    self.touchPOIEnabled = YES;
    
    //自定义定位样式
    self.customizeUserLocationAccuracyCircleRepresentation = YES;
    self.userTrackingMode = MAUserTrackingModeFollow;
    
    [self addRelocation];
    [self addScaleView];
    [self setOutBtnBottomMargin:30 animation:NO];
   
}

-(void)addRelocation
{
    relocateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    relocateBtn.backgroundColor = [UIColor whiteColor];
    [self setShadowForView:relocateBtn];
    [relocateBtn setImage:[UIImage imageNamed:@"gao_relocate-gray"] forState:UIControlStateNormal];
    [relocateBtn addTarget:self action:@selector(relocationClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.superview addSubview:relocateBtn];
}

-(void)addScaleView
{
    viewZoomBase = [[UIView alloc] init];
    viewZoomBase.backgroundColor = [UIColor clearColor];
    [self.superview addSubview:viewZoomBase];
    
    UIButton *btnZoomout = [UIButton buttonWithType:UIButtonTypeCustom];
    btnZoomout.frame = CGRectMake(0, 0, 40, 40);
    [btnZoomout setBackgroundImage:[UIImage imageNamed:@"gao_zoombig"] forState:UIControlStateNormal];
    [btnZoomout setBackgroundImage:[UIImage imageNamed:@"gao_zoombig"] forState:UIControlStateHighlighted];
    [btnZoomout addTarget:self action:@selector(mapZoomOut:) forControlEvents:UIControlEventTouchUpInside];
    [viewZoomBase addSubview:btnZoomout];
    
    UIButton *btnZoomin = [UIButton buttonWithType:UIButtonTypeCustom];
    btnZoomin.frame = CGRectMake(0, 40, 40, 40);
    [btnZoomin setBackgroundImage:[UIImage imageNamed:@"gao_zoomsmall"] forState:UIControlStateNormal];
     [btnZoomin setBackgroundImage:[UIImage imageNamed:@"gao_zoomsmall"] forState:UIControlStateHighlighted];
    [btnZoomin addTarget:self action:@selector(mapZoomIn:) forControlEvents:UIControlEventTouchUpInside];
    [viewZoomBase addSubview:btnZoomin];
}

-(void)setShadowForView:(UIView *)view
{
    UIColor *acolor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1.0];
    
    view.layer.borderWidth = 1.0;
    view.layer.borderColor = acolor.CGColor;
    view.layer.cornerRadius = 5.0;
    view.layer.shadowRadius = 2.0;
    view.layer.shadowColor = acolor.CGColor;
    view.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    view.layer.shadowOpacity = 1.0;
}

-(void)setOutBtnBottomMargin:(float)bottom animation:(BOOL)animated
{
    NSTimeInterval duration = animated == YES ? 0.25:0;
    
    [UIView animateWithDuration:duration animations:^{
        relocateBtn.frame = CGRectMake(10.0, self.frame.size.height - (bottom + 40), 40.0, 40.0);
        viewZoomBase.frame = CGRectMake(GAO_SIZE.width - 50, GAO_SIZE.height - (bottom + 80), 40, 80);
    }];
}

#pragma mark - Action
-(void)relocationClick:(UIButton *)btn
{
    [self.mapManager showUserLocationPoint];
}

//放大
-(void)mapZoomOut:(UIButton *)btn
{
    if (self.zoomLevel+1 > self.maxZoomLevel) {
        return;
    }
    
    [self setZoomLevel:self.zoomLevel + 1 animated:YES];
}

//缩小
-(void)mapZoomIn:(UIButton *)btn
{
    if (self.zoomLevel -1 < self.minZoomLevel) {
        return;
    }
    [self setZoomLevel:self.zoomLevel - 1 animated:YES];
}

#pragma mark - Annotation
-(void)addMyAnnotationTip:(AMapTip *)tip
{
    [self cleanMapView];
    
    POIAnnotation *anno = [[POIAnnotation alloc] initWithTip:tip];
    anno.tag = 1;
    [self addAnnotation:anno];
    
    [self setCenterCoordinate:anno.coordinate animated:YES];
}

-(void)addMyAnnotationPois:(NSArray *)pois
{
    [self cleanMapView];
    
    if (pois.count == 0) {
        return;
    }
    
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:pois.count];
    [pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        POIAnnotation *anno = [[POIAnnotation alloc] initWithPOI:obj];
        anno.tag = idx + 1;
        [poiAnnotations addObject:anno];
        
    }];
    [self addAnnotations:poiAnnotations];
    
     [self setCenterCoordinate:[(POIAnnotation *)[poiAnnotations firstObject] coordinate] animated:YES];
}

-(void)addMyAnnotationBase:(NSArray *)annotations
{
    [self cleanMapView];
    
    if (annotations.count == 0) {
        return;
    }
    
    [self addAnnotations:annotations];
    
}

#pragma mark - Clean

- (void)cleanMapView
{
    for (id anno in self.annotations) {
        if (anno == self.userLocation && self.showsUserLocation == YES) {
            continue;
        }
        [self removeAnnotation:anno];
    }
    for (id over in self.overlays) {
        if (over == self.userLocationAccuracyCircle && self.showsUserLocation == YES) {
            continue;
        }
        [self removeOverlay:over];
    }
}

-(void)deallocMapView
{
    self.showsUserLocation = NO;
    [self cleanMapView];
    self.delegate = nil;
}

-(void)dealloc
{
    [self deallocMapView];
}

#pragma mark - Test

//导航至某点
-(void)naviMineToDest:(GaoBaseAnnotation *)dest type:(int)type strategy:(NSInteger)strategy finished:(void (^)(AMapRoute *))block
{
    GaoBaseAnnotation *start = [[GaoBaseAnnotation alloc] init];
    start.title = self.userLocation.title;
    start.coordinate = self.userLocation.coordinate;
    
    start.type = 1;
    dest.type = 2;
    
    [self naviFrom:start dest:dest type:type strategy:strategy finished:block];
}

//导航:从src到dest点
-(void)naviFrom:(GaoBaseAnnotation *)src dest:(GaoBaseAnnotation *)dest type:(int)type strategy:(NSInteger)strategy finished:(void (^)(AMapRoute *))block
{
    [self addMyAnnotationBase:[NSArray arrayWithObjects:src,dest, nil]];
    
    AMapGeoPoint *point1 = [AMapGeoPoint locationWithLatitude:src.coordinate.latitude longitude:src.coordinate.longitude];
    AMapGeoPoint *point2 = [AMapGeoPoint locationWithLatitude:dest.coordinate.latitude longitude:dest.coordinate.longitude];

    //自驾
    if (type == 1) {
        [self.searchManager searchNaviDriveWithStart:point1 dest:point2 strategy:strategy finish:^(NSError *error, AMapRoute *route) {
            if (block) {
                block(route);
            }
            if (route.paths.count > 0) {
                [self addMyAnnotationBase:[NSArray arrayWithObjects:src,dest, nil]];
                [self showAnnotations:[NSArray arrayWithObjects:src,dest, nil] animated:NO];
                self.zoomLevel -= 0.5;
                MANaviRoute *navi = [MANaviRoute naviRouteForPath:route.paths[0] withNaviType:MANaviAnnotationTypeDrive endCoor:dest.coordinate startCoor:src.coordinate];
                [navi addToMapView:self];
            }else {
                NSLog(@"没有查询到自驾结果");
            }
        }];

    }else if(type == 2){
    //公交
        [self.searchManager searchNaviBusWithStart:point1 dest:point2 strategy:strategy cityCode:self.mapManager.userAddress.addressComponent.citycode finish:^(NSError *error, AMapRoute *route) {
            
            if (block) {
                block(route);
            }
            if (route.transits.count > 0) {
                [self addMyAnnotationBase:[NSArray arrayWithObjects:src,dest, nil]];
                [self showAnnotations:[NSArray arrayWithObjects:src,dest, nil] animated:NO];
                self.zoomLevel -= 0.5;
                MANaviRoute *navi = [MANaviRoute naviRouteForTransit:route.transits[0] endCoor:dest.coordinate startCoor:src.coordinate];
                [navi addToMapView:self];
            }else {
               NSLog(@"没有查询到公交结果");
            }
        }];
        
    }else if(type == 3){
     //步行
        [self.searchManager searchNaviWalkWithStart:point1 dest:point2 finish:^(NSError *error, AMapRoute *route) {
            
            if (block) {
                block(route);
            }
            if (route.paths.count > 0) {
                [self addMyAnnotationBase:[NSArray arrayWithObjects:src,dest, nil]];
                [self showAnnotations:[NSArray arrayWithObjects:src,dest, nil] animated:NO];
                self.zoomLevel -= 0.5;
                MANaviRoute *navi = [MANaviRoute naviRouteForPath:route.paths[0] withNaviType:MANaviAnnotationTypeWalking endCoor:dest.coordinate startCoor:src.coordinate];
                [navi addToMapView:self];
            }else {
                 NSLog(@"没有查询到步行结果");
            }
        }];
    }
}

@end
