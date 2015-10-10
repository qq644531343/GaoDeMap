//
//  MANaviRoute.m
//  OfficialDemo3D
//
//  Created by yi chen on 1/7/15.
//  Copyright (c) 2015 songjian. All rights reserved.
//

#import "MANaviRoute.h"
#import "CommonUtility.h"

#define kMANaviRouteReplenishPolylineFilter     8

@interface MANaviRoute()

@property (nonatomic, assign) BOOL anntationVisible;
@property (nonatomic, weak) MAMapView *mapView;

@end

@implementation MANaviRoute

- (void)addToMapView:(MAMapView *)mapView
{
    self.mapView = mapView;
    
    if ([self.routePolylines count] > 0)
    {
        [mapView addOverlays:self.routePolylines];
    }
    
    if (self.anntationVisible && [self.naviAnnotations count] > 0)
    {
        [mapView addAnnotations:self.naviAnnotations];
    }
}

- (void)removeFromMapView
{
    if (self.mapView == nil)
    {
        return;
    }
    
    if ([self.routePolylines count] > 0)
    {
        [self.mapView removeOverlays:self.routePolylines];
    }
    
    if (self.anntationVisible && [self.naviAnnotations count] > 0)
    {
        [self.mapView removeAnnotations:self.naviAnnotations];
    }
    
    self.mapView = nil;
}

- (void)setNaviAnnotationVisibility:(BOOL)visible
{
    if (visible == self.anntationVisible)
    {
        return;
    }
    
    self.anntationVisible = visible;
    
    if (self.mapView == nil)
    {
        return;
    }
    
    if (self.anntationVisible)
    {
        [self.mapView addAnnotations:self.naviAnnotations];
    }
    else
    {
        [self.mapView removeAnnotations:self.naviAnnotations];
    }
}

#pragma mark - Format Search Result

/* naviRoute parsed from search result. */

+ (MANaviRoute *)naviRouteForWalking:(AMapWalking *)walking
{
    if (walking == nil || walking.steps.count == 0)
    {
        return nil;
    }
    
    NSMutableArray *polylines = [NSMutableArray array];
    NSMutableArray *naviAnnotations = [NSMutableArray array];
    
    [walking.steps enumerateObjectsUsingBlock:^(AMapStep *step, NSUInteger idx, BOOL *stop) {
        
        MAPolyline *stepPolyline = [self polylineForStep:step];
        
        if (stepPolyline != nil)
        {
            MANaviPolyline *naviPolyline = [[MANaviPolyline alloc] initWithPolyline:stepPolyline];
            naviPolyline.type = MANaviAnnotationTypeWalking;
            
            [polylines addObject:naviPolyline];
            
            MANaviAnnotation * annotation = [[MANaviAnnotation alloc] init];
            annotation.coordinate = MACoordinateForMapPoint(stepPolyline.points[0]);
            annotation.type = MANaviAnnotationTypeWalking;
            annotation.title = step.instruction;
            [naviAnnotations addObject:annotation];
            
            if (idx > 0)
            {
                [self replenishPolylinesForWalkingWith:stepPolyline LastPolyline:[self polylineForStep:[walking.steps objectAtIndex:idx - 1]] Polylines:polylines Walking:walking];
            }
        }
        
    }];
    
    return [MANaviRoute naviRouteForPolylines:polylines andAnnotations:naviAnnotations];
}

+ (MANaviRoute *)naviRouteForSegment:(AMapSegment *)segment segmentIdx:(NSUInteger)idx
{
    if (segment == nil)
    {
        return nil;
    }
    
    NSMutableArray *polylines = [NSMutableArray array];
    NSMutableArray *annotations = [NSMutableArray array];
    
    MANaviRoute *walkingRoute = [self naviRouteForWalking:segment.walking];
    if ([walkingRoute.routePolylines count] > 0)
    {
        [polylines addObjectsFromArray:walkingRoute.routePolylines];
    }
    if ([walkingRoute.naviAnnotations count] > 0)
    {
        [annotations addObjectsFromArray:walkingRoute.naviAnnotations];
    }

    AMapBusLine *firstLine = [segment.buslines firstObject];
    MAPolyline *busLinePolyline = [MANaviRoute polylineForBusLine:firstLine];
    if (busLinePolyline != nil)
    {
        MANaviPolyline *naviPolyline = [[MANaviPolyline alloc] initWithPolyline:busLinePolyline];
        naviPolyline.type = MANaviAnnotationTypeBus;

        [polylines addObject:naviPolyline];
        
        MANaviAnnotation * bus = [[MANaviAnnotation alloc] init];
        bus.coordinate = MACoordinateForMapPoint(busLinePolyline.points[0]);
        bus.type = MANaviAnnotationTypeBus;
        bus.title = firstLine.name;
        [annotations addObject:bus];
    }
    
    [self replenishPolylinesForSegment:walkingRoute.routePolylines busLinePolyline:busLinePolyline Segment:segment polylines:polylines];
    
    return [MANaviRoute naviRouteForPolylines:polylines andAnnotations:annotations];
    
}

