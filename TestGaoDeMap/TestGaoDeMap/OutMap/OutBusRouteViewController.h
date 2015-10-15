//
//  OutBusRouteViewController.h
//  TestGaoDeMap
//
//  Created by libo on 15/10/14.
//  Copyright © 2015年 libo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GaoMapHeaders.h"

/**
 *  公交路线详情
 */

@interface OutBusRouteViewController : UIViewController

/**
 *  公交方案
 *  必选参数
 */
@property (nonatomic, strong) AMapTransit *transit;

/**
 *  点击跳地图的事件回调
 */
@property (nonatomic,copy) void(^backBtnClicked)();

@end
