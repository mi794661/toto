//
//  ZTNetRequest.h
//  BOOOP
//
//  Created by booop on 15/1/31.
//  Copyright (c) 2015年 booop. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MBProgressHUD.h"
//#import "ErrorCode.h"
#import "AFHTTPRequestOperationManager.h"

@interface ZTNetRequest : NSObject <UIAlertViewDelegate>
{
    NSInteger NetworkStatus;
    NSDictionary *oldParameters;
}

+ (ZTNetRequest *)request;

- (void)requestUrl:(NSString *)url;

- (void) requestAction:(NSString *)action
           aParameters:(NSDictionary *)parameters
          aPlaceholder:(NSString *)placeholder
          cacheEnabled:(BOOL)cacheEnabled
       successComplete:(void (^)(NSDictionary *source))successComplete;

- (void) uploadImage:(NSString *)imageName
         aParameters:(NSDictionary *)parameters
           imageData:(NSData *)imageData
        aPlaceholder:(NSString *)placeholder
     successComplete:(void (^)(NSDictionary *source))successComplete;

- (void) clearCache;
- (void) backNetworkQueue;
- (void) getToken:(void (^)(NSDictionary *source))successComplete;
@end