/* polyline parsed from search result. */

+ (MAPolyline *)polylineForStep:(AMapStep *)step
{
    if (step == nil)
    {
        return nil;
    }
    
    return [CommonUtility polylineForCoordinateString:step.polyline];
}

+ (MAPolyline *)polylineForBusLine:(AMapBusLine *)busLine
{
    if (busLine == nil)
    {
        return nil;
    }
    
    return [CommonUtility polylineForCoordinateString:busLine.polyline];
}

/* replenish. */

+ (void)replenishPolylinesForWalkingWith:(MAPolyline *)stepPolyline
                           LastPolyline:(MAPolyline *)lastPolyline
                              Polylines:(NSMutableArray *)polylines
                                Walking:(AMapWalking *)walking
{
    CLLocationCoordinate2D startCoor ;
    CLLocationCoordinate2D endCoor;
    
    [stepPolyline getCoordinates:&endCoor   range:NSMakeRange(0, 1)];
    [lastPolyline getCoordinates:&startCoor range:NSMakeRange(lastPolyline.pointCount -1, 1)];
    
    if (endCoor.latitude != startCoor.latitude || endCoor.longitude != startCoor.longitude)
    {
        LineDashPolyline *dashPolyline = [self replenishPolylineWithStart:startCoor end:endCoor];
        if (dashPolyline)
        {
            [polylines addObject:dashPolyline];
        }
    }
}

+ (void)replenishPolylinesForSegment:(NSArray *)walkingPolylines
                     busLinePolyline:(MAPolyline *)busLinePolyline
                             Segment:(AMapSegment *)segment
                           polylines:(NSMutableArray *)polylines
{
    if (walkingPolylines.count != 0)
    {
        AMapGeoPoint *walkingEndPoint = segment.walking.destination;
        
        if (busLinePolyline)
        {
            CLLocationCoordinate2D startCoor;
            CLLocationCoordinate2D endCoor ;
            [busLinePolyline getCoordinates:&startCoor range:NSMakeRange(0, 1)];
            [busLinePolyline getCoordinates:&endCoor range:NSMakeRange(busLinePolyline.pointCount-1, 1)];
            
            if (startCoor.latitude != walkingEndPoint.latitude || startCoor.longitude != walkingEndPoint.longitude)
            {
                endCoor = CLLocationCoordinate2DMake(walkingEndPoint.latitude, walkingEndPoint.longitude);
                
                LineDashPolyline *dashPolyline = [self replenishPolylineWithStart:startCoor end:startCoor];
                if (dashPolyline)
                {
                    [polylines addObject:dashPolyline];
                }
            }
        }
    }
    
}

+ (void)replenishPolylinesForTransit:(AMapSegment *)lastSegment
                      CurrentSegment:(AMapSegment * )segment
                           Polylines:(NSMutableArray *)polylines
{
    if (lastSegment)
    {
        CLLocationCoordinate2D startCoor;
        CLLocationCoordinate2D endCoor;

        MAPolyline *busLinePolyline = [self polylineForBusLine:[(lastSegment).buslines firstObject]];
        if (busLinePolyline != nil)
        {
            [busLinePolyline getCoordinates:&startCoor range:NSMakeRange(busLinePolyline.pointCount-1, 1)];
        }
        else
        {
            if ((lastSegment).walking && [(lastSegment).walking.steps count] != 0)
            {
                startCoor.latitude  = (lastSegment).walking.destination.latitude;
                startCoor.longitude = (lastSegment).walking.destination.longitude;
            }
            else
            {
                return;
            }
        }
        
        if ((segment).walking && [(segment).walking.steps count] != 0)
        {
            AMapStep *step = [(segment).walking.steps objectAtIndex:0];
            MAPolyline *stepPolyline = [self polylineForStep:step];
            
            [stepPolyline getCoordinates:&endCoor range:NSMakeRange(0 , 1)];
        }
        else
        {
            AMapBusLine *firstLine = [segment.buslines firstObject];
            MAPolyline *busLinePolyline = [self polylineForBusLine:firstLine];
            if (busLinePolyline != nil)
            {
                [busLinePolyline getCoordinates:&endCoor range:NSMakeRange(0 , 1)];
            }
            else
            {
                return;
            }
        }
        
        LineDashPolyline *dashPolyline = [self replenishPolylineWithStart:startCoor end:endCoor];
        if (dashPolyline)
        {
            [polylines addObject:dashPolyline];
        }
    }
}

+ (void)replenishPolylinesForPathWith:(MAPolyline *)stepPolyline
                         lastPolyline:(MAPolyline *)lastPolyline
                            Polylines:(NSMutableArray *)polylines
{
    CLLocationCoordinate2D startCoor;
    CLLocationCoordinate2D endCoor;
    
    [stepPolyline getCoordinates:&endCoor range:NSMakeRange(0, 1)];
    
    [lastPolyline getCoordinates:&startCoor range:NSMakeRange(lastPolyline.pointCount -1, 1)];
    
    
    if ((endCoor.latitude != startCoor.latitude || endCoor.longitude != startCoor.longitude ))
    {
        LineDashPolyline *dashPolyline = [self replenishPolylineWithStart:startCoor end:endCoor];
        if (dashPolyline)
        {
            [polylines addObject:dashPolyline];
        }
    }
}

