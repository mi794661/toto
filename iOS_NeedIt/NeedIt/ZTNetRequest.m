//
//  ZTNetRequest.m
//  BOOOP
//
//  Created by booop on 15/1/31.
//  Copyright (c) 2015年 booop. All rights reserved.
//

#import "ZTNetRequest.h"
#import "JSONKit.h"
#import <AdSupport/ASIdentifierManager.h>  
#import "INTERFACE.h"
//#import "Utility.h"
NSString * const spm_dataIdentifier = @"spm.datacache.tg";

@interface ZTDataCache : NSObject

@property (nonatomic, strong) NSString      *cachePath;
@property (nonatomic, strong) NSFileManager *fileManager;

- (void)setData:(NSDictionary *)dic forURL:(NSString *)URL;
- (NSDictionary *)getDataForURL:(NSString *)URL;
- (void)removeCache;
@end

static ZTNetRequest *zr = nil;

@interface ZTNetRequest ()
{
    AFHTTPRequestOperationManager *_manager;
//    MBProgressHUD *HUD;
//    ErrorCode *_errorCode;
}

@property (strong, nonatomic) ZTDataCache *cache;
@end

@implementation ZTNetRequest

+ (ZTNetRequest *)request
{
    @synchronized(self)
    {
        if (zr == nil) {
            zr = [[self alloc] init];
        }
        return zr;
    }
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        _cache = [[ZTDataCache alloc] init];
        _manager = [AFHTTPRequestOperationManager manager];
//        _errorCode = [[ErrorCode alloc] init];
        NetworkStatus = 10;
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            NetworkStatus = status;
            if (NetworkStatus != 0 || NetworkStatus != -1) {
                [self backNetworkQueue];
            }
        }];
    }
    return self;
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)showHUD:(NSString *)HUDtitle
{
//    if (HUD == nil) {
//        HUD = [[MBProgressHUD alloc] initWithView:[Utility mainWindow]];
//        [[Utility mainWindow] addSubview:HUD];
//    }
//    [HUD setLabelText:HUDtitle];
//    [HUD show:YES];
}

//组合URL后面带的参数
- (NSString *)combinationParams:(NSDictionary *)params
{
    if ([[params allKeys] count] == 0) {
        return @"";
    }
    NSMutableString *result = [[NSMutableString alloc] init];
    [result appendString:@"/"];
    for (NSString *key in [params allKeys]) {
        [result appendFormat:@"%@:%@/", key, [params objectForKey:key]];
    }
    return [result substringToIndex:result.length-1];
}


- (void)requestUrl:(NSString *)url
{
    [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}




- (void)requestAction:(NSString *)action aParameters:(NSDictionary *)parameters aPlaceholder:(NSString *)placeholder cacheEnabled:(BOOL)cacheEnabled successComplete:(void (^)(NSDictionary *source))successComplete
{

        if (placeholder && ![placeholder isEqualToString:@""]) {
            [self showHUD:placeholder];
        }
    
    
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [_manager POST:action parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

            if (placeholder && ![placeholder isEqualToString:@""])
//                [HUD hide:YES];
            NSLog(@"收到网络信息 = %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"收到网络信息 = %@", dic);
            NSLog(@"%@", operation);
            NSInteger status = [dic[@"status"] intValue];
            NSString *err_msg = [dic objectForKey:@"err_msg"];
            NSLog(@"err_msg = %@",err_msg);
                                 
                oldParameters = nil;
                successComplete(dic);
                if (cacheEnabled) {
                    NSString *cachePath = [action stringByAppendingFormat:@"%@", [self combinationParams:parameters]];
                    [_cache setData:dic forURL:cachePath];
//                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
//            [HUD hide:YES];
            
            if ([[parameters objectForKey:@"c"] isEqualToString:@"token.index"]) {
                NSString *cachePath = [action stringByAppendingFormat:@"%@", [self combinationParams:parameters]];
                NSDictionary *cacheSource = [_cache getDataForURL:cachePath];
                if (cacheSource) {
                    NSLog(@"收到缓存信息 = %@", cacheSource);
                    successComplete(cacheSource);
                }
            }
        }];
 
}


- (void) uploadImage:(NSString *)imageName
         aParameters:(NSDictionary *)parameters
           imageData:(NSData *)imageData
        aPlaceholder:(NSString *)placeholder
     successComplete:(void (^)(NSDictionary *source))successComplete
{
//    [self showHUD:kPlaceholder];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:CS_REQUEST_ADVERTISINGLIST parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"photo.jpg" mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (placeholder && ![placeholder isEqualToString:@""]){
//            [HUD hide:YES];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"收到网络信息 = %@", dic);
        NSLog(@"%@", operation);
        NSInteger status = [dic[@"status"] intValue];
        if (status != 200) {
            if (status == 401) {
//                token失效 请重新登录
//                oldParameters = parameters;
//                [self getToken:^(NSDictionary *source) {}];
            }
            if (status == 402) {
//                设备与用户绑定不一致，检测到这个错误，强制退出
//                DEFAULTS_INFO(@"NO", @"LoginFlag");
//                DEFAULTS_SYNCHRONIZE;
//                [Utility showLogin];
            }
            if (status == 403) {
//                没有登录
//                DEFAULTS_INFO(@"NO", @"LoginFlag");
//                DEFAULTS_SYNCHRONIZE;
//                [Utility showLogin];
            }
//            [Utility topAlertView:dic[@"errmsg"]];
        }
        else
        {
            oldParameters = nil;
            successComplete(dic);
        }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
//        [HUD hide:YES];
    }];
}


