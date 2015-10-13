//
//  OutNaviViewController.h
//  TestGaoDeMap
//
//  Created by libo on 15/10/9.
//  Copyright © 2015年 libo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GaoMapHeaders.h"
#import "OutTopBarView.h"

@class OutMapViewController;

/**
 *  导航规划
 */

@interface OutNaviViewController : UIViewController

@property (nonatomic ,weak) OutMapViewController *parentVC;

@property (nonatomic ,weak) GaoMapView *mapview;

/**
 *  返回事件回调
 */
@property (nonatomic,copy) void(^backBtnClicked)();

@property (nonatomic, strong, readonly) AMapRoute *currentRoute;

@property (nonatomic ,strong)  OutTopBarView *barView;

@property (nonatomic, readwrite) BOOL show;

@end
