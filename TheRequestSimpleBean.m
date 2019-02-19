//
//  TheRequestSimpleBean.m
//  TheNetwork
//
//  Created by TheMe on 2/13/19.
//  Copyright © 2016 sdqvsqiu@gmail.com. All rights reserved.
//

#import "TheRequestSimpleBean.h"
#import "TheApi.h"

@interface TheRequestSimpleBean()

@property (nonatomic, strong, readwrite) NSMutableDictionary *simpleParams;

@end

@implementation TheRequestSimpleBean
@synthesize beanApi = _beanApi;

- (TheNetworkAPI *)beanApi
{
    if (!_beanApi) {
        _beanApi = [[TheApi sharedApi].HTTP_THE_BASE copy];
    }
    return _beanApi;
}

- (void)setSimpleUrl:(NSString *)simpleUrl
{
    _simpleUrl = simpleUrl;
    self.beanApi.apiUrl = [self.beanApi.apiUrl stringByAppendingString:simpleUrl];
}

- (void)setFullUrl:(NSString *)fullUrl
{
    _fullUrl = fullUrl;
    self.beanApi.apiUrl = fullUrl;
}

- (NSMutableDictionary *)simpleParams
{
    if (!_simpleParams) {
        _simpleParams = [[NSMutableDictionary alloc] init];
    }
    return _simpleParams;
}

- (NSDictionary *)parameterDict
{
    return [self.simpleParams mutableCopy];
}

@end
