1,  pod 引入：
        pod 'AMapSearch'
        pod 'AMapNavi'  #导航，包含AMap3DMap

2， 在GaoMapHeaders.h中设置AppKey，此AppKey与bundleId一一对应

3,  info.plist根路径下配置
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
    </dict>

    <key>LSApplicationQueriesSchemes</key>
    <array>
        <string>iosamap</string>
    </array>

4， 允许使用定位，在info.plist根路径下配置：
    <key>NSLocationAlwaysUsageDescription</key>
        <string>请允许喵街使用GPS</string>
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>请允许喵街使用GPS</string>

5， 针对iOS9 需在info.plist中配置如下允许http
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
    </dict>
6， Xcode7编译兼容问题，需在buildsetting中设置ENABLE_BITCODE为no
