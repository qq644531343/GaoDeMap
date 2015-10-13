//
//  OutTopBarView.h
//  TestGaoDeMap
//
//  Created by libo on 15/10/10.
//  Copyright © 2015年 libo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  路线导航顶部bar
 */

@interface OutTopBarView : UIView

+ (OutTopBarView *)getTopBarOnView:(UIView *)view;

-(void)defaultSetting;

/**
 *  当前导航方式
 *  1,自驾 2，公交 3，步行
 */
@property (nonatomic, readwrite) int currentNaviType;

/**
 *  点击事件回调
 */
@property (nonatomic,copy) void(^naviTypeChanged)(int currentNaviType);

@end
