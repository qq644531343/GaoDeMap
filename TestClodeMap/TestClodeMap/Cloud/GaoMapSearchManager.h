//
//  GaoMapSearchManager.h
//  TestClodeMap
//
//  Created by libo on 15/10/20.
//  Copyright © 2015年 libo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapCloudKit/AMapCloudAPI.h>

@interface GaoMapSearchManager : NSObject<AMapCloudDelegate>

@property (nonatomic, strong) NSString *tableId;

/**
 *  本地检索
 *  city为必选
 *  refresh为YES刷新，NO为加载更多
 */
-(void)searchCloudPOIWithCity:(NSString *)city keywords:(NSString *)key isRefresh:(BOOL)refresh;

/**
 *  POI ID检索
 *  city为必选
 *  refresh为YES刷新，NO为加载更多
 */
-(void)searchCloudPOIWithID:(NSInteger)ID;

/**
 *  搜索周边POI
 *
 *  @param coor 中心点
 *  @param key  可选关键字
 */
- (void)searchCloudPOIWithPoint:(CLLocationCoordinate2D)coor keywords:(NSString *)key;

@end