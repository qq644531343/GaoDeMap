//
//  OutNaviBaseCell.m
//  TestGaoDeMap
//
//  Created by libo on 15/10/13.
//  Copyright © 2015年 libo. All rights reserved.
//

#import "OutNaviDetailBaseCell.h"
#import "GaoMapHeaders.h"

@implementation OutNaviDetailBaseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.horizonLine = [[UIView alloc] initWithFrame:CGRectMake(20+15-1, 0, 2, OutNaviBaseCellHeight)];
        self.horizonLine.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.horizonLine];
       
        self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        self.iconImage.image = [UIImage imageNamed:@"Group657"];
        self.iconImage.center = CGPointMake(20+15, OutNaviBaseCellHeight/2.0 + 4);
        self.iconImage.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.iconImage];
        
        self.titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 15, GAO_SIZE.width-85, 30)];
        self.titlelabel.font = [UIFont systemFontOfSize:15];
        self.titlelabel.textColor = [UIColor darkGrayColor];
        self.titlelabel.textAlignment = NSTextAlignmentLeft;
        self.titlelabel.numberOfLines = 0;
        [self.contentView addSubview:self.titlelabel];
        
        self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(self.titlelabel.frame.origin.x, OutNaviBaseCellHeight-0.5, GAO_SIZE.width - self.titlelabel.frame.origin.x - 25, 0.5)];
        self.bottomLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        [self.contentView addSubview:self.bottomLine];
        
    }
    return self;
}

//画一个圆
-(UIView *)getCircleView:(UIColor *)borderColor radius:(float)radius
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, radius, radius)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderColor = borderColor.CGColor;
    view.layer.borderWidth = 1;
    view.layer.cornerRadius = view.frame.size.width/2.0;
    return view;
}

-(void)setTitle:(NSString *)title
{

    self.titlelabel.text = title;
    
    CGRect titlesize = [title boundingRectWithSize:CGSizeMake(self.titlelabel.frame.size.width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] context:NULL];
    if(titlesize.size.height > 45){
        self.titlelabel.frame = CGRectMake(62, 2, GAO_SIZE.width-85, 48);
        self.titlelabel.font = [UIFont systemFontOfSize:12];
    }else if(titlesize.size.height > 18){
        self.titlelabel.frame = CGRectMake(62, 10, GAO_SIZE.width-85, 35);
        self.titlelabel.font = [UIFont systemFontOfSize:14];
    }else {
        self.titlelabel.frame = CGRectMake(62, 15, GAO_SIZE.width-85, 30);
        self.titlelabel.font = [UIFont systemFontOfSize:15];
    }
}

@end
