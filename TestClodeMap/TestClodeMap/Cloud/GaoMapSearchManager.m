//
//  GaoMapSearchManager.m
//  TestClodeMap
//
//  Created by libo on 15/10/20.
//  Copyright © 2015年 libo. All rights reserved.
//

#import "GaoMapSearchManager.h"


@interface GaoMapSearchManager ()
@property (nonatomic, strong) AMapCloudAPI *cloudAPI;
@end

@implementation GaoMapSearchManager

#pragma mark - 

-(void)searchCloudPOIWithCity:(NSString *)city keywords:(NSString *)key isRefresh:(BOOL)refresh
{
    AMapCloudPlaceLocalSearchRequest *request = [[AMapCloudPlaceLocalSearchRequest alloc] init];
    
    [request setTableID:self.tableId];
    [request setCity:city];
    if (key.length > 0) {
        request.keywords = key;
    }
    request.offset = 100;
    [self.cloudAPI AMapCloudPlaceLocalSearch:request];
}

-(void)searchCloudPOIWithID:(NSInteger)ID
{
    AMapCloudPlaceIDSearchRequest *request = [[AMapCloudPlaceIDSearchRequest alloc] init];
    [request setTableID:self.tableId];
    
    //设置要查询的ID
    [request setID:ID];
    [self.cloudAPI AMapCloudPlaceIDSearch:request];
}

- (void)searchCloudPOIWithPoint:(CLLocationCoordinate2D)coor keywords:(NSString *)key
{
    AMapCloudPoint *centerPoint = [AMapCloudPoint locationWithLatitude:coor.latitude longitude:coor.longitude];
    
    AMapCloudPlaceAroundSearchRequest *request = [[AMapCloudPlaceAroundSearchRequest alloc] init];
    request.tableID = self.tableId;
    request.radius = 5000;
    request.center = centerPoint;
    
    if (key.length > 0) {
        request.keywords = key;
    }
    request.offset = 100;

    [self.cloudAPI AMapCloudPlaceAroundSearch:request];
    
//    [self addMACircleViewWithCenter:CLLocationCoordinate2DMake(centerPoint.latitude, centerPoint.longitude) radius:radius];
}


#pragma mark - AMapCloudDelegate


/*!
 @brief 通知查询失败的回调函数
 @param cloudSearchRequest 发起的查询
 @param error 错误
 */
- (void)cloudRequest:(id)cloudSearchRequest error:(NSError *)error
{
    
}

/*!
 @brief 周边查询回调函数
 */
- (void)onCloudPlaceAroundSearchDone:(AMapCloudPlaceAroundSearchRequest *)request response:(AMapCloudSearchResponse *)response
{

}

/*!
 @brief ID查询回调函数
 */
- (void)onCloudPlaceIDSearchDone:(AMapCloudPlaceIDSearchRequest *)request response:(AMapCloudSearchResponse *)response
{

}

/*!
 @brief 本地查询回调函数
 */
- (void)onCloudPlaceLocalSearchDone:(AMapCloudPlaceLocalSearchRequest *)request response:(AMapCloudSearchResponse *)response
{

}

@end
