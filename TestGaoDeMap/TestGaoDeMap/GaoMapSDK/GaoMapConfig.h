//
//  GaoMapConfig.h
//  TestGaoDeMap
//
//  Created by libo on 15/9/18.
//  Copyright (c) 2015年 libo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  配置
 */

@interface GaoMapConfig : NSObject

+(instancetype)sharedConfig;

/**
 *  初始化设置
 */
-(void)setup;

@end
