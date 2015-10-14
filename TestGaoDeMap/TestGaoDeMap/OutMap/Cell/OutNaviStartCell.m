//
//  OutNaviStartCell.m
//  TestGaoDeMap
//
//  Created by libo on 15/10/13.
//  Copyright © 2015年 libo. All rights reserved.
//

#import "OutNaviStartCell.h"

@interface OutNaviStartCell ()
{
    UIView *circle;
}

@end

@implementation OutNaviStartCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.iconImage.hidden = YES;
        self.clipsToBounds = YES;
        
        circle = [self getCircleView:[UIColor redColor] radius:18];
        circle.center = CGPointMake(20+15, OutNaviBaseCellHeight/2.0+3);
        [self.contentView addSubview:circle];
        
        self.bottomLine.hidden = YES;
    }
    return self;
}

-(void)setType:(int)type
{
    _type = type;
    CGRect lineframe = self.horizonLine.frame;
    float topmargin = circle.frame.size.height + circle.frame.origin.y;
    
    if (type == 0) {
        circle.layer.borderColor = [UIColor blueColor].CGColor;
        self.horizonLine.frame = CGRectMake(lineframe.origin.x, topmargin, lineframe.size.width, OutNaviBaseCellHeight -topmargin );
    }else if(type == 1){
        circle.layer.borderColor = [UIColor redColor].CGColor;
        self.horizonLine.frame = CGRectMake(lineframe.origin.x, 0, lineframe.size.width, circle.frame.origin.y);

    }
}

@end
