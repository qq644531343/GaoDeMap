//
//  OutBottomView.m
//  TestGaoDeMap
//
//  Created by libo on 15/10/9.
//  Copyright © 2015年 libo. All rights reserved.
//

#import "OutBottomView.h"
#import "GaoMapHeaders.h"
#import "OutMapViewController.h"

#define LEFT_MARGIN 20

@interface OutBottomView ()

@property (nonatomic ,readwrite) float bottomMargin;
@property (nonatomic ,readwrite) float leftMargin;

@end

@implementation OutBottomView

#pragma mark - Init

+(OutBottomView *)addViewOn:(UIView *)baseView marginBottom:(float)bottom marginLeft:(float)left
{
    UIColor *acolor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1.0];
    
    OutBottomView *view = [[OutBottomView alloc] initWithFrame:CGRectMake(left, baseView.frame.size.height - bottom - 100, baseView.frame.size.width - 2*left, 100)];
    view.leftMargin = left;
    view.bottomMargin = bottom;
    view.backgroundColor = [UIColor whiteColor];
    [baseView addSubview:view];
    
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = acolor.CGColor;
    view.layer.cornerRadius = 2.0;
    view.layer.shadowRadius = 2.0;
    view.layer.shadowColor = acolor.CGColor;
    view.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    view.layer.shadowOpacity = 1.0;
    
    return view;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

-(void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    if (hidden) {
        _myHeight = 0;
    }
    
}

-(void)refreshWithData:(AMapRoute *)route tran:(AMapTransit *)transit annotation:(GaoBaseAnnotation *)anno type:(OutBottomType)type
{
    _type = type;
    _myHeight = 0;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (type == OutBottomTypePOI) {
        _myHeight = 138;
        [self addViewForPOI];
        
    }else if(type == OutBottomTypeDest) {
        
        _myHeight = 138;
        CLLocationCoordinate2D coor = [anno coordinate];
        [self addViewForDest:[anno title] address:@""];
        __weak OutBottomView *weakself = self;
        if (self.parentVC) {
            [self.parentVC.mapview.searchManager reverseGeoSearchByCoor:coor finish:^(NSError *error, AMapReGeocode *res) {
                [weakself addViewForDest:[anno title] address:res.formattedAddress];
            }];
        }
        
    }else if(type == OutBottomTypeRoute) {
        
        _myHeight = 60;
        [self addViewForRoute:route tran:transit];
    }
    
    self.frame = CGRectMake(self.leftMargin, self.superview.frame.size.height - self.bottomMargin - _myHeight, self.superview.frame.size.width - 2*self.leftMargin, _myHeight);
}

