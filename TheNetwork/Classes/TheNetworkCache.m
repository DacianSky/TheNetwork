//
//  TheNetworkCache.m
//  TheNetwork
//
//  Created by TheMe on 7/5/16.
//  Copyright © 2016 sdqvsqiu@gmail.com. All rights reserved.
//

#import "TheNetworkCache.h"
#import "TheCacheData.h"
#import "NSString+TheNetwork.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface TheNetworkCache()

@property (nonatomic,assign) BOOL connect;

@end

@implementation TheNetworkCache
@synthesize cachePool = _cachePool;

- (BOOL)willSendRequest:(TheNetworkRequest *)handle withCallback:(RequestCacheCallback)callback
{
    // NetworkCacheTypeCacheDefault
    BOOL sendRequestFlag = YES;
    BOOL useCacheFlag = NO;
    
    id<TheBeanInterface> bean = handle.bean;
    TheNetworkAPI *api = bean.beanApi;
    
    if (api.isNeedRefreshCache) {
        return sendRequestFlag;
    }
    
    self.connect = [[self class] requestBeforeJudgeConnect];
    
    id cacheResponse = [self readCache:bean];
    if ([api.cacheType rangeOfString:NetworkCacheTypeNoCache].location != NSNotFound) {
        sendRequestFlag = YES;
        useCacheFlag = NO;
    }else if ([api.cacheType rangeOfString:NetworkCacheTypeCacheFirst].location != NSNotFound) {
        if (!cacheResponse) {
            sendRequestFlag = NO;
            useCacheFlag = YES;
        }else{
            sendRequestFlag = YES;
            useCacheFlag = NO;
        }
    }else if ([api.cacheType rangeOfString:NetworkCacheTypeCacheForever].location != NSNotFound) {
        sendRequestFlag = NO;
        useCacheFlag = YES;
    }else if([api.cacheType rangeOfString:NetworkCacheTypeRecall].location != NSNotFound){
        sendRequestFlag = YES;
        useCacheFlag = YES;
    }
    
    if (!self.connect) {
        sendRequestFlag = NO; //没有数据无法请求网络
        useCacheFlag = YES;
    }
    
    if (useCacheFlag) {
        if (cacheResponse) {
            !callback?:callback(handle,cacheResponse);
        }else{
            sendRequestFlag = YES; //没有数据必须网络请求
        }
    }
    
    return sendRequestFlag;
}

- (BOOL)writeCache:(id<TheBeanInterface>)bean response:(id)responseObject
{
    BOOL flag;
    if (!responseObject) {
        return NO;
    }
    if (![responseObject respondsToSelector:@selector(encodeWithCoder:)]) {
        return NO;
    }
    
    TheNetworkAPI *api = bean.beanApi;
    
    if ([api.cacheType rangeOfString:NetworkCacheTypeNoCache].location != NSNotFound) {
        return NO;
    }
    
    TheCacheData *cacheData = [[TheCacheData alloc] init];
    cacheData.url = api.apiUrl;
    cacheData.extraParameter = bean.actualParams;
    cacheData.cacheData = responseObject;
    cacheData.timestamp = [[NSDate date] timeIntervalSince1970];
    cacheData.cacheDuration = api.cacheDuration;
    
    NSString *key = [self keyWithBean:bean];
    [self writeCachePool:api.cacheType key:key data:cacheData];
    flag = YES;
    
    return flag;
}

- (id)readCache:(id<TheBeanInterface>)bean
{
    TheNetworkAPI *api = bean.beanApi;
    
    NSString *key = [self keyWithBean:bean];
    TheCacheData *cacheData = [self readCachePool:api.cacheType key:key];
    
    id responseData = cacheData.cacheData;
    if (!self.connect || [api.cacheType isEqualToString:NetworkCacheTypeCacheForever]) {
        return responseData;
    }
    
    // 每次获取数据缓存数据，抓取数据时根据缓存剩余时间判定是否使用本地数据
    if (cacheData.timestamp + cacheData.cacheDuration <= [[NSDate date] timeIntervalSince1970]) {
        return nil;
    }
    
    return responseData;
}

- (id)readCacheForce:(id<TheBeanInterface>)bean
{
    TheNetworkAPI *api = bean.beanApi;
    NSString *key = [self keyWithBean:bean];
    TheCacheData *cacheData = [self readCachePool:api.cacheType key:key];
    return cacheData.cacheData;
}

#pragma mark - 
// 获得缓存key
- (NSString *)keyWithBean:(id<TheBeanInterface>)bean
{
    TheNetworkAPI *api = bean.beanApi;
    
    NSMutableDictionary *parameter = [bean.actualParams mutableCopy];
    NSString *key = parameter[@"apiUrl"];
    
    if ([api.cacheType rangeOfString:NetworkCacheTypeCacheWithParameter].location != NSNotFound) {
        [parameter removeObjectForKey:@"apiUrl"];
        key = [NSString urlDictToStringWithUrlStr:key WithDict:parameter];
    }
    return key;
}

#pragma mark - cache operation
- (instancetype)init
{
    if (self = [super init]) {
        [self buildCachePool];
    }
    return self;
}

- (void)buildCachePool
{
    NSMutableDictionary *cachePool = [@{} mutableCopy];
    NSArray *allCacheType = [TheNetworkAPI allNetworkCacheType];
    for (NSString *cacheType in allCacheType) {
        cachePool[cacheType] = [self configCache:cacheType];
    }
    self.cachePool = cachePool;
}

- (id)configCache:(NSString *)cacheType
{
    NSCache *cache = [[NSCache alloc] init];;
    cache.countLimit = 50;
//        cache.totalCostLimit = 10 * 1024 * 1024;
    return cache;
}

- (void)clearCache
{
    [self.cachePool enumerateKeysAndObjectsUsingBlock:^(NSString *cacheType, NSCache *cache, BOOL * _Nonnull stop) {
        [cache removeAllObjects];
    }];
}

- (void)writeCachePool:(NSString *)cacheType key:(NSString *)key data:(TheCacheData *)cacheData
{
    id cache = self.cachePool[cacheType];
    if (!cache) {
        cache = [self configCache:cacheType];
        self.cachePool[cacheType] = cache;
    }
    [cache setObject:cacheData forKey:key];
}

- (TheCacheData *)readCachePool:(NSString *)cacheType key:(NSString *)key
{
    id cache = self.cachePool[cacheType];
    if (!cache) {
        cache = [self configCache:cacheType];
        self.cachePool[cacheType] = cache;
    }
    return [self.cachePool[cacheType] objectForKey:key];
}

#pragma mark -

//检测网络是否可以使用
+ (BOOL)requestBeforeJudgeConnect
{
    struct sockaddr zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sa_len = sizeof(zeroAddress);
    zeroAddress.sa_family = AF_INET;
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    if (!didRetrieveFlags) {
        printf("Error. Count not recover network reachability flags\n");
        return NO;
    }
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL isNetworkEnable  =(isReachable && !needsConnection) ? YES : NO;
    
    return isNetworkEnable;
}

@end
