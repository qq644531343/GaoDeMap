//
//  GaoMapConfig.m
//  TestGaoDeMap
//
//  Created by libo on 15/9/18.
//  Copyright (c) 2015年 libo. All rights reserved.
//

#import "GaoMapConfig.h"
#import "GaoMapHeaders.h"

@implementation GaoMapConfig

#pragma mark - Init

+(instancetype)sharedConfig
{
    static GaoMapConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GaoMapConfig alloc] init];
    });
    return instance;
}

-(instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

-(void)setup
{
    [MAMapServices sharedServices].apiKey = GAO_APP_KEY;
    [AMapSearchServices sharedServices].apiKey = GAO_APP_KEY;
}

#pragma mark -

@end
