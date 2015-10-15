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
#import "OutBusInfoCell.h"
#import "OutBusRouteViewController.h"

@interface OutNaviViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic ,strong) UIView *contentView;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) AMapRoute *currentRoute;

@property (nonatomic, strong) AMapTransit *currentTransit;

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
    
    float topmargin = seg.frame.origin.y + seg.frame.size.height + 20;
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, topmargin-10, GAO_SIZE.width, 0.5)];
    bottomLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    [self.contentView addSubview:bottomLine];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, topmargin, GAO_SIZE.width, GAO_SIZE.height-64 - topmargin)];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableFooterView = [UIView new];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_tableview];
    
    [_tableview registerClass:[OutBusInfoCell class] forCellReuseIdentifier:@"cell"];
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
        [weakself.parentVC.detailView refreshWithData:route tran:nil  annotation:weakself.parentVC.destAnnotation type:2];
        weakself.currentRoute = route;
        
        if (weakself.barView.currentNaviType == 2) {
            [weakself.tableview reloadData];
        }
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
        if (weakself.barView.currentNaviType == 2) {
            [weakself.tableview reloadData];
        }
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

#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentRoute.transits.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OutBusInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    AMapTransit *tran = self.currentRoute.transits[indexPath.row];
    NSString *busline = [GaoMapTool generateBusline:tran];
    
    [cell setBuslines:busline info:[NSString stringWithFormat:@"%@ 步行%@",
                                    [GaoMapTool secondsToFormatString:tran.duration],
                                    [GaoMapTool meterToFormatString:tran.walkingDistance]
                                    ]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMapTransit *tran = self.currentRoute.transits[indexPath.row];
    NSString *busline = [GaoMapTool generateBusline:tran];
    
    float height = [OutBusInfoCell heightForBuslines:busline];
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentTransit = self.currentRoute.transits[indexPath.row];
    [self gotoBusRouteVC];
}

//跳转公交导航详情
-(void)gotoBusRouteVC
{
    OutBusRouteViewController *vc = [[OutBusRouteViewController alloc] init];
    vc.transit = _currentTransit;
    [self.navigationController pushViewController:vc animated:YES];
    
    __weak OutNaviViewController *weakself = self;
    vc.backBtnClicked = ^(){
        [weakself.parentVC.detailView refreshWithData:weakself.currentRoute tran:weakself.currentTransit annotation:weakself.parentVC.destAnnotation type:OutBottomTypeRoute];
        [weakself showContentView:NO];
    };
}

#pragma mark - Other



@end
