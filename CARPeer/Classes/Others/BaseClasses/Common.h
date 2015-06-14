
//1.是否为ios6系统
#define IsIOS6 ([[[UIDevice currentDevice] systemVersion] floatValue] >=6.0&&[[[UIDevice currentDevice] systemVersion] floatValue]<7.0 ? YES : NO)

//2.是否为ios7系统
#define IsIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0&&[[[UIDevice currentDevice] systemVersion] floatValue]<8.0 ? YES : NO)

//3.是否为ios8系统
#define IsIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0 ? YES : NO)

//4.是否为iPhone5
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//5.是否为iPhone4
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

//6.是否为iPhone6
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

//7.是否为iPhone6 Plus
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

//8.获取设备的物理高度

#define kScreenHeight (IsIOS6?([UIScreen mainScreen].bounds.size.height)-20.0:[UIScreen mainScreen].bounds.size.height)

//9.获取设备的物理宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

//10.定义导航栏的高度
#define kNavigationH (IsIOS6?44:64)

//11.获取设备的系统版本
#define CurrentSystemVersion [[[UIDevice currentDevice] systemVersion] intValue]

//12.日志输出宏定义
#ifdef DEBUG
// 调试状态
#define MyLog(...) NSLog(__VA_ARGS__)
#else
// 发布状态
#define MyLog(...)
#endif

// 13.默认的动画时间
#define kDefaultAnimDuration 0.3

// 14.定义自定义button宽
#define kButtonW ((kScreenWidth-30)/2)

// 15.定义自定义button高
#define kButtonH kButtonW

// 16.定义间距大小
#define kSpacing 10

// 17定义statusBar高度
#define kStatusBarH 20

// 18定义背景颜色
#define kBackgroundColor [UIColor colorWithRed:(CGFloat)233/255 green:(CGFloat)231/255 blue:(CGFloat)233/255 alpha:1.0]
//#define kBackgroundColor [UIColor whiteColor]

// 19.定义头视图高度
#define kHeaderViewHeight (kScreenWidth>320?125:100)

// 20.定义io6下screenHeight（不包括导航栏）
#define kIOS6or7ScreenHeight (IsIOS6?(kScreenHeight-kNavigationH):kScreenHeight)

// 21.定义黄金比例
#define kGoldenRatio 0.618

// 22.定义省份表名
#define KTXProvinceModel @"TXProvinceModel"

// 23.定义城市表名
#define kTXCitiesModel @"TXCitiesModel"

// 24.定义区域表名
#define kTXAreaModel @"TXAreaModel"

#import "APIManage.h"

#import "NSManagedObject+BaseModel.h"

#import "EGOCache.h"

#import <CoreData/CoreData.h>

#import "Reachability.h"



