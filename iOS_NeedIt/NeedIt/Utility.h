//
//  Utility.h
//  ZTML
//
//  Created by 周涛 on 14/11/6.
//  Copyright (c) 2014年 long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utility : NSObject

+ (void)topAlertView:(NSString *)message;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (void)startTime:(UIButton *)sender;

+ (CGSize)getTextString:(NSString *)text textFont:(UIFont *)font frameWidth:(float)width;

+ (NSString *)currentTime:(NSDate *)data;

+ (NSString *)changeTime:(NSString *)timeStamp dataFormat:(NSString *)dataFormat;

+ (NSString *)md5:(NSString *)str;

+ (NSString *)getNetWorkStates;

+ (UIWindow *)mainWindow;

+ (NSString *)compareTime:(int)timeStr;

+ (NSString *)getAstroWithTime:(NSString *)timeStr;

+ (NSString *)changeDataStr:(NSString *)tempStr;

+ (void)setBadgeValue:(NSString*)val atTabIndex:(int)index atTabbarController:(UITabBarController *)tabbarController;

+ (void)adjustViewCoordinate:(NSArray *)array;

+ (NSString *)getCurrentDeviceModel;//获取手机型号-ma

+ (NSString *)getDeviceIDFA;//获取手机idfa-ma

+ (NSString *)encodeToPercentEscapeString: (NSString *) input;//encode string

+ (NSMutableDictionary *)sortArray:(NSArray *)sortArray;

+ (void)showImageListToSourceDic:(NSDictionary *)sourceDic selectIndex:(NSInteger)selectIndex;

+ (void)showLogin;

+ (void)showBindingPhone;//绑定手机

+ (void)sendAlipay:(NSDictionary *)orderInfo;   //支付宝支付

+ (void)sendWXPay:(NSDictionary *)orderInfo;    //微信支付

+ (BOOL)isPureInt:(NSString *)string;

+ (UIImage *)getStartPageImage:(NSString *)name;

+ (void)gotoupdateapp:(NSString *)info;
@end
