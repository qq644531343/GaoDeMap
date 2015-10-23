//
//  GaoMapSearchManager.m
//  TestGaoDeMap
//
//  Created by libo on 15/9/30.
//  Copyright (c) 2015年 libo. All rights reserved.
//

#import "GaoMapSearchManager.h"
#import "GaoMapHeaders.h"

@interface GaoMapSearchManager () <AMapSearchDelegate>

@property (nonatomic ,strong) AMapSearchAPI *search;

@property (nonatomic, strong) AMapCloudAPI *cloudAPI;

@property (nonatomic ,strong) NSMutableArray *finishBlocks;

@end


@implementation GaoMapSearchManager

+(GaoMapSearchManager *)getSearchManager
{
    GaoMapSearchManager *manager = [[GaoMapSearchManager alloc] init];
    manager.search = [[AMapSearchAPI alloc] init];
    manager.search.delegate = manager;
    manager.finishBlocks = [[NSMutableArray alloc] init];
    return manager;
}

#pragma mark - AMapSearchDelegate
/**
 *  查询失败
 */
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    SearchFinished block = [self popBlockForRequest:request];
    if (block) {
        block(error,nil, nil);
        block = nil;
    }
}

/*!
 @brief Cloud查询失败
 */
- (void)cloudRequest:(id)cloudSearchRequest error:(NSError *)error
{
    SearchFinished block = [self popBlockForRequest:cloudSearchRequest];
    if (block) {
        block(error,nil, nil);
        block = nil;
    }
}

/*!
 @brief Cloud周边查询回调函数
 */
- (void)onCloudPlaceAroundSearchDone:(AMapCloudPlaceAroundSearchRequest *)request response:(AMapCloudSearchResponse *)response
{
    SearchFinished block = [self popBlockForRequest:request];
    if (block) {
        block(nil, response.POIs, nil);
        block = nil;
    }
}

/*!
 @brief  Cloud ID查询回调函数
 */
- (void)onCloudPlaceIDSearchDone:(AMapCloudPlaceIDSearchRequest *)request response:(AMapCloudSearchResponse *)response
{
    SearchFinished block = [self popBlockForRequest:request];
    if (block) {
        block(nil, response.POIs, nil);
        block = nil;
    }
}

/*!
 @brief Cloud 本地查询回调函数
 */
- (void)onCloudPlaceLocalSearchDone:(AMapCloudPlaceLocalSearchRequest *)request response:(AMapCloudSearchResponse *)response
{
    SearchFinished block = [self popBlockForRequest:request];
    if (block) {
        block(nil, response.POIs, nil);
        block = nil;
    }
}

/**
 *  POI查询回调函数
 */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    SearchFinished block = [self popBlockForRequest:request];
    if (block) {
        block(nil, response.pois, response.suggestion);
        block = nil;
    }
}

/**
 *  路径规划查询回调
 *
 */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    NaviSearchFinished block = [self popBlockForRequest:request];
    if (block) {
        block(nil, response.route);
        block = nil;
    }
}

/**
 *  输入提示 回调
 */
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    InputTipsFinished block = [self popBlockForRequest:request];
    if (block) {
        block(nil, response.tips);
        block = nil;
    }
}

/**
 *  Geo回调
 */

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    GeoFinished block = [self popBlockForRequest:request];
    if (block) {
        block(nil,response.geocodes);
        block = nil;
    }
}

/**
 *  ReverseGeo回调
 */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    RevserGeoFinished block = [self popBlockForRequest:request];
    if (block) {
        block(nil,response.regeocode);
        block = nil;
    }
}

#pragma mark - POI搜索

/**
 *  根据ID搜索POI
 *
 */
-(void)searchPOIById:(NSString *)uid finish:(SearchFinished)block
{
    AMapPOIIDSearchRequest *request = [[AMapPOIIDSearchRequest alloc] init];
    request.uid = uid;
    request.requireExtension = YES;

    [self.search AMapPOIIDSearch:request];
    [self pushBlockForRequest:request block:block];
}

