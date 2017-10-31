//
//  QRCode.h
//  QinWillWine
//
//  Created by xujunquan on 15/12/28.
//  Copyright © 2015年 Wisdom Box Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QRCode : NSObject

+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size;

@end
