//
//  TheNetworkAPI.m
//  TheNetwork
//
//  Created by TheMe on 6/24/16.
//  Copyright © 2016 sdqvsqiu@gmail.com. All rights reserved.
//

#import "TheNetworkAPI.h"

NSString *const NetworkCacheTypeNoCache = @"NetworkCacheTypeNoCache";
NSString *const NetworkCacheTypeCacheDefault = @"NetworkCacheTypeCacheDefault";
NSString *const NetworkCacheTypeCacheWithParameter = @"NetworkCacheTypeCacheWithParameter";
NSString *const NetworkCacheTypeCacheForever = @"NetworkCacheTypeCacheForever";
NSString *const NetworkCacheTypeRecall = @"NetworkCacheTypeRecall";


@implementation TheNetworkAPI

+ (NSArray *)allNetworkCacheType
{
    return @[NetworkCacheTypeNoCache,NetworkCacheTypeCacheDefault,NetworkCacheTypeCacheWithParameter,NetworkCacheTypeCacheForever,NetworkCacheTypeRecall];
}

+ (TheNetworkAPI *)networkAPI:(NSString *)apiUrl
{
    return [[TheNetworkAPI alloc] initWithApiName:apiUrl];
}

- (instancetype)initWithApiName:(NSString *)apiUrl
{
    if (self = [super init]) {
        _apiUrl = apiUrl;
        _cacheType = NetworkCacheTypeCacheDefault;  //默认缓存类型，有网使用网络请求数据，无网使用缓存
        _cacheDuration = 0;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        NSString *const kNetworkApiUrl = @"apiUrl";
        NSString *const kNetworkApiRequestType = @"requestType";
        NSString *const kNetworkApiResponseType = @"responseType";
        NSString *const kNetworkApiCacheType = @"cacheType";
        NSString *const kNetworkApiCacheDuration = @"cacheDuration";
        NSString *const kNetworkApiRefreshCache = @"refreshCache";
        NSString *const kNetworkApiVersion = @"version";
        
        if(![dict[kNetworkApiUrl] isKindOfClass:[NSNull class]]){
            self.apiUrl = dict[kNetworkApiUrl];
        }
        
        if(![dict[kNetworkApiRequestType] isKindOfClass:[NSNull class]]){
            self.requestType = [dict[kNetworkApiRequestType] integerValue];
        }
        
        if(![dict[kNetworkApiResponseType] isKindOfClass:[NSNull class]]){
            self.responseType = [dict[kNetworkApiResponseType] integerValue];
        }
        
        if(![dict[kNetworkApiCacheType] isKindOfClass:[NSNull class]]){
            self.cacheType = dict[kNetworkApiCacheType];
        }else{
            if (self.requestType == NetWorkRequestTypeGet) {
                self.cacheType = NetworkCacheTypeCacheDefault;
            }else{
                self.cacheType = NetworkCacheTypeNoCache;
            }
        }
        
        if(![dict[kNetworkApiCacheDuration] isKindOfClass:[NSNull class]]){
            self.cacheDuration = [dict[kNetworkApiCacheDuration] integerValue];
        }
        
        if(![dict[kNetworkApiRefreshCache] isKindOfClass:[NSNull class]]){
            self.refreshCache = [dict[kNetworkApiRefreshCache] boolValue];
        }
        
        if(![dict[kNetworkApiVersion] isKindOfClass:[NSNull class]]){
            self.version = dict[kNetworkApiVersion];
        }
        
        [self modelCustomTransformFromDictionary:dict];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    TheNetworkAPI *api = [[TheNetworkAPI alloc] init];
    api.apiUrl = [self.apiUrl copy];
    api.requestType = self.requestType;
    api.responseType = self.responseType;
    api.cacheType = self.cacheType;
    api.cacheDuration = self.cacheDuration;
    api.refreshCache = self.refreshCache;
    api.version = [self.version copy];
    return api;
}

- (void)setcacheDuration:(NSInteger)cacheDuration
{
    if(cacheDuration < 0){
        _cacheDuration = NSIntegerMax;
    }else{
        _cacheDuration = cacheDuration;
    }
}

// for YYModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dict {
    NSString *cacheType = dict[@"cacheType"];
    if ([[TheNetworkAPI allNetworkCacheType] containsObject:cacheType]) {
        _cacheType = cacheType;
    }
    if (!_cacheType){
        _cacheType = NetworkCacheTypeCacheDefault;
    }
    return YES;
}

@end
