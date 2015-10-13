//
//  ViewController.m
//  TestGaoDeMap
//
//  Created by libo on 15/9/18.
//  Copyright (c) 2015年 libo. All rights reserved.
//

#import "OutMapViewController.h"
#import "GaoMapHeaders.h"

@interface OutMapViewController ()<MAMapViewDelegate>

@property (nonatomic ,strong) GaoMapView *mapview;

@property (nonatomic ,strong) OutBottomView *detailView;

@property (nonatomic ,strong)  UIView *searchBar;

@property (nonatomic ,strong) OutNaviViewController *naviVC;

@property (nonatomic , strong) GaoBaseAnnotation *destAnnotation;

@end

@implementation OutMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[GaoMapConfig sharedConfig] setup];
    
    [self addMap];
    
    [self addSearchView];
    
    [self addOutDetailView];
    
    [self addOutNaviView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

//添加地图
-(void)addMap
{
    self.mapview = [GaoMapView getMapViewWithFrame:CGRectMake(0, 0, GAO_SIZE.width, GAO_SIZE.height) parentView:self.view];
    [self.mapview.mapManager showUserLocationPoint];
    [self.mapview defaultSetting];
    
    __weak OutMapViewController *weakself = self;
    self.mapview.mapManager.clickedAnnotation = ^(id<MAAnnotation> annotation, MAAnnotationView *annotationView){
        if(annotation == nil){
            weakself.destAnnotation = nil;
            [weakself showOutDetailView:NO];
        }else {
            weakself.destAnnotation = annotation;
            [weakself.detailView refreshWithData:nil annotation:annotation type:OutBottomTypeDest];
            [weakself showOutDetailView:YES];
        }
    };
}

//添加搜索Bar
-(void)addSearchView
{
    self.searchBar = [[UIView alloc] initWithFrame:CGRectMake(10, 30, GAO_SIZE.width - 20, 44)];
    self.searchBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchBar];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn1.frame = CGRectMake(50,0, 80, 44);
    btn1.backgroundColor = [UIColor redColor];
    [btn1 setTitle:@"搜索" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(redBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchBar addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn2.frame = CGRectMake(140,0, 80, 44);
    btn2.backgroundColor = [UIColor blueColor];
    [btn2 setTitle:@"品牌墙" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(blueBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchBar addSubview:btn2];
    
    self.mapview.logoCenter = self.searchBar.center;
}

//添加POI详情View
-(void)addOutDetailView
{
    self.detailView = [OutBottomView addViewOn:self.view marginBottom:15 marginLeft:10];
    self.detailView.parentVC = self;
    [self.detailView refreshWithData:nil annotation:nil type:OutBottomTypeDest];
    
    __weak OutMapViewController *weakself = self;
    self.detailView.btnClicked = ^(UIButton *btn){
        
        if (weakself.detailView.type == OutBottomTypeDest) {
            NSLog(@"带我去");
            weakself.searchBar.hidden = YES;
            weakself.naviVC.show = YES;
            
        }else if(weakself.detailView.type == OutBottomTypeRoute) {
            NSLog(@"路线详情");
            
            OutRouteViewController *route = [[OutRouteViewController alloc] init];
            route.route = weakself.naviVC.currentRoute;
            route.currentNaviType = weakself.naviVC.barView.currentNaviType;
            [weakself.navigationController pushViewController:route animated:YES];
            
        }else if(weakself.detailView.type == OutBottomTypePOI){
            NSLog(@"POI详情");
        }
       
    };
    
    [self showOutDetailView:NO];
}

//顶部二级导航
-(void)addOutNaviView
{
    self.naviVC = [[OutNaviViewController alloc] init];
    self.naviVC.parentVC = self;
    self.naviVC.mapview = self.mapview;
    [self addChildViewController:_naviVC];
    [self.view addSubview:_naviVC.view];
    
    _naviVC.show = NO;
    __weak OutMapViewController *weakself = self;
    _naviVC.backBtnClicked = ^(){
        weakself.searchBar.hidden = NO;
        [weakself showOutDetailView:NO];
    };
}

#pragma mark - Action

//显示隐藏 POI详情
-(void)showOutDetailView:(BOOL)show
{
    self.detailView.hidden = !show;
    
    [self.mapview setOutBtnBottomMargin:self.detailView.myHeight + 40 animation:YES];
}

//进入搜索
-(void)redBtnClicked:(UIButton *)btn
{
    NSLog(@"进入搜索");
    OutSearchViewController *search = [[OutSearchViewController alloc] init];
    search.map = self.mapview;
    [self.navigationController pushViewController:search animated:YES];
}

//进入品牌墙
-(void)blueBtnClicked:(UIButton *)btn
{
    NSLog(@"进入品牌墙");
}



@end
