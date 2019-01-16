//
//  TheNetworkRequest.m
//  TheNetwork
//
//  Created by DacianSky on 6/20/16.
//  Copyright © 2016 sdqvsqiu@gmail.com. All rights reserved.
//

#import "TheNetworkRequest.h"
#import "TheResponseBaseBean.h"

@interface TheNetworkRequest()

@end

@implementation TheNetworkRequest

+ (instancetype)requestWithBean:(id<TheBeanInterface>)bean
{
    return [[self alloc] initWithBean:bean];
}

- (instancetype)initWithBean:(id<TheBeanInterface>)bean
{
    if(self = [self init]){
        _bean = bean;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    TheNetworkRequest *model = [[[self class] alloc] init];
    model.bean = self.bean;
    model.cancel = self.cancel;
    model.start = self.start;
    model.forceUseLocalData = self.forceUseLocalData;
    model.localData = self.localData;
    model.processing = self.processing;
    model.success = self.success;
    model.exception = self.exception;
    model.failure = self.failure;
    model.finally = self.finally;
    model.unauthorized = self.unauthorized;
    model.willLogin = self.willLogin;
    model.onLogin = self.onLogin;
    
    return model;
}

- (RequestCancel)cancel
{
    if (!_cancel) {
        return ^BOOL (){
            return NO;
        };
    }
    return _cancel;
}

- (Class<TheResponseBeanProtocol>)responseBeanType
{
    if (!_responseBeanType) {
        _responseBeanType = [TheResponseBaseBean class];
    }
    return _responseBeanType;
}

@end
