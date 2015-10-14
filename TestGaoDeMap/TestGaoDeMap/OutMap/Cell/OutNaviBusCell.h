//
//  OutNaviBusCell.h
//  TestGaoDeMap
//
//  Created by libo on 15/10/14.
//  Copyright © 2015年 libo. All rights reserved.
//

#import "OutNaviDetailBaseCell.h"

/**
 *  公交详情cell
 */

@interface OutNaviBusCell : OutNaviDetailBaseCell

/**
 *  section行首传str换乘信息，其他传nil即可
 *
 *  @param str
 */
-(void)setIconForString:(NSString *)str;

@end
