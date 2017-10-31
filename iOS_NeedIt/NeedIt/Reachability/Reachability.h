/*
 Copyright (c) 2011, Tony Million.
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE. 
 
 使用说明：
 Reachability.h中定义了三种网络状态：
 typedef enum {
 NotReachable = 0,      //无连接
 ReachableViaWiFi,      //使用3G/GPRS网络
 ReachableViaWWAN      //使用WiFi网络
 } NetworkStatus;
 
 因此可以这样检查网络状态：
 
 Reachability *r = [Reachability reachabilityWithHostName:@“www.apple.com”];
 switch ([r currentReachabilityStatus]) {
 case NotReachable:
 // 没有网络连接
 break;
 case ReachableViaWWAN:
 // 使用3G网络
 break;
 case ReachableViaWiFi:
 // 使用WiFi网络
 break;
 }
 
 3.检查当前网络环境
 程序启动时，如果想检测可用的网络环境，可以像这样
 // 是否wifi
 + (BOOL) IsEnableWIFI {
 return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
 }
 
 // 是否3G
 + (BOOL) IsEnable3G {
 return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
 }
 例子：
 - (void)viewWillAppear:(BOOL)animated {
 if (([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable) &&
 ([Reachability reachabilityForLocalWiFi].currentReachabilityStatus == NotReachable)) {
 self.navigationItem.hidesBackButton = YES;
 [self.navigationItem setLeftBarButtonItem:nil animated:NO];
 }
 }
 
 4. 链接状态的实时通知
 网络连接状态的实时检查，通知在网络应用中也是十分必要的。接续状态发生变化时，需要及时地通知用户：
 
 Reachability 1.5版本
 // My.AppDelegate.h
 #import "Reachability.h"
 
 @interface MyAppDelegate : NSObject <UIApplicationDelegate> {
 NetworkStatus remoteHostStatus;
 }
 
 @property NetworkStatus remoteHostStatus;
 
 @end
 
 // My.AppDelegate.m
 #import "MyAppDelegate.h"
 
 @implementation MyAppDelegate
 @synthesize remoteHostStatus;
 
 // 更新网络状态
 - (void)updateStatus {
 self.remoteHostStatus = [[Reachability sharedReachability] remoteHostStatus];
 }
 
 // 通知网络状态
 - (void)reachabilityChanged:(NSNotification *)note {
 [self updateStatus];
 if (self.remoteHostStatus == NotReachable) {
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"AppName", nil)
 message:NSLocalizedString (@"NotReachable", nil)
 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
 [alert show];
 [alert release];
 }
 }
 
 // 程序启动器，启动网络监视
 - (void)applicationDidFinishLaunching:(UIApplication *)application {
 
 // 设置网络检测的站点
 [[Reachability sharedReachability] setHostName:@"www.apple.com"];
 [[Reachability sharedReachability] setNetworkStatusNotificationsEnabled:YES];
 // 设置网络状态变化时的通知函数
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:)
 name:@"kNetworkReachabilityChangedNotification" object:nil];
 [self updateStatus];
 }
 
 - (void)dealloc {
 // 删除通知对象
 [[NSNotificationCenter defaultCenter] removeObserver:self];
 [window release];
 [super dealloc];
 }
 
 Reachability 2.0版本
 
 
 // MyAppDelegate.h
 @class Reachability;
 
 @interface MyAppDelegate : NSObject <UIApplicationDelegate> {
 Reachability *hostReach;
 }
 
 @end
 
 // MyAppDelegate.m
 - (void)reachabilityChanged:(NSNotification *)note {
 Reachability* curReach = [note object];
 NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
 NetworkStatus status = [curReach currentReachabilityStatus];
 
 if (status == NotReachable) {
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AppName""
 message:@"NotReachable"
 delegate:nil
 cancelButtonTitle:@"YES" otherButtonTitles:nil];
 [alert show];
 [alert release];
 }
 }
 
 - (void)applicationDidFinishLaunching:(UIApplication *)application {
 // ...
 
 // 监测网络情况
 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(reachabilityChanged:)
 name: kReachabilityChangedNotification
 object: nil];
 hostReach = [[Reachability reachabilityWithHostName:@"www.google.com"] retain];
 hostReach startNotifer];
 // ...
 }
 
 */

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

/**
 * Does ARC support GCD objects?
 * It does if the minimum deployment target is iOS 6+ or Mac OS X 8+
 *
 * @see http://opensource.apple.com/source/libdispatch/libdispatch-228.18/os/object.h
 **/
#if OS_OBJECT_USE_OBJC
#define NEEDS_DISPATCH_RETAIN_RELEASE 0
#else
#define NEEDS_DISPATCH_RETAIN_RELEASE 1
#endif

/** 
 * Create NS_ENUM macro if it does not exist on the targeted version of iOS or OS X.
 *
 * @see http://nshipster.com/ns_enum-ns_options/
 **/
#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

extern NSString *const kReachabilityChangedNotification;

typedef NS_ENUM(NSInteger, NetworkStatus) {
    // Apple NetworkStatus Compatible Names.
    NotReachable = 0,
    ReachableViaWiFi = 2,
    ReachableViaWWAN = 1
};

@class Reachability;

typedef void (^NetworkReachable)(Reachability * reachability);
typedef void (^NetworkUnreachable)(Reachability * reachability);

@interface Reachability : NSObject

@property (nonatomic, copy) NetworkReachable    reachableBlock;
@property (nonatomic, copy) NetworkUnreachable  unreachableBlock;


@property (nonatomic, assign) BOOL reachableOnWWAN;

+(Reachability*)reachabilityWithHostname:(NSString*)hostname;
+(Reachability*)reachabilityForInternetConnection;
+(Reachability*)reachabilityWithAddress:(const struct sockaddr_in*)hostAddress;
+(Reachability*)reachabilityForLocalWiFi;

-(Reachability *)initWithReachabilityRef:(SCNetworkReachabilityRef)ref;

-(BOOL)startNotifier;
-(void)stopNotifier;

-(BOOL)isReachable;
-(BOOL)isReachableViaWWAN;
-(BOOL)isReachableViaWiFi;

// WWAN may be available, but not active until a connection has been established.
// WiFi may require a connection for VPN on Demand.
-(BOOL)isConnectionRequired; // Identical DDG variant.
-(BOOL)connectionRequired; // Apple's routine.
// Dynamic, on demand connection?
-(BOOL)isConnectionOnDemand;
// Is user intervention required?
-(BOOL)isInterventionRequired;

-(NetworkStatus)currentReachabilityStatus;
-(SCNetworkReachabilityFlags)reachabilityFlags;
-(NSString*)currentReachabilityString;
-(NSString*)currentReachabilityFlags;

@end
