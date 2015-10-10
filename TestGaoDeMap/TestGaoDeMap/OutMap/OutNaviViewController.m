//
//  OutNaviViewController.m
//  TestGaoDeMap
//
//  Created by libo on 15/10/9.
//  Copyright © 2015年 libo. All rights reserved.
//

#import "OutNaviViewController.h"
#import "GaoMapHeaders.h"

@interface OutNaviViewController ()

@end

@implementation OutNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 0, GAO_SIZE.width, 108);
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
}

-(void)setShow:(BOOL)show
{
    _show = show;
    self.view.hidden = !show;
}

@end
