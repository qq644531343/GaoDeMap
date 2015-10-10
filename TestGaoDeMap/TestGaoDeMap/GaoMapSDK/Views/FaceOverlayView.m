//
//  FaceOverlayView.m
//  CustomOverlayViewDemo
//
//  Created by songjian on 13-3-12.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "FaceOverlayView.h"

@interface FaceOverlayView ()

@property (nonatomic) CGPoint *glPoints2;
@property (nonatomic) NSUInteger glPoint2Count;

@property (nonatomic) CGPoint *linePoints;
@property (nonatomic) NSUInteger linePointCount;

@end

@implementation FaceOverlayView
@synthesize glPoints2       = _glPoints2;
@synthesize glPoint2Count   = _glPoint2Count;
@synthesize linePoints      = _linePoints;
@synthesize linePointCount  = _linePointCount;

#pragma mark - Utility

/* The caller should be responsible for releasing memory. */
- (MAMapPoint *)circleMapPointsForCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate radius:(CLLocationDistance)radius outCount:(NSUInteger *)outCount
{
    CGFloat hypotenuse = MAMapPointsPerMeterAtLatitude(centerCoordinate.latitude) * radius;
    MAMapPoint centerMapPoint = MAMapPointForCoordinate(centerCoordinate);
    
#define INCISION_PRECISION 360
    MAMapPoint *points = (MAMapPoint*)malloc(INCISION_PRECISION * sizeof(MAMapPoint));
    for (int i = 0; i < INCISION_PRECISION; i++)
    {
        CGFloat radian  = i * M_PI / 180.f;
        CGFloat xOffset = sin(radian) * hypotenuse;
        CGFloat yOffset = cos(radian) * hypotenuse;
        
        points[i].x = centerMapPoint.x + xOffset;
        points[i].y = centerMapPoint.y + yOffset;
    }
    
    if (outCount != NULL)
    {
        *outCount = INCISION_PRECISION;
    }
    
    return points;
}

- (void)drawCircleWithPoints:(CGPoint *)points pointCount:(NSUInteger)pointCount
{
    if (points == NULL || pointCount < 3)
    {
        return;
    }
    
    ///使用新方法
    [self renderStrokedRegionWithPoints:points pointCount:pointCount fillColor:self.fillColor strokeColor:self.strokeColor strokeLineWidth:[self glWidthForWindowWidth:self.lineWidth] strokeLineJoinType:self.lineJoinType strokeLineDash:YES usingTriangleFan:YES];
    
//    /* Drawing internal. */
//    [self renderRegionWithPoints:points pointCount:pointCount fillColor:self.fillColor usingTriangleFan:YES];
//    
//    /* Drawing outline. */
//    [self renderLinesWithPoints:points pointCount:pointCount strokeColor:self.strokeColor lineWidth:[self glWidthForWindowWidth:self.lineWidth] looped:YES LineJoinType:self.lineJoinType LineCapType:self.lineCapType lineDash:self.lineDash];
}

- (void)drawLineWithPoints:(CGPoint *)points pointCount:(NSUInteger)pointCount
{
    if (points == NULL || pointCount < 2)
    {
        return;
    }
    
    /* Drawing line. */
    [self renderLinesWithPoints:points pointCount:pointCount strokeColor:self.strokeColor lineWidth:[self glWidthForWindowWidth:self.lineWidth] looped:NO LineJoinType:self.lineJoinType LineCapType:self.lineCapType lineDash:self.lineDash];
}

#pragma mark - Interface

- (void)referenceDidChange
{
    [super referenceDidChange];
    
    FaceOverlay *faceOverlay = (FaceOverlay*)self.overlay;
    
    /* Construct left circle OpenGLES points. */
    NSUInteger count = 0;
    MAMapPoint *leftCircleMapPoints = [self circleMapPointsForCenterCoordinate:faceOverlay.leftEyeCoordinate radius:faceOverlay.leftEyeRadius outCount:&count];
    
    /* self.glPoints memeoy has been released in [super referenceDidChange]. */
    self.glPoints = [self glPointsForMapPoints:leftCircleMapPoints count:count];
    self.glPointCount = count;
    
    free(leftCircleMapPoints), leftCircleMapPoints = NULL;
    
    /* Release prior memory. */
    if (self.glPoints2 != NULL)
    {
        free(self.glPoints2), self.glPoints2 = NULL;
        
        self.glPoint2Count = 0;
    }
    
    /* Construct right circle OpenGLES points. */
    MAMapPoint *rightCircleMapPoints = [self circleMapPointsForCenterCoordinate:faceOverlay.rightEyeCoordinate radius:faceOverlay.rightEyeRadius outCount:&count];
    
    self.glPoints2 = [self glPointsForMapPoints:rightCircleMapPoints count:count];
    self.glPoint2Count = count;
    
    free(rightCircleMapPoints), rightCircleMapPoints = NULL;
    
    /* Release prior memory. */
    if (self.linePoints != NULL)
    {
        free(self.linePoints), self.linePoints = NULL;
        
        self.linePointCount = 0;
    }
    
    /* Construct line OpenGLES points. */
    self.linePoints = (CGPoint*)malloc(2 * sizeof(CGPoint));
    self.linePoints[0] = [self glPointForMapPoint:MAMapPointForCoordinate(faceOverlay.leftEyeCoordinate)];
    self.linePoints[1] = [self glPointForMapPoint:MAMapPointForCoordinate(faceOverlay.rightEyeCoordinate)];
    self.linePointCount = 2;
}

- (FaceOverlay *)faceOverlay
{
    return (FaceOverlay*)self.overlay;
}

#pragma mark - Override

- (void)glRender
{
    /* Drawing left circle. */
    [self drawCircleWithPoints:self.glPoints pointCount:self.glPointCount];
    
    /* Drawing right circle. */
    [self drawCircleWithPoints:self.glPoints2 pointCount:self.glPoint2Count];
    
    /* Drawing line. */
    [self drawLineWithPoints:self.linePoints pointCount:self.linePointCount];
}

#pragma mark - Life Cycle

- (id)initWithFaceOverlay:(FaceOverlay *)faceOverlay;
{
    self = [super initWithOverlay:faceOverlay];
    if (self)
    {
        
    }
    
    return self;
}

- (void)dealloc
{
    if (_glPoints2 != NULL)
    {
        free(_glPoints2), _glPoints2 = NULL;
    }
    
    if (_linePoints != NULL)
    {
        free(_linePoints), _linePoints = NULL;
    }
}

@end
