//
//  OutBusInfoCell.h
//  TestGaoDeMap
//
//  Created by libo on 15/10/14.
//  Copyright © 2015年 libo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  公交路线概览cell
 */

@interface OutBusInfoCell : UITableViewCell

/**
 *  设置路线信息
 *
 *  @param busline 车次拼写
 *  @param infoStr 时间、步行信息
 */
-(void)setBuslines:(NSString *)busline info:(NSString *)infoStr;

+(float)heightForBuslines:(NSString *)busline;

@end
