//
//  OutBottomView.h
//  TestGaoDeMap
//
//  Created by libo on 15/10/9.
//  Copyright © 2015年 libo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum OutBottomType{
    OutBottomTypePOI,
    OutBottomTypeDest,
    OutBottomTypeRoute
}OutBottomType;

@interface OutBottomView : UIView

+ (OutBottomView *)addViewOn:(UIView *)baseView marginBottom:(float)bottom marginLeft:(float)left;

/**
 *  重写隐藏方法
 */
-(void)setHidden:(BOOL)hidden;

/**
 *  显示样式
 */
@property (nonatomic, readonly) OutBottomType type;

/**
 *  填充数据
 */
-(void)refreshWithData:(id)data type:(OutBottomType)type;

/**
 *  控件实际高度
 */
@property (nonatomic ,readonly) float myHeight;

/**
 *  点击事件回调
 */
@property (nonatomic,copy) void(^btnClicked)(UIButton *btn);

@end
