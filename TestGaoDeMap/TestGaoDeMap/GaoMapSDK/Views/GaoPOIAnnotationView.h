//
//  GaoPOIAnnotationView.h
//  TestGaoDeMap
//
//  Created by libo on 15/10/26.
//  Copyright © 2015年 libo. All rights reserved.
//

#import <AMapNaviKit/AMapNaviKit.h>

@interface GaoPOIAnnotationView : MAAnnotationView

@property (nonatomic,strong) UIImageView *baseIcon;

@property (nonatomic,strong) UIImageView *annotationIcon;

@property (nonatomic,strong) UILabel *titlelabel;

@end
