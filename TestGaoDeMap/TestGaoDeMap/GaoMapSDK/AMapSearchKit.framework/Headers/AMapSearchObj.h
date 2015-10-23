//
//  AMapSearchObj.h
//  AMapSearchKit
//
//  Created by xiaoming han on 15/7/22.
//  Copyright (c) 2015年 AutoNavi. All rights reserved.
//

/**
 *  该文件定义了搜索请求和返回对象。
 */

#import <Foundation/Foundation.h>
#import "AMapCommonObj.h"

#pragma mark - AMapPOISearchBaseRequest

/// POI搜索请求基类
@interface AMapPOISearchBaseRequest : AMapSearchObject

@property (nonatomic, copy) NSString *types; //!< 类型，多个类型用“|”分割 可选值:文本分类、分类代码
@property (nonatomic, assign) NSInteger sortrule; //<! 排序规则, 0-距离排序；1-综合排序, 默认0
@property (nonatomic, assign) NSInteger offset; //<! 每页记录数, 范围1-50, [default = 20]
@property (nonatomic, assign) NSInteger page; //<! 当前页数, 范围1-100, [default = 1]

@property (nonatomic, assign) BOOL requireExtension; //<! 是否返回扩展信息，默认为 NO。

@end

/// POI ID搜索请求
@interface AMapPOIIDSearchRequest : AMapPOISearchBaseRequest

@property (nonatomic, copy) NSString *uid; //<! POI全局唯一ID

@end

/// POI关键字搜索
@interface AMapPOIKeywordsSearchRequest : AMapPOISearchBaseRequest

@property (nonatomic, copy) NSString *keywords; //<! 查询关键字，多个关键字用“|”分割
@property (nonatomic, copy) NSString *city; //!< 查询城市，可选值：cityname（中文或中文全拼）、citycode、adcode.

@end

/// POI周边搜索
@interface AMapPOIAroundSearchRequest : AMapPOISearchBaseRequest

@property (nonatomic, copy) NSString *keywords; //<! 查询关键字，多个关键字用“|”分割
@property (nonatomic, copy) AMapGeoPoint *location; //<! 中心点坐标
@property (nonatomic, assign) NSInteger radius; //<! 查询半径，范围：0-50000，单位：米 [default = 3000]

@end

/// POI多边形搜索
@interface AMapPOIPolygonSearchRequest : AMapPOISearchBaseRequest

@property (nonatomic, copy) NSString *keywords; //<! 查询关键字，多个关键字用“|”分割
@property (nonatomic, copy) AMapGeoPolygon *polygon; //<! 多边形

@end

/// POI搜索返回
@interface AMapPOISearchResponse : AMapSearchObject

@property (nonatomic, assign) NSInteger count; //!< 返回的POI数目
@property (nonatomic, strong) AMapSuggestion *suggestion; //!< 关键字建议列表和城市建议列表
@property (nonatomic, strong) NSArray *pois; //!< POI结果，AMapPOI 数组

@end

#pragma mark - AMapInputTipsSearchRequest

/// 搜索提示请求
@interface AMapInputTipsSearchRequest : AMapSearchObject

@property (nonatomic, copy) NSString *keywords; //!< 查询关键字
@property (nonatomic, copy) NSString *city; //!< 查询城市，可选值：cityname（中文或中文全拼）、citycode、adcode.

@end

/// 搜索提示返回
@interface AMapInputTipsSearchResponse : AMapSearchObject

@property (nonatomic, assign) NSInteger count; //!< 返回数目
@property (nonatomic, strong) NSArray *tips; //!< 提示列表 AMapTip 数组

@end

#pragma mark - AMapGeocodeSearchRequest

/// 地理编码请求
@interface AMapGeocodeSearchRequest : AMapSearchObject

@property (nonatomic, copy) NSString *address; //!< 地址
@property (nonatomic, copy) NSString *city; //!< 查询城市，可选值：cityname（中文或中文全拼）、citycode、adcode.

@end

/// 地理编码请求
@interface AMapGeocodeSearchResponse : AMapSearchObject

@property (nonatomic, assign) NSInteger count; //!< 返回数目
@property (nonatomic, strong) NSArray *geocodes; //!< 地理编码结果 AMapGeocode 数组

@end


#pragma mark - AMapReGeocodeSearchRequest

/// 逆地理编码请求
@interface AMapReGeocodeSearchRequest : AMapSearchObject