/**
 *  关键字搜索
 */
/* 根据关键字来搜索POI. */
- (void)searchPOIByKeyword:(NSString *)keywords cityCode:(NSString *)cityCode finish:(SearchFinished)block
{
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.city = cityCode;
    request.keywords = keywords;
    request.requireExtension    = YES;
    
    [self.search AMapPOIKeywordsSearch:request];
    [self pushBlockForRequest:request block:block];
}

/**
 *  周边搜索
 */
- (void)searchPOIArroundByKeywords:(NSString *)keywords location:(CLLocationCoordinate2D)coor radius:(NSInteger)radius finish:(SearchFinished)block
{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:coor.latitude longitude:coor.longitude];
    request.keywords = keywords;
    request.radius = radius;
    request.sortrule = 1;
    request.requireExtension = YES;
    
    [self.search AMapPOIAroundSearch:request];
    [self pushBlockForRequest:request block:block];
}

/**
 *  多边形搜索
 *  points元素为AMapGeoPoint
 */
-(void)searchPOIByKewords:(NSString *)keywords polygons:(NSArray *)points finish:(SearchFinished)block
{
    AMapPOIPolygonSearchRequest *request = [[AMapPOIPolygonSearchRequest alloc] init];
    request.keywords = keywords;
    request.requireExtension = YES;
    
    AMapGeoPolygon *polygon = [AMapGeoPolygon polygonWithPoints:points];
    request.polygon = polygon;
    
    [self.search AMapPOIPolygonSearch:request];
    [self pushBlockForRequest:request block:block];
}


#pragma mark - 导航

/**
 *  公交导航搜索
 */
-(void)searchNaviBusWithStart:(AMapGeoPoint *)start dest:(AMapGeoPoint *)dest strategy:(NSInteger)strategy cityCode:(NSString *)cityCode finish:(NaviSearchFinished)block
{
    AMapTransitRouteSearchRequest *request = [[AMapTransitRouteSearchRequest alloc] init];
    request.origin = start;
    request.destination = dest;
    request.strategy = strategy;
    request.city = cityCode;
    request.nightflag = YES;
    request.requireExtension = YES;
    
    [self.search AMapTransitRouteSearch:request];
    [self pushBlockForRequest:request block:block];
}

/**
 *  步行导航搜索
 */
-(void)searchNaviWalkWithStart:(AMapGeoPoint *)start dest:(AMapGeoPoint *)dest  finish:(NaviSearchFinished)block
{
    AMapWalkingRouteSearchRequest *request = [[AMapWalkingRouteSearchRequest alloc] init];
    request.origin = start;
    request.destination = dest;
    
    [self.search AMapWalkingRouteSearch:request];
    [self pushBlockForRequest:request block:block];
}

/**
 *  驾车导航搜索
 */
-(void)searchNaviDriveWithStart:(AMapGeoPoint *)start dest:(AMapGeoPoint *)dest strategy:(NSInteger)strategy finish:(NaviSearchFinished)block
{
    AMapDrivingRouteSearchRequest *request = [[AMapDrivingRouteSearchRequest alloc] init];
    request.strategy = strategy;
    request.origin = start;
    request.destination = dest;
    request.requireExtension = YES;
    
    [self.search AMapDrivingRouteSearch:request];
    [self pushBlockForRequest:request block:block];
}

#pragma mark - 输入提示

-(void)inputTipsWithKeywords:(NSString *)keywords city:(NSString *)cityName finish:(InputTipsFinished)block
{
    AMapInputTipsSearchRequest *request = [[AMapInputTipsSearchRequest alloc] init];
    request.keywords = keywords;
    request.city = cityName;
    
    [self.search AMapInputTipsSearch:request];
    [self pushBlockForRequest:request block:block];
}

