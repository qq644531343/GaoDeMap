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

@property (nonatomic ,strong) UIView *contentView;

@property (nonatomic, strong) AMapRoute *currentRoute;

@end

@implementation OutNaviViewController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor] ;
    
    [self addTopView];
    
    [self addBusView];
    
    [self showContentView:NO];
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

-(void)addBusView
{
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, GAO_SIZE.width, GAO_SIZE.height - 64)];
    [self.view addSubview:self.contentView];
    
    UISegmentedControl *seg = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"最佳路线",@"步行少",@"换乘少",@"不坐地铁", nil]];
    seg.frame = CGRectMake(10,10, GAO_SIZE.width - 20, 35);
    seg.selectedSegmentIndex = 0;
    [_contentView addSubview:seg];
    [seg addTarget:self action:@selector(segChanged:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Action

-(void)backToParent:(UIButton *)btn
{
    [self setShow:NO];
    
    if (self.backBtnClicked) {
        self.backBtnClicked();
    }
}

//显示二级bar
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
    NSInteger strategy = 0;
    if (self.barView.currentNaviType == 2) {
        [self showContentView:YES];
    }else {
        [self showContentView:NO];
    }
    __weak OutNaviViewController *weakself = self;
    [self.mapview naviMineToDest:self.parentVC.destAnnotation type:type strategy:strategy finished:^(AMapRoute *route) {
        [weakself.parentVC.detailView refreshWithData:route annotation:weakself.parentVC.destAnnotation type:2];
        weakself.currentRoute = route;
    }];
}

-(void)segChanged:(UISegmentedControl *)seg
{
    NSLog(@"%@",[seg titleForSegmentAtIndex:seg.selectedSegmentIndex]);
    NSInteger strategy = 0;
    switch (seg.selectedSegmentIndex) {
        case 0:
            strategy = 0;
            break;
        case 1:
            strategy = 3;
            break;
        case 2:
            strategy = 2;
            break;
        case 3:
            strategy = 5;
            break;
        default:
            break;
    }
    
    __weak OutNaviViewController *weakself = self;
    [self.mapview naviMineToDest:self.parentVC.destAnnotation type:2 strategy:strategy finished:^(AMapRoute *route) {
        weakself.currentRoute = route;
    }];

}

//显示公交view
-(void)showContentView:(BOOL)show
{
    self.contentView.hidden = !show;
    if (show) {
        self.view.frame = CGRectMake(0, 0, GAO_SIZE.width, GAO_SIZE.height);
    }else {
        self.view.frame = CGRectMake(0, 0, GAO_SIZE.width, 64);
    }
}

@end
