//
//  AMapCloudAPI.h
//  AMapCloudKit
//
//  Created by 刘博 on 14-3-17.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AMapCloudCommonObj.h"
#import "AMapCloudSearchObj.h"

@protocol AMapCloudDelegate;

#pragma mark - AMapCloudAPI

@interface AMapCloudAPI : NSObject

/*!
 @brief 实现了AMapCloudDelegate协议的类指针
 */
@property (nonatomic, assign) id<AMapCloudDelegate> delegate;

/*!
 @brief 查询超时时间 默认超时时间20秒
 */
@property (nonatomic, assign) NSInteger timeOut;

/*!
 @brief AMapCloudAPI类对象的初始化函数
 @param key 搜索模块鉴权Key
 @param delegate 实现AMapCloudDelegate协议的对象id
 @return AMapCloudAPI类对象id
 */
- (id)initWithCloudKey:(NSString *)key delegate:(id<AMapCloudDelegate>)delegate;

#pragma mark - Search Interface

/*!
 @brief 周边查询接口函数，即根据参数选项进行周边查询。
 @param request 查询选项。具体属性字段请参考 AMapCloudPlaceAroundSearchRequest 类。
 */
- (void)AMapCloudPlaceAroundSearch:(AMapCloudPlaceAroundSearchRequest *)request;

/*!
 @brief polygon区域查询接口函数，即根据参数选项进行polygon区域查询。
 @param request 查询选项。具体属性字段请参考 AMapCloudPlacePolygonSearchRequest 类。
 */
- (void)AMapCloudPlacePolygonSearch:(AMapCloudPlacePolygonSearchRequest *)request;

/*!
 @brief ID查询接口函数，即根据参数选项进行ID查询。
 @param request 查询选项。具体属性字段请参考 AMapCloudPlaceIDSearchRequest 类。
 */
- (void)AMapCloudPlaceIDSearch:(AMapCloudPlaceIDSearchRequest *)request;

/*!
 @brief 本地查询接口函数，即根据参数选项进行本地查询。
 @param request 查询选项。具体属性字段请参考 AMapCloudPlaceLocalSearchRequest 类。
 */
- (void)AMapCloudPlaceLocalSearch:(AMapCloudPlaceLocalSearchRequest *)request;

@end

#pragma mark - AMapCloudDelegate

/*!
 @brief AMapCloudDelegate协议类，从NSObject类继承。
 */
@protocol AMapCloudDelegate<NSObject>

@optional

/*!
 @brief 通知查询失败的回调函数
 @param cloudSearchRequest 发起的查询
 @param error 错误
 */
- (void)cloudRequest:(id)cloudSearchRequest error:(NSError *)error;

#pragma mark - Search Delegate

/*!
 @brief 周边查询回调函数
 @param request 发起查询的查询选项(具体字段参考AMapCloudPlaceAroundSearchRequest类中的定义)
 @param response 查询结果(具体字段参考AMapCloudSearchResponse类中的定义)
 */
- (void)onCloudPlaceAroundSearchDone:(AMapCloudPlaceAroundSearchRequest *)request response:(AMapCloudSearchResponse *)response;

/*!
 @brief 多边形查询回调函数
 @param request 发起查询的查询选项(具体字段参考AMapCloudPlacePolygonSearchRequest类中的定义)
 @param response 查询结果(具体字段参考AMapCloudSearchResponse类中的定义)
 */
- (void)onCloudPlacePolygonSearchDone:(AMapCloudPlacePolygonSearchRequest *)request response:(AMapCloudSearchResponse *)response;

/*!
 @brief ID查询回调函数
 @param request 发起查询的查询选项(具体字段参考AMapCloudPlaceIDSearchRequest类中的定义)
 @param response 查询结果(具体字段参考AMapCloudSearchResponse类中的定义)
 */
- (void)onCloudPlaceIDSearchDone:(AMapCloudPlaceIDSearchRequest *)request response:(AMapCloudSearchResponse *)response;

/*!
 @brief 本地查询回调函数
 @param request 发起查询的查询选项(具体字段参考AMapCloudPlaceLocalSearchRequest类中的定义)
 @param response 查询结果(具体字段参考AMapCloudSearchResponse类中的定义)
 */
- (void)onCloudPlaceLocalSearchDone:(AMapCloudPlaceLocalSearchRequest *)request response:(AMapCloudSearchResponse *)response;

@end