#pragma mark - 地理编解码
//根据名称搜索地理位置
-(void)geoSearchByName:(NSString *)name city:(NSString *)cityName finish:(GeoFinished)block
{
    AMapGeocodeSearchRequest *request = [[AMapGeocodeSearchRequest alloc] init];
    request.address = name;
    
    if (cityName.length > 0) {
        request.city = cityName;
    }
    
    [self.search AMapGeocodeSearch:request];
    [self pushBlockForRequest:request block:block];
}

/**
 *  根据经纬度查地名
 */
-(void)reverseGeoSearchByCoor:(CLLocationCoordinate2D)coor finish:(RevserGeoFinished)block
{
    AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:coor.latitude longitude:coor.longitude];
    request.requireExtension = YES;
    
    [self.search AMapReGoecodeSearch:request];
    [self pushBlockForRequest:request block:block];
}

#pragma mark - 云图POI

-(void)searchCloudPOIWithCity:(NSString *)city keywords:(NSString *)key isRefresh:(BOOL)refresh finish:(SearchFinished)block
{
    AMapCloudPlaceLocalSearchRequest *request = [[AMapCloudPlaceLocalSearchRequest alloc] init];
    
    [request setTableID:[GaoMapConfig sharedConfig].tableId];
    [request setCity:city];
    if (key.length > 0) {
        request.keywords = key;
    }
    request.offset = 100;
    [self.cloudAPI AMapCloudPlaceLocalSearch:request];
    
    [self pushBlockForRequest:request block:block];
}

-(void)searchCloudPOIWithID:(NSInteger)ID  finish:(SearchFinished)block
{
    AMapCloudPlaceIDSearchRequest *request = [[AMapCloudPlaceIDSearchRequest alloc] init];
    [request setTableID:[GaoMapConfig sharedConfig].tableId];
    
    //设置要查询的ID
    [request setID:ID];
    [self.cloudAPI AMapCloudPlaceIDSearch:request];
    
    [self pushBlockForRequest:request block:block];
}

- (void)searchCloudPOIWithPoint:(CLLocationCoordinate2D)coor keywords:(NSString *)key  finish:(SearchFinished)block
{
    AMapCloudPoint *centerPoint = [AMapCloudPoint locationWithLatitude:coor.latitude longitude:coor.longitude];
    
    AMapCloudPlaceAroundSearchRequest *request = [[AMapCloudPlaceAroundSearchRequest alloc] init];
    [request setTableID:[GaoMapConfig sharedConfig].tableId];
    request.radius = 5000;
    request.center = centerPoint;
    
    if (key.length > 0) {
        request.keywords = key;
    }
    request.offset = 100;
    
    [self.cloudAPI AMapCloudPlaceAroundSearch:request];
    
    [self pushBlockForRequest:request block:block];
    
    //    [self addMACircleViewWithCenter:CLLocationCoordinate2DMake(centerPoint.latitude, centerPoint.longitude) radius:radius];
}


#pragma mark - pop finished block

-(GaoBaseBlock)popBlockForRequest:(id)request
{
    for (int i = 0; i < self.finishBlocks.count; i ++) {
        NSDictionary *dic = self.finishBlocks[i];
        if (dic.allKeys.count > 0) {
            NSString *address = [dic valueForKey:@"address"];
            SearchFinished block = [dic valueForKey:@"block"];
            if ([address isEqualToString:[NSString stringWithFormat:@"%p",request]]) {
                [self.finishBlocks removeObject:dic];
                return block;
            }
        }
    }
    return NULL;
}

-(void)pushBlockForRequest:(id)request block:(GaoBaseBlock)block
{
    if (block == nil || request == nil) {
        return;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%p",request],@"address",[block copy],@"block", nil];
    [self.finishBlocks addObject:dic];
}

#pragma mark - 

-(void)dealloc
{
    self.search.delegate = nil;
    self.search = nil;
}

@end
