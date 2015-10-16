
//
//  OutBusRouteViewController.m
//  TestGaoDeMap
//
//  Created by libo on 15/10/14.
//  Copyright © 2015年 libo. All rights reserved.
//

#import "OutBusRouteViewController.h"
#import "OutNaviBusCell.h"
#import "OutNaviStartCell.h"

#define LEFT_MARGIN 40

@interface OutBusRouteViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UILabel *busLabel;
    UILabel *infoLabel;
    
    float topmargin;
}

@property (nonatomic, strong) UITableView *tableview;

//路线步骤
@property (nonatomic ,strong)  NSArray *transtep;

@end

@implementation OutBusRouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"公交路线导航详情";
    
    [self addTopView];
    
    [self addTableView];
}

-(void)addTopView
{
    busLabel = [[UILabel alloc] init];
    busLabel.font = [UIFont systemFontOfSize:15];
    busLabel.textColor = [UIColor darkGrayColor];
    busLabel.textAlignment = NSTextAlignmentLeft;
    busLabel.numberOfLines = 0;
    [self.view addSubview:busLabel];
    
    infoLabel = [[UILabel alloc] init];
    infoLabel.font = [UIFont systemFontOfSize:12];
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:infoLabel];
    
    NSString *busline = [GaoMapTool generateBusline:self.transit];
    
    float weith = GAO_SIZE.width - LEFT_MARGIN - 20;
    CGRect busRect = [busline boundingRectWithSize:CGSizeMake(weith, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] context:NULL];
    busLabel.frame = CGRectMake(LEFT_MARGIN, 64+20, weith, busRect.size.height);
    infoLabel.frame = CGRectMake(LEFT_MARGIN, busLabel.frame.origin.y + busLabel.frame.size.height+2, weith, 16);
    
    int stationCount = 0;
    self.transtep = [GaoMapTool getStations:&stationCount transit:self.transit];
    busLabel.text = busline;
    infoLabel.text = [NSString stringWithFormat:@"约%@ 乘车%d站地 步行%@",
                      [GaoMapTool secondsToFormatString:self.transit.duration],
                      stationCount,
                      [GaoMapTool meterToFormatString:self.transit.walkingDistance]
                      ];
    
    topmargin = infoLabel.frame.origin.y + infoLabel.frame.size.height + 20;
}

-(void)addTableView
{
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, topmargin, GAO_SIZE.width, GAO_SIZE.height - topmargin)];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableFooterView = [UIView new];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableview];
    
    [_tableview registerClass:[OutNaviBusCell class] forCellReuseIdentifier:@"cell"];
    [self.tableview registerClass:[OutNaviStartCell class] forCellReuseIdentifier:@"celltop"];
    [self.tableview registerClass:[OutNaviStartCell class] forCellReuseIdentifier:@"cellbottom"];

}

#pragma mark - UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2 + self.transtep.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(section > 0 && section < 1 + self.transtep.count){
        return [self.transtep[section - 1] count];
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        OutNaviStartCell *startCell = [tableView dequeueReusableCellWithIdentifier:@"celltop" ];
        if (!startCell) {
            startCell = [[OutNaviStartCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:@"celltop"];
        }
        startCell.type = 0;
        startCell.titlelabel.text = @"起点";
        cell = startCell;

    }else if(indexPath.section > 0 && indexPath.section < 1 + self.transtep.count){
        
        OutNaviBusCell *buscell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
        if (!buscell) {
            buscell = [[OutNaviBusCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:@"cell"];
        }
        
        NSString *str = self.transtep[indexPath.section - 1][indexPath.row];
        [buscell setTitle:str];
        if (indexPath.row == 0) {
            [buscell setIconForString:str];
        }else {
            [buscell setIconForString:nil];
        }
        cell = buscell;
    }else{
        
        OutNaviStartCell *endCell = [tableView dequeueReusableCellWithIdentifier:@"cellbottom" ];
        if (!endCell) {
            endCell = [[OutNaviStartCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:@"cellbottom"];
        }
        
        endCell.type = 1;
        endCell.titlelabel.text = @"终点";
        cell = endCell;

    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return OutNaviBaseCellHeight;
    }else if(indexPath.section > 0 && indexPath.section < 1 + self.transtep.count){
        if (indexPath.row == 0) {
            return 50;
        }else {
            return 40;
        }
    }else{
        return OutNaviBaseCellHeight;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.backBtnClicked) {
        self.backBtnClicked();
    }
    [self.navigationController popViewControllerAnimated:NO];
    
}


#pragma mark - Other



@end
