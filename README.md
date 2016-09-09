# GaoDeMap
iOS高德地图的封装和使用

采用pod进行管理

主要封装了地图、POI、导航、搜索、编码等

`
 git pull 或 download code后，命令行运行：
 cd TestGaoDeMap
 pod install
 打开TestGaoDeMap.xcworkspace即可运行并查看代码
`
#使用代码
将GaoMapSDK拷贝到你的工程中，在podfile中引入

pod 'AMapNavi' , '1.3.1' #导航，包含AMap3DMap

pod 'AMapCloudMap'

<em>注意：如果你的工程不是cocoapods管理的，直接拷贝demo中的AMapCloudKit.framework和AMapNaviKit.framework到你工程即可</em>

**根据Readme.txt对工程进行配置**
具体使用，请参看demo。

简单使用：

```
//导入头文件
#import "GaoMapHeaders.h"

//初始化配置
[[GaoMapConfig sharedConfig] setup];
//添加地图
[self addMap];

//添加地图
-(void)addMap
{
    self.mapview = [GaoMapView getMapViewWithFrame:CGRectMake(0, 0, GAO_SIZE.width, GAO_SIZE.height) parentView:self.view];
    [self.mapview.mapManager showUserLocationPoint];
    [self.mapview defaultSetting];
    
    __weak OutMapViewController *weakself = self;
    self.mapview.mapManager.clickedAnnotation = ^(id<MAAnnotation> annotation, MAAnnotationView *annotationView){
        if(annotation == nil){
           //点击了空白 
        }else {
           //点击了标注 
        }
    };
}

```

##Api Docs
GaoMapView：地图View

GaoMapManager：地图覆盖物、定位

GaoMapSearchManager：搜索、导航


