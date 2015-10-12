//
//  OutNaviViewController.m
//  TestGaoDeMap
//
//  Created by libo on 15/10/9.
//  Copyright © 2015年 libo. All rights reserved.
//

#import "OutNaviViewController.h"
#import "OutTopBarView.h"
#import "OutMapViewController.h"

@interface OutNaviViewController ()

@property (nonatomic ,strong)  OutTopBarView *barView;

@end

@implementation OutNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 0, GAO_SIZE.width, 64);
    self.view.backgroundColor = [UIColor whiteColor] ;
    
    [self addTopView];
}

-(void)addTopView
{
    
    self.barView = [OutTopBarView getTopBarOnView:self.view];
    [_barView defaultSetting];
    
    __weak OutNaviViewController *weakself = self;
    _barView.naviTypeChanged = ^(int naviType){
        [weakself naviToDestWithType:naviType];
        
    };
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 60, 44);
    [backBtn addTarget:self action:@selector(backToParent:) forControlEvents:UIControlEventTouchUpInside];
    [_barView addSubview:backBtn];

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
        _barView.currentNaviType = 3;
    }
    
}

//导航去目标点
-(void)naviToDestWithType:(int)type
{
    __weak OutNaviViewController *weakself = self;
    [self.mapview naviMineToDest:self.parentVC.destAnnotation type:type finished:^(AMapRoute *route) {
        if (weakself.barView.currentNaviType == 2) {
            weakself.view.frame = CGRectMake(0, 0, GAO_SIZE.width, GAO_SIZE.height);
        }else {
            weakself.view.frame = CGRectMake(0, 0, GAO_SIZE.width, 64);
        }
    }];
}


@end
