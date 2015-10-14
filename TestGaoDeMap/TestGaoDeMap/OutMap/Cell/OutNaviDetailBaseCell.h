//
//  OutNaviBaseCell.h
//  TestGaoDeMap
//
//  Created by libo on 15/10/13.
//  Copyright © 2015年 libo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OutNaviBaseCellHeight 50

/**
 *  步行、自驾导航详情cell
 */

@interface OutNaviDetailBaseCell : UITableViewCell

//画一个圆
-(UIView *)getCircleView:(UIColor *)borderColor radius:(float)radius;

@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic ,strong) UILabel *titlelabel;

-(void)setTitle:(NSString *)title;

@property (nonatomic, strong) UIView *horizonLine;

@property (nonatomic, strong) UIView *bottomLine;

@end
