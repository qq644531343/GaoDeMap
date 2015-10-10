//
//  OutNaviViewController.m
//  TestGaoDeMap
//
//  Created by libo on 15/10/9.
//  Copyright © 2015年 libo. All rights reserved.
//

#import "OutNaviViewController.h"
#import "OutTopBarView.h"
#import "ViewController.h"

@interface OutNaviViewController ()
{
    OutTopBarView *barView;
}
@end

@implementation OutNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 0, GAO_SIZE.width, 108);
    self.view.backgroundColor = [UIColor whiteColor] ;
    
    [self addTopView];
}

-(void)addTopView
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 20, 60, 44);
    [backBtn addTarget:self action:@selector(backToParent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, GAO_SIZE.width, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"导航";
    [self.view addSubview:titleLabel];
    
    barView = [OutTopBarView getTopBarOnView:self.view];
    [barView defaultSetting];
    
    __weak OutNaviViewController *weakself = self;
    barView.naviTypeChanged = ^(int naviType){
        [weakself.parentVC naviToDestWithType:naviType];
    };
    
}

-(void)backToParent:(UIButton *)btn
{
    [self setShow:NO];
    
    if (self.backBtnClicked) {
        self.backBtnClicked();
    }
}

-(void)setShow:(BOOL)show
{
    _show = show;
    self.view.hidden = !show;
    
    //默认为步行导航
    if(show){
        barView.currentNaviType = 3;
    }
    
}

@end