-(void)addViewForPOI
{
    BOOL ji = YES, hui = YES, cu = YES, zhe = YES;
    
    UIImageView *imageCar = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_MARGIN, 20, 30, 30)];
    imageCar.image = [UIImage imageNamed:@"gao_navi_2H"];
    imageCar.contentMode = UIViewContentModeScaleAspectFit;
    imageCar.backgroundColor = [GaoColorWithRGB(0x3C9BFA) colorWithAlphaComponent:0.2];
    [self addSubview:imageCar];
    
    NSString *name = @"良渚公交中心站";
    UIFont *namefont = [UIFont systemFontOfSize:17];
    CGRect titlebounds = [name boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:namefont,NSFontAttributeName, nil] context:NULL];
    float nameWidth = titlebounds.size.width;
    if (nameWidth > self.frame.size.width - 2*LEFT_MARGIN - 30 - 6 - 60) {
        nameWidth = self.frame.size.width - 2*LEFT_MARGIN - 30 - 6 - (16+2)*4;
    }
    
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN + 30 + 6, 17, nameWidth , 20)];
    labelName.text = name;
    labelName.textAlignment = NSTextAlignmentLeft;
    labelName.font = namefont;
    [self addSubview:labelName];
    
    float left = labelName.frame.origin.x + labelName.frame.size.width + 2;
    float top = 19;
    if (ji) {
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(left, top, 16, 16)];
        icon.image = [UIImage imageNamed:@"instant_offer"];
        [self addSubview:icon];
        left = icon.frame.size.width + icon.frame.origin.x + 2;
    }
    if (hui) {
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(left, top, 16, 16)];
        icon.image = [UIImage imageNamed:@"preferential"];
        [self addSubview:icon];
        left = icon.frame.size.width + icon.frame.origin.x + 2;
    }
    if (cu) {
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(left, top, 16, 16)];
        icon.image = [UIImage imageNamed:@"discount"];
        [self addSubview:icon];
        left = icon.frame.size.width + icon.frame.origin.x + 2;
    }
    if (zhe) {
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(left, top, 16, 16)];
        icon.image = [UIImage imageNamed:@"paytag"];
        [self addSubview:icon];
        left = icon.frame.size.width + icon.frame.origin.x + 2;
    }
    
    NSString *money = @"人均:¥10.0";
    float moneywidth = [money boundingRectWithSize:CGSizeMake(0, 17) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil] context:NULL].size.width;
    
    UILabel *labelAddress = [[UILabel alloc] initWithFrame:CGRectMake(labelName.frame.origin.x, 17+20+2, moneywidth, 17)];
    labelAddress.textAlignment = NSTextAlignmentLeft;
    labelAddress.textColor = [UIColor lightGrayColor];
    labelAddress.font = [UIFont systemFontOfSize:14];
    [self addSubview:labelAddress];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:money];
    [attr addAttribute:NSForegroundColorAttributeName value:GaoColorWithRGB(0xF93B3B) range:NSMakeRange(3, money.length-3)];
    labelAddress.attributedText = attr;
    
    UILabel *labelTips = [[UILabel alloc] initWithFrame:CGRectMake(labelAddress.frame.origin.x+labelAddress.frame.size.width + 15, 17+20+2, 200, 17)];
    labelTips.textAlignment = NSTextAlignmentLeft;
    labelTips.textColor = [UIColor lightGrayColor];
    labelTips.font = [UIFont systemFontOfSize:14];
    labelTips.text = @"早餐 中餐 快餐";
    [self addSubview:labelTips];
    
    UIButton *btnGo = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGo.frame = CGRectMake(LEFT_MARGIN, labelAddress.frame.origin.y + labelAddress.frame.size.height + 18, self.frame.size.width - 2*LEFT_MARGIN, 44);
    btnGo.layer.cornerRadius = 2;
    btnGo.backgroundColor = GaoColorWithRGB(0x3C9BFA);
    [btnGo setTitle:@"带我去" forState:UIControlStateNormal];
    [btnGo setImage:[UIImage imageNamed:@"gao_navi_3"] forState:UIControlStateNormal];
    btnGo.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self addSubview:btnGo];
    
    [btnGo addTarget:self action:@selector(goBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    
}

-(void)addViewForDest:(NSString *)name address:(NSString *)addr
{
    UIImageView *imageCar = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_MARGIN, 20, 30, 30)];
    imageCar.image = [UIImage imageNamed:@"gao_navi_2H"];
    imageCar.contentMode = UIViewContentModeScaleAspectFit;
    imageCar.backgroundColor = [GaoColorWithRGB(0x3C9BFA) colorWithAlphaComponent:0.2];
    [self addSubview:imageCar];
    
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN + 30 + 6, 17,self.frame.size.width - 2*LEFT_MARGIN - 36 , 20)];
    labelName.text = name;
    labelName.textAlignment = NSTextAlignmentLeft;
    [self addSubview:labelName];
    
    UILabel *labelAddress = [[UILabel alloc] initWithFrame:CGRectMake(labelName.frame.origin.x, 17+20+2, labelName.frame.size.width, 17)];
    labelAddress.text = addr;
    labelAddress.textAlignment = NSTextAlignmentLeft;
    labelAddress.textColor = [UIColor lightGrayColor];
    labelAddress.font = [UIFont systemFontOfSize:14];
    [self addSubview:labelAddress];
    
    UIButton *btnGo = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGo.frame = CGRectMake(LEFT_MARGIN, labelAddress.frame.origin.y + labelAddress.frame.size.height + 18, self.frame.size.width - 2*LEFT_MARGIN, 44);
    btnGo.layer.cornerRadius = 2;
    btnGo.backgroundColor = GaoColorWithRGB(0x3C9BFA);
    [btnGo setTitle:@"带我去" forState:UIControlStateNormal];
    [btnGo setImage:[UIImage imageNamed:@"gao_navi_3"] forState:UIControlStateNormal];
    btnGo.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self addSubview:btnGo];
    
    [btnGo addTarget:self action:@selector(goBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)addViewForRoute:(AMapRoute *)route tran:(AMapTransit *)transit
{
    UILabel *labelDistance = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, 0, self.frame.size.width - 2*LEFT_MARGIN - 50, _myHeight)];
    labelDistance.text = @"约0分钟 (0米)";
    labelDistance.textAlignment = NSTextAlignmentLeft;
    [self addSubview:labelDistance];
    
    UIButton *btnGo = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGo.frame = CGRectMake(self.frame.size.width - LEFT_MARGIN - 60, (_myHeight - 40)/2.0, 60, 40);
    btnGo.layer.cornerRadius = 2;
    btnGo.backgroundColor = GaoColorWithRGB(0x3C9BFA);
    [btnGo setTitle:@"详情" forState:UIControlStateNormal];
    [self addSubview:btnGo];
    
    [btnGo addTarget:self action:@selector(goBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //公交
    if (route.paths.count == 0 && transit != nil) {
        
        int stationCount = 0;
        [GaoMapTool getStations:&stationCount transit:transit];
        
         labelDistance.text = [NSString stringWithFormat:@"约%@（共%d站）",
                               [GaoMapTool secondsToFormatString:transit.duration],
                               stationCount
                              ];
    }else {
    //步行和自驾
        AMapPath *path = route.paths[0];
        labelDistance.text = [NSString stringWithFormat:@"约%@（%@）",[GaoMapTool secondsToFormatString:path.duration], [GaoMapTool secondsToFormatString:path.distance]];
    }
   
}

-(void)goBtnClicked:(UIButton *)btn
{
    if (self.btnClicked) {
        self.btnClicked(btn);
    }
}

@end
