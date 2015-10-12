    //
//  OutTopBarView.m
//  TestGaoDeMap
//
//  Created by libo on 15/10/10.
//  Copyright © 2015年 libo. All rights reserved.
//

#import "OutTopBarView.h"
#import "GaoMapHeaders.h"

@implementation OutTopBarView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

+(OutTopBarView  *)getTopBarOnView:(UIView *)view
{
    OutTopBarView *barView = [[OutTopBarView alloc] initWithFrame:CGRectMake(0, 20, GAO_SIZE.width, 44)];
    barView.backgroundColor = [UIColor whiteColor];
    [view addSubview:barView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, barView.frame.size.height - 0.5, barView.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [barView addSubview:line];
    
    return barView;
}

-(void)defaultSetting
{
    float buttonWidth = 60;
    float leftmargin = (GAO_SIZE.width - 60*3)/2.0;
    
    UIButton *carBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [carBtn setImage:[UIImage imageNamed:@"gao_navi_1"] forState:UIControlStateNormal];
    carBtn.frame = CGRectMake(leftmargin, 0, buttonWidth, 44);
    carBtn.tag = 1;
    [self addSubview:carBtn];
    
    UIButton *busBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [busBtn setImage:[UIImage imageNamed:@"gao_navi_2"] forState:UIControlStateNormal];
    busBtn.frame = CGRectMake(leftmargin + buttonWidth, 0, buttonWidth, 44);
    busBtn.tag = 2;
    [self addSubview:busBtn];
    
    UIButton *stepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [stepBtn setImage:[UIImage imageNamed:@"gao_navi_3"] forState:UIControlStateNormal];
    stepBtn.frame = CGRectMake(leftmargin + buttonWidth*2, 0, buttonWidth, 44);
    stepBtn.tag = 3;
    [self addSubview:stepBtn];
    
    [carBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [busBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [stepBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _currentNaviType = 3;
}

-(void)btnClicked:(UIButton *)btn
{
//    if(btn.tag == self.currentNaviType){
//        return;
//    }
    
    self.currentNaviType = (int)btn.tag;
}

-(void)setCurrentNaviType:(int)currentNaviType
{
    UIButton *oldBtn = (UIButton *)[self viewWithTag:_currentNaviType];
    UIButton *currentBtn = (UIButton *)[self viewWithTag:currentNaviType];
    
    [oldBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"gao_navi_%ld",oldBtn.tag]] forState:UIControlStateNormal];
    [currentBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"gao_navi_%ldH",currentBtn.tag]] forState:UIControlStateNormal];
    
    _currentNaviType = (int)currentBtn.tag;
    if (self.naviTypeChanged) {
        self.naviTypeChanged(_currentNaviType);
    }
}


@end
