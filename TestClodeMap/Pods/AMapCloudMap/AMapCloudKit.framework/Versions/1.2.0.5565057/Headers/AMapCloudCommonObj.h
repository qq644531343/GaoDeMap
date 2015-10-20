//
//  AMapCloudCommonObj.h
//  AMapCloudKit
//
//  Created by 刘博 on 14-3-10.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*!
 @brief AMapCloud错误Domain
 */
extern NSString * const AMapCloudErrorDomain;

typedef NS_ENUM(NSInteger, AMapCloudError)
{
    AMapCloudErrorUnknow = -1,          //未知错误
    AMapCloudHttpError = -2,            //HTTP Error
    AMapCloudNoResponseData = -3,       //没有返回数据
    AMapCloudServiceError = -4,         //服务端返回错误
    
};

#pragma mark - AMapCloudRequestBase

@interface AMapCloudRequestBase : NSObject

/*!
 @brief 必选,要查询的表格ID
 */
@property (nonatomic, strong) NSString *tableID;

@end

#pragma mark - AMapCloudResponseBase

@interface AMapCloudResponseBase : NSObject

/*!
 @brief 返回状态(1:成功;0:失败)
 */
@property (nonatomic, assign) NSInteger status;

/*!
 @brief 返回的状态信息(只有返回状态为异常情况下需要对状态进行说明)
 */
@property (nonatomic, strong) NSString *info;

@end

#pragma mark - 基础数据类型

/*!
 @brief 经纬度
 */
@interface AMapCloudPoint : NSObject<NSCopying>

/*!
 @brief 纬度
 */
@property (nonatomic, assign) CGFloat latitude;

/*!
 @brief 经度
 */
@property (nonatomic, assign) CGFloat longitude;

/*!
 @brief AMapCloudPoint类对象的初始化函数
 @param lat 纬度
 @param lon 经度
 @return AMapCloudPoint类对象id
 */
+ (AMapCloudPoint *)locationWithLatitude:(CGFloat)lat longitude:(CGFloat)lon;

@end

/*!
 @brief 多边形 
 @brief 矩形:左下--右上两个顶点; 其他形状:需要首尾坐标相同,当做闭合图形处理;
 */
@interface AMapCloudPolygon : NSObject<NSCopying>

/*!
 @brief 坐标集:AMapCloudPoint数组
 */
@property (nonatomic, strong) NSArray *points;

/*!
 @brief AMapCloudPolygon类对象的初始化函数
 @param points 多边形的点数组
 @return AMapCloudPolygon类对象id
 */
+ (AMapCloudPolygon *)polygonWithPoints:(NSArray *)points;

@end


/*!
 @brief POI点，图片信息
 */
@interface AMapCloudImage : NSObject

/*!
 @brief POI点的_id字段 图片的id标识
 */
@property (nonatomic, strong) NSString *ID;

/*!
 @brief POI点的_preurl字段 图片压缩后的url串
 */
@property (nonatomic, strong) NSString *preurl;

/*!
 @brief POI点的_url字段 图片原始的url
 */
@property (nonatomic, strong) NSString *url;

@end


/*!
 @brief POI点，修改AMapCloudPOI的字段值不会更改服务端的数据
 */
@interface AMapCloudPOI : NSObject

/*!
 @brief POI点的_id字段
 */
@property (nonatomic, assign) NSInteger ID;

/*!
 @brief POI点的_name字段
 */
@property (nonatomic, strong) NSString *name;

/*!
 @brief POI点的_location字段
 */
@property (nonatomic, strong) AMapCloudPoint *location;

/*!
 @brief POI点的_address字段
 */
@property (nonatomic, strong) NSString *address;

/*!
 @brief POI点的用户自定义字段字典
 */
@property (nonatomic, strong) NSDictionary *customFields;

/*!
 @brief POI点的_createtime字段
 */
@property (nonatomic, strong) NSString *createTime;

/*!
 @brief POI点的_updatetime字段
 */
@property (nonatomic, strong) NSString *updateTime;

/*!
 @brief POI点的_distance字段(只在PlaceAround搜索时有效)
 */
@property (nonatomic, assign) NSInteger distance;

/*!
 @brief POI点的_image字段
 */
@property (nonatomic, strong) NSArray * images;


@end
