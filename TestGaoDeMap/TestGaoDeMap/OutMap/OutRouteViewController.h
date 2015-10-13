//
//  OutRouteViewController.h
//  TestGaoDeMap
//
//  Created by libo on 15/10/12.
//  Copyright © 2015年 libo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GaoMapHeaders.h"

/**
 *  路线详情
 */

@interface OutRouteViewController : UIViewController


/**
 *  当前导航方式
 *  1,自驾 2，公交 3，步行
 */
@property (nonatomic, readwrite) int currentNaviType;

@property (nonatomic,strong) AMapRoute *route;

@end
