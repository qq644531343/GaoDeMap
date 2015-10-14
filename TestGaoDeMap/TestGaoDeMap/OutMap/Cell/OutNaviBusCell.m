//
//  OutNaviBusCell.m
//  TestGaoDeMap
//
//  Created by libo on 15/10/14.
//  Copyright © 2015年 libo. All rights reserved.
//

#import "OutNaviBusCell.h"
#import "GaoMapHeaders.h"

@interface OutNaviBusCell ()
{
     UIView *circle;
    
    NSString *specialStr;
}
@end

@implementation OutNaviBusCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.iconImage.hidden = YES;
        self.clipsToBounds = YES;
        
        circle = [self getCircleView:[UIColor lightGrayColor] radius:12];
        circle.center = CGPointMake(20+15, 40/2.0);
        [self.contentView addSubview:circle];
    }
    return self;
}

-(void)setIconForString:(NSString *)str
{
    specialStr = str;
    if (str.length == 0) {
        circle.hidden = NO;
        self.iconImage.hidden = YES;
        self.titlelabel.font = [UIFont systemFontOfSize:12];
        self.bottomLine.frame = CGRectMake(0, 0, 0, 0);
    }else {
        circle.hidden = YES;
        self.iconImage.hidden = NO;
        NSRange rangeBuXing = [str rangeOfString:@"步行"];
        if (rangeBuXing.location != NSNotFound) {
            self.iconImage.image = [UIImage imageNamed:@"gao_bus_step"];
        }else{
            self.iconImage.image = [UIImage imageNamed:@"gao_bus_gray"];
        }
        self.titlelabel.font = [UIFont systemFontOfSize:15];
        self.bottomLine.frame = CGRectMake(62, 10, GAO_SIZE.width -40, 0.5);
    }
}

-(void)layoutSubviews
{
    if (specialStr.length == 0) {
        self.titlelabel.center = CGPointMake(self.titlelabel.center.x, 20);
    }
}

@end
