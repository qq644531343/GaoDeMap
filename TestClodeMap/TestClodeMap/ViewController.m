//
//  ViewController.m
//  TestClodeMap
//
//  Created by libo on 15/10/20.
//  Copyright © 2015年 libo. All rights reserved.
//

#import "ViewController.h"
#import "GaoMapSearchManager.h"
#import <AMapNaviKit/MAMapKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    //配置
    
    NSString *appKey = @"9fa23e2da3ea9ff665e68b2c72bcec3e";
    NSString *tableid = @"5625c02fe4b0d36c58c1d9e9";
    [MAMapServices sharedServices].apiKey = (NSString *)appKey;
    
    GaoMapSearchManager *search = [[GaoMapSearchManager alloc] init];
    search.tableId = tableid;
    
}

@end
