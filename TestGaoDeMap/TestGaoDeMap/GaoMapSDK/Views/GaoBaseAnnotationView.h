//
//  GaoBaseAnnotationView.h
//  TestGaoDeMap
//
//  Created by libo on 15/10/8.
//  Copyright © 2015年 libo. All rights reserved.
//

#import <AMapNaviKit/AMapNaviKit.h>
#import "GaoBaseAnnotation.h"

typedef enum GaoAnnoColor
{
    GaoAnnoColorRed,
    GaoAnnoColorBlue
}GaoAnnoColor;

@interface GaoBaseAnnotationView : MAAnnotationView

@property (nonatomic ,strong) UILabel *labelText;

@property (nonatomic ,readwrite) GaoAnnoColor color;

@end
