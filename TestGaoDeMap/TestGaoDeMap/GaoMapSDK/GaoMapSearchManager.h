//
//  GaoMapSearchManager.h
//  TestGaoDeMap
//
//  Created by libo on 15/9/30.
//  Copyright (c) 2015年 libo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapSearchKit/AMapCommonObj.h>

@class GaoMapView;

typedef void (^GaoBaseBlock) ();

/**
 *  搜索结果返回
 *
 *  @param count      数量
 *  @param pois       AMapPOI
 *  @param suggestion 建议信息
 */
typedef void(^SearchFinished)(NSError *error,  NSArray *pois, AMapSuggestion *suggestion);

/**
 *  交通搜索结果返回
 *
 *  @param count      数量
 *  @param pois       AMapPOI
 *  @param suggestion 建议信息
 */
typedef void(^NaviSearchFinished)(NSError *error, AMapRoute *route);

/**
 *  输入提示 结果返回
 *  tips为 AMapTip
 */
typedef void(^InputTipsFinished)(NSError *error, NSArray *tips);

/**
 *  地理编码 结果返回
 *  数组元素为AMapGeocode
 **/
typedef void(^GeoFinished)(NSError *error, NSArray *geocodes);

/**
 *  地理逆编码 结果返回
 *  数组元素为AMapReGeocode
 **/
typedef void(^RevserGeoFinished)(NSError *error, AMapReGeocode *res);

/**
 *  地图搜索、导航等的内容管理
 */

@interface GaoMapSearchManager : NSObject

+(GaoMapSearchManager *)getSearchManager;

@property (nonatomic , weak) GaoMapView *map;

#pragma mark - 搜索

/**
 *  根据ID搜索POI
 */
-(void)searchPOIById:(NSString *)uid finish:(SearchFinished)block;

/**
 *  关键字搜索
 */
/* 根据关键字来搜索POI. */
- (void)searchPOIByKeyword:(NSString *)keywords cityCode:(NSString *)cityCode finish:(SearchFinished)block;

/**
 *  周边搜索
 */
- (void)searchPOIArroundByKeywords:(NSString *)keywords location:(CLLocationCoordinate2D)coor radius:(NSInteger)radius finish:(SearchFinished)block;

/**
 *  多边形搜索
 *  points元素为AMapGeoPoint
 */
-(void)searchPOIByKewords:(NSString *)keywords polygons:(NSArray *)points finish:(SearchFinished)block;

#pragma mark - 导航

/**
 *  公交导航搜索
 *  strategy 公交换乘策略：0-最快捷模式；1-最经济模式；2-最少换乘模式；3-最少步行模式；4-最舒适模式；5-不乘地铁模式
 */
-(void)searchNaviBusWithStart:(AMapGeoPoint *)start dest:(AMapGeoPoint *)dest strategy:(NSInteger)strategy cityCode:(NSString *)cityCode finish:(NaviSearchFinished)block;

/**
 *  步行导航搜索
 */
-(void)searchNaviWalkWithStart:(AMapGeoPoint *)start dest:(AMapGeoPoint *)dest  finish:(NaviSearchFinished)block;

/**
 *  驾车导航搜索
 */
-(void)searchNaviDriveWithStart:(AMapGeoPoint *)start dest:(AMapGeoPoint *)dest     strategy:(NSInteger)strategy finish:(NaviSearchFinished)block;


#pragma mark - 输入提示

/**
 *  获取输入提示
 *
 *  @param keywords
 *  @param cityName 城市名或城市code
 */
-(void)inputTipsWithKeywords:(NSString *)keywords city:(NSString *)cityName finish:(InputTipsFinished)block;


#pragma mark - 地理编码 

/**
 * 根据 名称 搜索地理位置
 * @param name必选
 * @param cityName可选（可为城市名、code,adcode）
 */
-(void)geoSearchByName:(NSString *)name city:(NSString *)cityName finish:(GeoFinished)block;

/**
 *  根据经纬度查地名
 */
-(void)reverseGeoSearchByCoor:(CLLocationCoordinate2D)coor finish:(RevserGeoFinished)block;


@end
