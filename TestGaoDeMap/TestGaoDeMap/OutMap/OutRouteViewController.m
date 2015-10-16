//
//  OutRouteViewController.m
//  TestGaoDeMap
//
//  Created by libo on 15/10/12.
//  Copyright © 2015年 libo. All rights reserved.
//

#import "OutRouteViewController.h"
#import "GaoMapHeaders.h"
#import "OutNaviDetailBaseCell.h"
#import "OutNaviStartCell.h"

@interface OutRouteViewController () <UITableViewDataSource, UITableViewDelegate>
{
    AMapPath *stepPath;
}

@property (nonatomic ,strong) UITableView *tableview;

@end

@implementation OutRouteViewController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"导航详情";
    
//    [self testRoute];
//    return;
    
    if (self.currentNaviType == 3) {
        [self addViewForStep];
    }else if(self.currentNaviType == 1){
        [self addViewForStep];
    }else if(self.currentNaviType == 3){
    
    }
}

-(void)loadView
{
    [super loadView];
}

-(void)addViewForStep
{
    if (self.route.paths.count == 0) {
        
        return;
    }
    
    stepPath = self.route.paths[0];
    
    NSString *simpleInfo = [NSString stringWithFormat:@"约%ld分钟（%ld米）",stepPath.duration/60, (long)stepPath.distance];
    
    UILabel *labelTop = [[UILabel alloc] initWithFrame:CGRectMake(26, 64, GAO_SIZE.width - 40, 60)];
    labelTop.text = simpleInfo;
    labelTop.font = [UIFont systemFontOfSize:16];
    labelTop.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:labelTop];
    
    [self addTableView];
}

-(void)addTableView
{
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+60, GAO_SIZE.width, GAO_SIZE.height - (64+60))];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = [UIView new];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableview];
    
    [self.tableview registerClass:[OutNaviDetailBaseCell class] forCellReuseIdentifier:@"basecell"];
    [self.tableview registerClass:[OutNaviStartCell class] forCellReuseIdentifier:@"celltop"];
    [self.tableview registerClass:[OutNaviStartCell class] forCellReuseIdentifier:@"cellbottom"];
}

#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return stepPath.steps.count + 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OutNaviDetailBaseCell *cell = nil;
    
    if (indexPath.row == 0) {
        OutNaviStartCell *startCell = [tableView dequeueReusableCellWithIdentifier:@"celltop"];
        startCell.type = 0;
        startCell.titlelabel.text = @"起点";
        cell = startCell;
    }else if(indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1)
    {
         OutNaviStartCell *endCell = [tableView dequeueReusableCellWithIdentifier:@"cellbottom"];
        endCell.type = 1;
        endCell.titlelabel.text = @"终点";
        cell = endCell;
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"basecell"];
        AMapStep *step = stepPath.steps[indexPath.row - 1];
//        [GaoMapTool collectionActions:step.action];
        
        [self configCellFor:cell step:step];
        [cell setTitle:step.instruction];
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return OutNaviBaseCellHeight;
}

#pragma mark -

-(void)testRoute
{
    NSMutableString *str = [[NSMutableString alloc] init];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, GAO_SIZE.width, 500)];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
    
    [str appendFormat:@"taxi %f\n",self.route.taxiCost];
    [str appendFormat:@"transits:%ld\n",self.route.transits.count];
    [str appendFormat:@"paths:%ld\n\n",self.route.paths.count];
    
    [str appendFormat:@"paths:\n"];
    for (AMapPath *path in self.route.paths) {
        [str appendFormat:@"distance:%ld duration:%ld strategy:%@ steps:%ld tolls:%f tollDistance:%ld\n",path.distance,path.duration,path.strategy,path.steps.count,path.tolls,path.tollDistance];
        for (AMapStep *step in path.steps) {
            [str appendFormat:@"step --  instruction:%@, orientation:%@, road:%@, distance:%ld duration:%ld polyline:%@, aciton:%@ assistantAction:%@, tolls:%f, tollDistance:%ld, tollRoad:%@, cities:%@ \n",step.instruction,step.orientation, step.road, step.distance, step.duration, step.polyline, step.action, step.assistantAction, step.tolls, step.tollDistance, step.tollRoad, step.cities];
        }
        [str appendFormat:@"\n"];
    }
    
    [str appendFormat:@"\n\ntransite:\n"];
    for (AMapTransit *tran in self.route.transits) {
        [str appendFormat:@"transite -- cost:%f duration:%ld nightflag:%d walkingDistance:%ld segments:%ld\n",tran.cost,tran.duration,tran.nightflag,tran.walkingDistance,tran.segments.count];
        for (AMapSegment *seg in tran.segments) {
            [str appendFormat:@"walking:%@ buslines:%@ enterName:%@ exitName:%@, enterPoint:%@ exitPoint:%@\n",seg.walking,seg.buslines,seg.enterName,seg.exitName,seg.enterLocation,seg.exitLocation];
        }
    }
    
    label.text = str;
    label.contentMode = UIViewContentModeTopLeft;
}

-(void)configCellFor:(OutNaviDetailBaseCell *)cell step:(AMapStep *)step
{
    if (step.action.length == 0) {
        cell.iconImage.image = [UIImage imageNamed:step.assistantAction];
    }else {
        if ([step.action rangeOfString:@"向左前方"].location != NSNotFound) {
            cell.iconImage.image = [UIImage imageNamed:@"向左前方"];
        }else if([step.action rangeOfString:@"向右前方"].location != NSNotFound){
             cell.iconImage.image = [UIImage imageNamed:@"向右前方"];
        }else if([step.action rangeOfString:@"向左后方"].location != NSNotFound){
            cell.iconImage.image = [UIImage imageNamed:@"向左后方"];
        }else if([step.action rangeOfString:@"向右后方"].location != NSNotFound){
            cell.iconImage.image = [UIImage imageNamed:@"向右后方"];
        }else if([step.action rangeOfString:@"直行"].location != NSNotFound || [step.action rangeOfString:@"往前走"].location != NSNotFound){
            cell.iconImage.image = [UIImage imageNamed:@"直行"];
        }else {
            cell.iconImage.image = [UIImage imageNamed:step.action];
        }
        
        if (cell.iconImage.image == nil) {
            NSLog(@"没有找到图片:%@",step.action);
        }
    }

}

-(void)dealloc
{
    XLog(@"");
}

@end
