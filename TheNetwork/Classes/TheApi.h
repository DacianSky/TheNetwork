//  TheApi.h
//  TheNetwork
//
//  Created by DacianSky on 6/22/16.
//  Copyright © 2016 sdqvsqiu@gmail.com. All rights reserved.
//

#import "TheNetworkAPI.h"

#define kDefault_Current_API_Version @"1.0"

typedef NS_ENUM(NSUInteger,ThouApiContext)
{
    TheApiContextProduction,
    TheApiContextDevelopment,
    TheApiContextTest
};

@interface TheApi : NSObject

#pragma mark -  action
@property (nonatomic,strong) NSString *apiMap;

/**
 *  @author thou, 16-06-24 16:06:00
 *
 *  @brief 配置服务器类型，包含生产、开发、测试等服务器
 *
 *  @since 1.0
 */
@property (nonatomic) ThouApiContext apiContext;

/**
 *  @author thou, 16-06-24 16:06:43
 *
 *  @brief 当前默认使用api版本号。
 *
 *  @since 1.0
 */
@property (nonatomic,copy) NSString *apiVersion;

#pragma mark -  overpoint
@property (nonatomic,copy) NSString *baseApi;

- (void)configAllHttpApi;
- (void)configNetworkApi;
- (void)configLocalApi;
- (NSString *)configHttpURL:(NSString *)baseURL version:(NSString *)version relativeURL:(NSString *)relativeURL;

@end