+ (LineDashPolyline *)replenishPolylineWithStart:(CLLocationCoordinate2D)startCoor end:(CLLocationCoordinate2D)endCoor
{
    double distance = MAMetersBetweenMapPoints(MAMapPointForCoordinate(startCoor), MAMapPointForCoordinate(endCoor));
    
    LineDashPolyline *dashPolyline = nil;
    
    // 过滤一下，距离比较近就不加虚线了
    if (distance > kMANaviRouteReplenishPolylineFilter)
    {
        CLLocationCoordinate2D points[2];
        points[0] = startCoor;
        points[1] = endCoor;
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:points count:2];
        dashPolyline = [[LineDashPolyline alloc] initWithPolyline:polyline];
    }
    
    return dashPolyline;
}

#pragma mark - Life Cycle

+ (instancetype)naviRouteForTransit:(AMapTransit *)transit
{
    return [[self alloc] initWithTransit:transit];
}

+ (instancetype)naviRouteForPath:(AMapPath *)path withNaviType:(MANaviAnnotationType)type
{
    return [[self alloc] initWithPath:path withNaviType:type];
}

+ (instancetype)naviRouteForPolylines:(NSArray *)polylines andAnnotations:(NSArray *)annotations
{
    return [[self alloc] initWithPolylines:polylines andAnnotations:annotations];
}

- (instancetype)initWithPolylines:(NSArray *)polylines andAnnotations:(NSArray *)annotations
{
    self = [self init];
    
    if (self)
    {
        self.routePolylines = polylines;
        self.naviAnnotations = annotations;
    }
    
    return self;
}

- (instancetype)initWithTransit:(AMapTransit *)transit
{
    self = [self init];
    
    if (self == nil)
    {
        return nil;
    }
    
    if (transit == nil || transit.segments.count == 0)
    {
        return self;
    }
    
    NSMutableArray *polylines = [NSMutableArray array];
    NSMutableArray *anntations = [NSMutableArray array];
    
    [transit.segments enumerateObjectsUsingBlock:^(AMapSegment *segment, NSUInteger idx, BOOL *stop) {
        
        MANaviRoute * routeSegment = [MANaviRoute naviRouteForSegment:segment segmentIdx:idx];
        
        if (routeSegment.routePolylines.count != 0)
        {
            [polylines addObjectsFromArray:routeSegment.routePolylines];
        }
        if (routeSegment.naviAnnotations.count != 0)
        {
            [anntations addObjectsFromArray:routeSegment.naviAnnotations];
        }
        
        if (idx >0)
        {
            [MANaviRoute replenishPolylinesForTransit:[transit.segments objectAtIndex:idx-1] CurrentSegment:segment Polylines:polylines];
        }
    }];
    
    self.routePolylines = polylines;
    self.naviAnnotations = anntations;
    
    return self;

}

- (instancetype)initWithPath:(AMapPath *)path withNaviType:(MANaviAnnotationType)type
{
    self = [self init];
    
    if (self == nil)
    {
        return nil;
    }
    
    if (path == nil || path.steps.count == 0)
    {
        return self;
    }
    
    NSMutableArray *polylines = [NSMutableArray array];
    NSMutableArray *naviAnnotations = [NSMutableArray array];
    
    [path.steps enumerateObjectsUsingBlock:^(AMapStep *step, NSUInteger idx, BOOL *stop) {
        
        MAPolyline *stepPolyline = [MANaviRoute polylineForStep:step];
        
        if (stepPolyline != nil)
        {
            MANaviPolyline *naviPolyline = [[MANaviPolyline alloc] initWithPolyline:stepPolyline];
            naviPolyline.type = type;
            
            [polylines addObject:naviPolyline];
            
            if (idx > 0)
            {
                MANaviAnnotation * annotation = [[MANaviAnnotation alloc] init];
                annotation.coordinate = MACoordinateForMapPoint(stepPolyline.points[0]);
                annotation.type = type;
                annotation.title = step.instruction;
                [naviAnnotations addObject:annotation];
            }
            
            if (idx > 0)
            {
                [MANaviRoute replenishPolylinesForPathWith:stepPolyline
                                       lastPolyline:[MANaviRoute polylineForStep:[path.steps objectAtIndex:idx-1]]
                                          Polylines:polylines];
            }
        }
    }];
    
    self.routePolylines = polylines;
    self.naviAnnotations = naviAnnotations;
    
    return self;
}


- (id)init
{
    self = [super init];
    if (self)
    {
        self.anntationVisible = YES;
        self.routeColor = [UIColor blueColor];
        self.walkingColor = [UIColor blueColor];
    }
    
    return self;
}

@end
