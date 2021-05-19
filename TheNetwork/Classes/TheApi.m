//
//  TheApi.m
//  TheNetwork
//
//  Created by TheMe on 6/22/16.
//  Copyright © 2016 sdqvsqiu@gmail.com. All rights reserved.
//

#import "TheApi.h"
#import <objc/runtime.h>

@interface TheApi()

@end

@implementation TheApi

+ (instancetype)sharedApi
{
    static TheApi *api;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [[self alloc] init];
    });
    return api;
}

- (instancetype)init
{
    if ([super init]) {
        self.apiVersion = kDefault_Current_API_Version;
        self.apiContext = TheApiContextProduction;
    }
    return self;
}

- (void)setApiContext:(ThouApiContext)apiContext
{
    _apiContext = apiContext;
    switch (_apiContext) {
        case TheApiContextDevelopment:
            self.baseApi = @""; // self.baseApi = @"https://dev.openapi.war3.ml";
            break;
        case TheApiContextTest:
            self.baseApi = @""; //self.baseApi = @"https://test.openapi.war3.ml";
            break;
        default:
            self.baseApi = @"";  // self.baseApi = @"https://openapi.war3.ml";
            break;
    }
    [self configAllHttpApi];
}

#pragma mark - 配置网络接口
- (void)configAllHttpApi
{
    [self configLocalApi];
    [self configNetworkApi];
}

- (void)configNetworkApi{}

- (void)configLocalApi
{
    self.HTTP_THE_BASE = [self configHttpURL:@{@"apiUrl":@""}];
    
    NSDictionary *apis = [self.apiMap valueForKey:@"api"];
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (NSString *apiName in apis.allKeys) {
        for(int i = 0; i < count; i++)
        {
            objc_property_t property = *(properties+i);
            const char *name = property_getName(property);
            NSString *propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            if ([apiName isEqualToString:propertyName]) {
                TheNetworkAPI *api = [self configHttpURL:apis[apiName]];
                [self setValue:api forKey:apiName];
            }
        }
    }
    free(properties);
}

#pragma mark - 配置绝对url
- (TheNetworkAPI *)configHttpURL:(NSDictionary *)apiDict
{
    NSString *version = apiDict[@"version"];
    if (!version || [version isEqualToString:@""]) {
        version = self.apiVersion;
    }
    
    NSString *url = [self configHttpURL:self.baseApi version:version relativeURL:apiDict[@"apiUrl"]];
    
    NSMutableDictionary *modelDict = [apiDict mutableCopy];
    modelDict[@"version"] = version;
    modelDict[@"apiUrl"] = url;
    
    return [[TheNetworkAPI alloc] initWithDictionary:modelDict];
}

- (NSString *)configHttpURL:(NSString *)baseURL version:(NSString *)version relativeURL:(NSString *)relativeURL
{
    return [NSString stringWithFormat:@"%@/%@/api/%@",baseURL,version,relativeURL];
}

@end
