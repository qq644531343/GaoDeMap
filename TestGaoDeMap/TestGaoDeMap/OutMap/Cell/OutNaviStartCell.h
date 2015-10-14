//
//  OutNaviStartCell.h
//  TestGaoDeMap
//
//  Created by libo on 15/10/13.
//  Copyright © 2015年 libo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OutNaviDetailBaseCell.h"

/**
 *  起点 、终点 cell
 */

@interface OutNaviStartCell : OutNaviDetailBaseCell

//0 起点  1终点
@property (nonatomic, readwrite) int type;

@end