- (void) clearCache
{
    [_cache removeCache];
}

- (void) backNetworkQueue
{
//    dispatch_queue_t queue = dispatch_queue_create("gcdtest.rongfzh.yc", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [[ZTNetRequest request] requestAction:@"" aParameters:@{@"cmd": [NSNumber numberWithInt:1014]} aPlaceholder:nil aShowHUD:NO cacheEnabled:YES successComplete:^(NSDictionary *source) {
//            DEFAULTS_INFO([source objectForKey:@"host_url"], @"ImageHost");
//            DEFAULTS_SYNCHRONIZE;
//        }];
//    });
    
//    dispatch_async(queue, ^{
//        if (LOGINFLAG && [LOGINFLAG isEqualToString:@"YES"]) {
//            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//            [parameters setObject:[NSNumber numberWithInt:([User_Type intValue] == 1)?1009:1010] forKey:@"cmd"];
//            [parameters setObject:[NSNumber numberWithInt:[User_ID intValue]] forKey:@"user_id"];
//            [parameters setObject:User_Token forKey:@"token"];
//            [parameters setObject:[NSNumber numberWithInteger:0] forKey:@"page_index"];
//            [parameters setObject:[NSNumber numberWithInteger:100] forKey:@"page_size"];
//            [parameters setObject:[NSNumber numberWithInteger:0] forKey:@"id_index"];
//            [[ZTNetRequest request] requestAction:@"" aParameters:parameters aPlaceholder:nil aShowHUD:NO cacheEnabled:YES successComplete:^(NSDictionary *source) {
//                DEFAULTS_INFO(source[@"item"], @"UserFriend");
//            }];
//        }
//    });
}

- (void)getToken:(void (^)(NSDictionary *))successComplete
{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    [parameters setObject:@"token.index" forKey:@"c"];
//    [parameters setObject:[NSNumber numberWithInt:SC_DEVICE_SIZE.width*2] forKey:@"w"];
//    [parameters setObject:[NSNumber numberWithInt:SC_DEVICE_SIZE.height*2] forKey:@"h"];
//    [parameters setObject:App_Version forKey:@"v"];
//    [parameters setObject:System_Model forKey:@"model"];
//    [parameters setObject:@"1" forKey:@"client"];
//    [parameters setObject:[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] forKey:@"deviceid"];
//    if (LOGINFLAG && [LOGINFLAG isEqualToString:@"YES"]) {
//        [parameters setObject:User_Info[@"member_id"] forKey:@"uid"];
//    }
//    [parameters setObject:CHANNEL_ID forKey:@"channel"];
//    [[ZTNetRequest request] requestAction:@"" aParameters:parameters aPlaceholder:nil cacheEnabled:YES successComplete:^(NSDictionary *source) {
//        DEFAULTS_INFO(source[@"token"], @"UserToken");
//        DEFAULTS_INFO(source[@"deltalist"], @"Delta_Info");
//        DEFAULTS_SYNCHRONIZE;
//        
//        successComplete(source);
//    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    exit(0);
}
@end

@implementation ZTDataCache

- (instancetype)init {
    self = [super init];
    if(self) {
        NSArray  *paths         = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *rootCachePath = [paths firstObject];
        
        _fileManager    = [NSFileManager defaultManager];
        _cachePath      = [rootCachePath stringByAppendingPathComponent:spm_dataIdentifier];
        
        if(![_fileManager fileExistsAtPath:spm_dataIdentifier]) {
            [_fileManager createDirectoryAtPath:_cachePath withIntermediateDirectories:NO attributes:nil error:nil];
        }
    }
    return self;
}

- (void)setData:(NSDictionary *)dic forURL:(NSString *)URL
{
    NSString *fileExtension = [[URL componentsSeparatedByString:@"/"] lastObject];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dic forKey:@"Some Key Value"];
    [archiver finishEncoding];
    [data writeToFile:[_cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu.%@", (unsigned long)URL.hash, fileExtension]] atomically:YES];
}

- (NSDictionary *)getDataForURL:(NSString *)URL
{
    NSString *fileExtension = [[URL componentsSeparatedByString:@"/"] lastObject];
    NSString *path = [_cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu.%@", (unsigned long)URL.hash, fileExtension]];
    if([_fileManager fileExistsAtPath:path]) {
        
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSDictionary *myDictionary = [unarchiver decodeObjectForKey:@"Some Key Value"];
        [unarchiver finishDecoding];
        return myDictionary;
    }
    return nil;
}

- (void)removeCache
{
    if ([_fileManager fileExistsAtPath:_cachePath]) {
        [_fileManager removeItemAtPath:_cachePath error:nil];
    }
}
@end