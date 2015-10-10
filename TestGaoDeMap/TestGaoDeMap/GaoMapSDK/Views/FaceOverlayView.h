//
//  FaceOverlayView.h
//  CustomOverlayViewDemo
//
//  Created by songjian on 13-3-12.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <AMapNaviKit/MAOverlayPathView.h>
#import "FaceOverlay.h"

/**
 *  圆形标注/脸型
 */

@interface FaceOverlayView : MAOverlayPathView

- (id)initWithFaceOverlay:(FaceOverlay *)faceOverlay;

@property (nonatomic, readonly) FaceOverlay *faceOverlay;

@end
