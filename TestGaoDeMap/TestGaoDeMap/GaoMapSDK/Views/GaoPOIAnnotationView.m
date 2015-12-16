//
//  GaoPOIAnnotationView.m
//  TestGaoDeMap
//
//  Created by libo on 15/10/26.
//  Copyright © 2015年 libo. All rights reserved.
//

#import "GaoPOIAnnotationView.h"

@implementation GaoPOIAnnotationView

- (id)initWithAnnotation:(id <MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        self.clipsToBounds = NO;
        [self addContentView];
    }
    return self;
}

-(void)addContentView{
    
    self.baseIcon = [[UIImageView alloc] initWithFrame:CGRectMake(-10, 0, 15, 15)];
    self.baseIcon.image = [UIImage imageNamed:@"gao_default_mendian"];
    [self addSubview:self.baseIcon];
    
    self.annotationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(-12, -25, 20, 30)];
    self.annotationIcon.image = [UIImage imageNamed:@"gao_anno_red"];
    [self addSubview:self.annotationIcon];
    
    self.titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(-50, 10, 100, 14)];
    self.titlelabel.text = @"这是一个鸡巴";
    self.titlelabel.textAlignment = NSTextAlignmentCenter;
    self.titlelabel.font = [UIFont systemFontOfSize:10];
    self.titlelabel.textColor = [UIColor darkGrayColor];
    [self addSubview:self.titlelabel];
}

@end