```
/**
 *  地图View
 *  主要用于显示
 */
@interface GaoMapView : MAMapView

+(GaoMapView *)getMapViewWithFrame:(CGRect)frame parentView:(UIView *)parentView;

-(void)defaultSetting;

@property (nonatomic ,readonly, strong) GaoMapManager *mapManager;

@property (nonatomic ,readonly, strong) GaoMapSearchManager *searchManager;

/**
 *  导航至目标点
 *
 *  @param dest 目标点
 *  @param type 1自驾 2公交 3步行
 *  @param strategy 导航策略，具体请参照GaoMapSearchManager
 */
-(void)naviMineToDest:(GaoBaseAnnotation *)dest type:(int)type strategy:(NSInteger)strategy finished:(void (^)(AMapRoute *route))block;

/**
 *  设置定位icon、缩放icon与地图底部的间距
 */
-(void)setOutBtnBottomMargin:(float)bottom animation:(BOOL)animated;

/**
 *  标注AMapTip
 */
-(void)addMyAnnotationTip:(AMapTip *)tip;

/**
 *  标注AMapPOI
 */
-(void)addMyAnnotationPois:(NSArray *)pois;

/**
 *  普通标注 GaoBaseAnnotation
 **/
- (void)addMyAnnotationBase:(NSArray *)annotations;

/**
 *  清理map上的annotation和overlay等
 */
- (void)cleanMapView;

/**
 *  释放mapView
 */
- (void)deallocMapView;


@end



/**
 *  地图管理工具
 *  主要处理地图代理、浮层等
 */

@interface GaoMapManager : NSObject <MAMapViewDelegate>

+(GaoMapManager *)getMapManager;

@property (nonatomic , weak) GaoMapView *map;

@property (nonatomic, weak) GaoBaseAnnotationView *selectAnnotationView;

/**
 *  Annotation点击响应
 */
@property (nonatomic, copy) SelectedAnnotation clickedAnnotation;

/**
 *  当前位置Annotation
 */
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;

/**
 *  聚焦用户所在地
 */
-(void)showUserLocationPoint;

/**
 *  用户当前位置信息
 */
@property (nonatomic, strong) AMapReGeocode *userAddress;

@end



/**
 *  地图搜索、导航等的内容管理
 */

@interface GaoMapSearchManager : NSObject

+(GaoMapSearchManager *)getSearchManager;

@property (nonatomic , weak) GaoMapView *map;

#pragma mark - 搜索

/**
 *  根据ID搜索POI
 */
-(void)searchPOIById:(NSString *)uid finish:(SearchFinished)block;

/**
 *  关键字搜索
 */
/* 根据关键字来搜索POI. */
- (void)searchPOIByKeyword:(NSString *)keywords cityCode:(NSString *)cityCode finish:(SearchFinished)block;

/**
 *  周边搜索
 */
- (void)searchPOIArroundByKeywords:(NSString *)keywords location:(CLLocationCoordinate2D)coor radius:(NSInteger)radius finish:(SearchFinished)block;

/**
 *  多边形搜索
 *  points元素为AMapGeoPoint
 */
-(void)searchPOIByKewords:(NSString *)keywords polygons:(NSArray *)points finish:(SearchFinished)block;

#pragma mark - 导航

/**
 *  公交导航搜索
 *  strategy 公交换乘策略：0-最快捷模式；1-最经济模式；2-最少换乘模式；3-最少步行模式；4-最舒适模式；5-不乘地铁模式
 */
-(void)searchNaviBusWithStart:(AMapGeoPoint *)start dest:(AMapGeoPoint *)dest strategy:(NSInteger)strategy cityCode:(NSString *)cityCode finish:(NaviSearchFinished)block;

/**
 *  步行导航搜索
 */
-(void)searchNaviWalkWithStart:(AMapGeoPoint *)start dest:(AMapGeoPoint *)dest  finish:(NaviSearchFinished)block;

/**
 *  驾车导航搜索
 *  strategy 驾车导航策略：0-速度优先（时间）；1-费用优先（不走收费路段的最快道路）；2-距离优先；3-不走快速路；4-结合实时交通（躲避拥堵）；5-多策略（同时使用速度优先、费用优先、距离优先三个策略）；6-不走高速；7-不走高速且避免收费；8-躲避收费和拥堵；9-不走高速且躲避收费和拥堵
 */
-(void)searchNaviDriveWithStart:(AMapGeoPoint *)start dest:(AMapGeoPoint *)dest strategy:(NSInteger)strategy finish:(NaviSearchFinished)block;


#pragma mark - 输入提示

/**
 *  获取输入提示
 *
 *  @param keywords
 *  @param cityName 城市名或城市code
 */
-(void)inputTipsWithKeywords:(NSString *)keywords city:(NSString *)cityName finish:(InputTipsFinished)block;


#pragma mark - 地理编码 

/**
 * 根据 名称 搜索地理位置
 * @param name必选
 * @param cityName可选（可为城市名、code,adcode）
 */
-(void)geoSearchByName:(NSString *)name city:(NSString *)cityName finish:(GeoFinished)block;

/**
 *  根据经纬度查地名
 */
-(void)reverseGeoSearchByCoor:(CLLocationCoordinate2D)coor finish:(RevserGeoFinished)block;

#pragma mark - 云图POI
/**
 *  本地检索
 *  city为必选
 *  refresh为YES刷新，NO为加载更多
 */
-(void)searchCloudPOIWithCity:(NSString *)city keywords:(NSString *)key isRefresh:(BOOL)refresh finish:(SearchFinished)block;

/**
 *  POI ID检索
 *  city为必选
 *  refresh为YES刷新，NO为加载更多
 */
-(void)searchCloudPOIWithID:(NSInteger)ID finish:(SearchFinished)block;

/**
 *  搜索周边POI
 *
 *  @param coor 中心点
 *  @param key  可选关键字
 */
- (void)searchCloudPOIWithPoint:(CLLocationCoordinate2D)coor keywords:(NSString *)key isRefresh:(BOOL)refresh finish:(SearchFinished)block;

@end

```


![](https://github.com/qq644531343/GaoDeMap/blob/master/pics/thumb_IMG_0427_1024.jpg)

![](https://github.com/qq644531343/GaoDeMap/blob/master/pics/thumb_IMG_0428_1024.jpg)

![](https://github.com/qq644531343/GaoDeMap/blob/master/pics/thumb_IMG_0429_1024.jpg)

![](https://github.com/qq644531343/GaoDeMap/blob/master/pics/thumb_IMG_0430_1024.jpg)

![](https://github.com/qq644531343/GaoDeMap/blob/master/pics/thumb_IMG_0431_1024.jpg)

![](https://github.com/qq644531343/GaoDeMap/blob/master/pics/thumb_IMG_0432_1024.jpg)

![](https://github.com/qq644531343/GaoDeMap/blob/master/pics/thumb_IMG_0433_1024.jpg)

![](https://github.com/qq644531343/GaoDeMap/blob/master/pics/thumb_IMG_0434_1024.jpg)