@property (nonatomic, assign) BOOL requireExtension; //!< 是否返回扩展信息，默认NO。
@property (nonatomic, copy) AMapGeoPoint *location; //!< 中心点坐标。
@property (nonatomic, assign) NSInteger radius; //!< 查询半径，单位米，范围0~3000，默认1000。

@end

/// 逆地理编码返回
@interface AMapReGeocodeSearchResponse : AMapSearchObject

@property (nonatomic, strong) AMapReGeocode *regeocode; //!< 逆地理编码结果

@end

#pragma mark - AMapBusStopSearchRequest

/// 公交站点请求
@interface AMapBusStopSearchRequest : AMapSearchObject

@property (nonatomic, copy) NSString *keywords; //!< 查询关键字
@property (nonatomic, copy) NSString *city; //!< 城市 可选值：cityname（中文或中文全拼）、citycode、adcode
@property (nonatomic, assign) NSInteger offset; //!< 每页记录数，默认为20，取值为：1-50
@property (nonatomic, assign) NSInteger page; //!< 当前页数，默认值为1，取值为：1-100

@end

/// 公交站点返回
@interface AMapBusStopSearchResponse : AMapSearchObject

@property (nonatomic, assign) NSInteger count; //!< 公交站数目
@property (nonatomic, strong) AMapSuggestion *suggestion; //!< 关键字建议列表和城市建议列表
@property (nonatomic, strong) NSArray *busstops; //!< 公交站点数组，数组中存放AMapBusStop对象

@end

#pragma mark - AMapBusLineSearchRequest

/// 公交线路查询请求基类，不可直接调用
@interface AMapBusLineBaseSearchRequest : AMapSearchObject

@property (nonatomic, copy) NSString *city; //!< 城市 可选值：cityname（中文或中文全拼）、citycode、adcode
@property (nonatomic, assign) BOOL requireExtension; //!< 是否返回扩展信息，默认为NO
@property (nonatomic, assign) NSInteger offset; //!< 每页记录数，默认为20，取值为1－50
@property (nonatomic, assign) NSInteger page; //!< 当前页数，默认为1，取值为1-100

@end

/// 公交站线路根据名字请求
@interface AMapBusLineNameSearchRequest : AMapBusLineBaseSearchRequest

@property (nonatomic, copy) NSString *keywords; //!< 查询关键字

@end

/// 公交站线路根据ID请求
@interface AMapBusLineIDSearchRequest : AMapBusLineBaseSearchRequest

@property (nonatomic, copy) NSString *uid;

@end

/// 公交站线路返回
@interface AMapBusLineSearchResponse : AMapSearchObject

@property (nonatomic, assign) NSInteger count; //!< 返回公交站数目
@property (nonatomic, strong) AMapSuggestion *suggestion; //!< 关键字建议列表和城市建议列表
@property (nonatomic, strong) NSArray *buslines; //!< 公交线路数组，数组中存放 AMapBusLine 对象

@end

#pragma mark - AMapDistrictSearchRequest

@interface AMapDistrictSearchRequest : AMapSearchObject

@property (nonatomic, copy) NSString *keywords; //!< 查询关键字，只支持单关键字搜索，全国范围
@property (nonatomic, assign) BOOL requireExtension; //!< 是否返回边界坐标，默认为NO

@end

@interface AMapDistrictSearchResponse : AMapSearchObject

@property (nonatomic, assign) NSInteger count; //!< 返回数目
@property (nonatomic, strong) NSArray *districts; //!< 行政区域 AMapDistrict 数组

@end

#pragma mark - AMapRouteSearchBaseRequest

/// 路径规划基础类，不可直接调用
@interface AMapRouteSearchBaseRequest : AMapSearchObject

@property (nonatomic, copy) AMapGeoPoint *origin; //!< 出发点
@property (nonatomic, copy) AMapGeoPoint *destination; //!< 目的地

@end

#pragma mark - AMapDrivingRouteSearchRequest

/// 驾车路径规划
@interface AMapDrivingRouteSearchRequest : AMapRouteSearchBaseRequest

/// 驾车导航策略：0-速度优先（时间）；1-费用优先（不走收费路段的最快道路）；2-距离优先；3-不走快速路；4-结合实时交通（躲避拥堵）；5-多策略（同时使用速度优先、费用优先、距离优先三个策略）；6-不走高速；7-不走高速且避免收费；8-躲避收费和拥堵；9-不走高速且躲避收费和拥堵
@property (nonatomic, assign) NSInteger strategy; //!< 驾车导航策略([default = 0])

