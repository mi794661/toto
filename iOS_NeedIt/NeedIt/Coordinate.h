//
//  Coordinate.h
//  Inspect
//
//  Created by uv on 14/12/13.
//  Copyright (c) 2014年 George. All rights reserved.
//

#ifndef Inspect_Coordinate_h
#define Inspect_Coordinate_h


#define LOGINZHANGHAO 15/48
#define LOGINMIMA 19/48

//获取当前屏幕的高度和宽度
#define SELF_VIEW_Width [[UIScreen mainScreen] bounds].size.width
#define SELF_VIEW_Height [[UIScreen mainScreen] bounds].size.height


// 获取当前系统相关信息
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define NUMBERS @"0123456789\n"


#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define PROPORTION_Width SELF_VIEW_Width/320
#define PROPORTION_Height SELF_VIEW_Height/568


#define ISPHONE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone?YES:NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)


#endif