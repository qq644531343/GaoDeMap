//
//  AMapCloudObj.h
//  AMapCloudKit
//
//  Created by 刘博 on 14-3-10.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AMapCloudCommonObj.h"

typedef NS_ENUM(NSInteger, AMapCloudSortType)
{
    AMapCloudSortType_DESC      = 0,    //降序
    AMapCloudSortType_ASC       = 1,    //升序
};

#pragma mark - AMapCloudSearchRequest

@interface AMapCloudSearchRequest : AMapCloudRequestBase

/*!
 @brief 可选,关键字,对建立了文本索引的字段进行模糊检索(系统默认为_name和_address建立文本索引).
 注意: 所设置的keywords中不能含有&、#、%等URL的特殊符号。
 */
@property (nonatomic, strong) NSString *keywords;

/*!
 @brief 可选,筛选条件数组,对建立了排序筛选索引的字段进行筛选(系统默认为：_id，_name，_address，_updatetime，_createtime建立排序筛选索引)
 @brief 1.支持对文本字段的精确匹配；支持对整数和小数字段的连续区间筛选；
 @brief 2.示例:数组{@"type:酒店", @"star:[3,5]"}的含义,等同于SQL语句:WHERE type = "酒店" AND star BETWEEN 3 AND 5
  注意: 所设置的过滤条件中不能含有&、#、%等URL的特殊符号。
 */
@property (nonatomic, strong) NSArray *filter;

/*!
 @brief 可选,排序字段名
 @brief 1.支持按建立了排序筛选索引的整数或小数字段进行排序；
          sortFields = @"字段名"
 @brief 2.系统预设的字段(忽略sortType)：
          _distance：坐标与中心点距离升序排序，仅在周边检索时有效；
          _weight：权重降序排序，当存在keywords时有效；
 @brief 3.默认值：
          当keywords存在时：默认按预设字段_weight排序；
          当keywords不存在时，默认按预设字段_distance排序；
          按建立了排序筛选索引的整数或小数字段进行排序时，若不填升降序，则默认按升序排列；
 */
@property (nonatomic, strong) NSString *sortFields;

/*!
 @brief 可选,排序方式(默认升序)
 */
@property (nonatomic, assign) AMapCloudSortType sortType;

/*!
 @brief 可选,每页记录数(每页最大记录数100,默认20)
 */
@property (nonatomic, assign) NSInteger offset;

/*!
 @brief 可选,当前页数(>=1,默认1)
 */
@property (nonatomic, assign) NSInteger page;

@end


#pragma mark - AMapCloudSearchResponse

@interface AMapCloudSearchResponse : AMapCloudResponseBase

/*!
 @brief 返回结果总数目
 */
@property (nonatomic, assign) NSInteger count;

/*!
 @brief 返回的结果,AMapCloudPOI数组
 */
@property (nonatomic, strong) NSArray *POIs;

@end


#pragma mark - AMapCloudPlaceAroundSearchRequest

@interface AMapCloudPlaceAroundSearchRequest : AMapCloudSearchRequest

/*!
 @brief 必填,中心点坐标
 */
@property (nonatomic, copy) AMapCloudPoint *center;

/*!
 @brief 可选,查询半径(单位:米;默认:3000)
 */
@property (nonatomic, assign) NSInteger radius;

@end


#pragma mark - AMapCloudPlacePolygonSearchRequest

@interface AMapCloudPlacePolygonSearchRequest : AMapCloudSearchRequest

/*!
 @brief 必填,坐标串定义
 */
@property (nonatomic, copy) AMapCloudPolygon *polygon;

@end


#pragma mark - AMapCloudPlaceIDSearchRequest

@interface AMapCloudPlaceIDSearchRequest : AMapCloudRequestBase

/*!
 @brief 必填,POI的ID
 */
@property (nonatomic, assign) NSInteger ID;

@end

#pragma mark - AMapCloudPlaceLocalSearchRequest

@interface AMapCloudPlaceLocalSearchRequest : AMapCloudSearchRequest

/*!
 @brief 必填,POI所在城市
 */
@property (nonatomic, copy) NSString *city;

@end