@property (nonatomic, copy) NSArray *waypoints; //!< 途经点 AMapGeoPoint 数组
@property (nonatomic, copy) NSArray *avoidpolygons; //!< 避让区域 AMapGeoPolygon 数组
@property (nonatomic, copy) NSString *avoidroad; //!< 避让道路名

@property (nonatomic, copy) NSString *originId; //!< 出发点 POI ID
@property (nonatomic, copy) NSString *destinationId; //!< 目的地 POI ID

@property (nonatomic, assign) BOOL requireExtension; //!< 是否返回扩展信息，默认为 NO

@end

#pragma mark - AMapWalkingRouteSearchRequest

/// 步行路径规划
@interface AMapWalkingRouteSearchRequest : AMapRouteSearchBaseRequest

/// 是否提供备选步行方案: 0-只提供一条步行方案; 1-提供备选步行方案(有可能无备选方案)
@property (nonatomic, assign) NSInteger multipath; //!< 是否提供备选步行方案([default = 0])
@end

#pragma mark - AMapTransitRouteSearchRequest

/// 公交路径规划
@interface AMapTransitRouteSearchRequest : AMapRouteSearchBaseRequest

/// 公交换乘策略：0-最快捷模式；1-最经济模式；2-最少换乘模式；3-最少步行模式；4-最舒适模式；5-不乘地铁模式
@property (nonatomic, assign) NSInteger strategy;  //!< 公交换乘策略([default = 0])

@property (nonatomic, copy) NSString *city; //!< 城市
@property (nonatomic, assign) BOOL nightflag; //!< 是否包含夜班车，默认为 NO
@property (nonatomic, assign) BOOL requireExtension; //!< 是否返回扩展信息，默认为 NO

@end

#pragma mark - AMapRouteSearchResponse

/// 路径规划返回
@interface AMapRouteSearchResponse : AMapSearchObject

@property (nonatomic, assign) NSInteger count; //!< 路径规划信息数目
@property (nonatomic, strong) AMapRoute *route; //!< 路径规划信息

@end

#pragma mark - AMapWeatherSearchWeather

/// 天气查询类型
typedef NS_ENUM(NSInteger, AMapWeatherType)
{
    AMapWeatherTypeLive = 1, //<! 实时
    AMapWeatherTypeForecast //<! 预报
};

/// 天气查询请求
@interface AMapWeatherSearchRequest : AMapSearchObject

@property (nonatomic, copy) NSString *city; //!< 城市名称，支持cityname及adcode
@property (nonatomic, assign) AMapWeatherType type; //!< 气象类型，Live为实时天气，Forecast为后三天预报天气，默认为Live

@end
    
/// 天气查询返回
@interface AMapWeatherSearchResponse : AMapSearchObject

@property (nonatomic, strong) NSArray *lives; //!< 实时天气数据信息 AMapLocalWeatherLive 数组，仅在请求实时天气时有返回。

@property (nonatomic, strong) NSArray *forecasts; //!< 预报天气数据信息 AMapLocalWeatherForecast 数组，仅在请求预报天气时有返回。

@end

#pragma mark - AMapNearbySearchRequest

/// 附近搜索距离类型
typedef NS_ENUM(NSInteger, AMapNearbySearchType)
{
    AMapNearbySearchTypeLiner = 0, //!< 直线距离
    AMapNearbySearchTypeDriving = 1, //!< 驾车行驶距离
};

/// 附近搜索请求
@interface AMapNearbySearchRequest : AMapSearchObject

@property (nonatomic, copy) AMapGeoPoint *center; //<! 中心点坐标
@property (nonatomic, assign) NSInteger radius; //<! 查询半径，范围：[0, 10000]，单位：米 [default = 1000]
@property (nonatomic, assign) AMapNearbySearchType searchType; //<! 搜索距离类型，默认为直线距离
@property (nonatomic, assign) NSInteger timeRange; //<! 检索时间范围，超过24小时的数据无法返回，范围[5, 24*60*60] 单位：秒 [default = 1800]
@property (nonatomic, assign) NSInteger limit; //<! 返回条数，范围[1, 100], 默认30

@end

/// 附近搜索返回
@interface AMapNearbySearchResponse : AMapSearchObject

@property (nonatomic, assign) NSInteger count; //!< 结果总条数
@property (nonatomic, strong) NSArray *infos; //!< 周边用户信息 AMapNearbyUserInfo 数组

@end
