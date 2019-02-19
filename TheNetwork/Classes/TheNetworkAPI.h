//
//  TheNetworkAPI.h
//  TheNetwork
//
//  Created by TheMe on 6/24/16.
//  Copyright © 2016 sdqvsqiu@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,NetWorkRequestType){
    NetWorkRequestTypeGet,
    NetWorkRequestTypePost,
    NetWorkRequestTypeDelete,
    NetWorkRequestTypePut,
    NetWorkRequestTypePostForm,
    NetWorkRequestTypeUpload
};

typedef NS_ENUM(NSUInteger,NetWorkResponseType){
    NetWorkResponseTypeNSDictionary,
    NetWorkResponseTypeJson,
    NetWorkResponseTypeXml,
    NetWorkResponseTypeHTTP,
    NetWorkResponseTypeRaw
};

#pragma mark - NetworkCacheType

extern NSString *const NetworkCacheTypeNoCache;
extern NSString *const NetworkCacheTypeCacheDefault;
extern NSString *const NetworkCacheTypeCacheWithParameter;
extern NSString *const NetworkCacheTypeCacheFirst;
extern NSString *const NetworkCacheTypeCacheForever;
extern NSString *const NetworkCacheTypeRecall;

@interface TheNetworkAPI : NSObject<NSCopying>

/*
 eg:
 {
 apiUrl = "https://openapi.war3.ml/1.0/api/Users";
 cacheDuration = 3600;
 cacheType = NetworkCacheTypeCacheDefault;
 requestType = 1;
 version = "1.0";
 }
 */
- (instancetype)initWithDictionary:(NSDictionary *)dict;

/**
 *  @author thou, 16-06-24 09:06:08
 *
 *  @brief api接口值
 *
 *  @since 1.0
 */
@property (nonatomic,copy) NSString *apiUrl;

/**
 *  @author thou, 16-06-24 09:06:27
 *
 *  @brief 存放url请求方式，默认为get。其他方式请求建议在api初始化的时候配置。
 *
 *  @since 1.0
 */
@property (nonatomic) NetWorkRequestType requestType;

/**
 *  @author thou, 17-05-19 02:20:11
 *
 *  @brief 存放url响应类型方式，默认为NSDictionary。
 *
 *  @since 1.0
 */
@property (nonatomic) NetWorkResponseType responseType;

/**
 *  @author thou, 16-06-24 09:06:20
 *
 *  @brief 设置该数据是否需要被缓存，缓存后数据使用方式等信息。
 *
 *  @since 1.0.1
 */
@property (nonatomic,copy) NSString *cacheType;

/**
 *  @author thou, 16-06-24 09:06:42
 *
 *  @brief 设置接口缓存时长
 *
 *  @since 1.0
 */
@property (nonatomic) NSInteger cacheDuration;

@property (nonatomic,setter=needRefreshCache:,getter=isNeedRefreshCache) BOOL refreshCache;

/**
 *  @author thou, 16-06-24 10:06:24
 *
 *  @brief 接口version，默认version在YWApi中统一设置。
 *
 *  @since 1.0
 */
@property (nonatomic,copy) NSString *version;

+ (NSArray *)allNetworkCacheType;

+ (TheNetworkAPI *)networkAPI:(NSString *)apiUrl;
- (instancetype)initWithApiName:(NSString *)apiUrl;

@end
