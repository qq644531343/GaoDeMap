//
//  GaoBaseAnnotationView.m
//  TestGaoDeMap
//
//  Created by libo on 15/10/8.
//  Copyright © 2015年 libo. All rights reserved.
//

#import "GaoBaseAnnotationView.h"

@implementation GaoBaseAnnotationView

- (id)initWithAnnotation:(id <MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        [self addLabel];
        [self setColor:GaoAnnoColorBlue];
    }
    return self;
}

-(void)addLabel
{
    //设置中心点偏移，使得标注底部中间点成为经纬度对应点
    self.centerOffset = CGPointMake(0, -18);
    
    self.labelText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.labelText.text = @"";
    self.labelText.font = [UIFont systemFontOfSize:12];
    self.labelText.textColor = [UIColor whiteColor];
    self.labelText.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.labelText];
}

-(void)setColor:(GaoAnnoColor)color
{
    _color = color;
    switch (color) {
        case GaoAnnoColorRed:
            self.image = [UIImage imageNamed:@"gao_anno_red"];
            break;
        case GaoAnnoColorBlue:
             self.image = [UIImage imageNamed:@"gao_anno_blue"];
            break;
        default:
            break;
    }
}

@end
