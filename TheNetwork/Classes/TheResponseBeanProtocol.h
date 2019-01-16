//
//  TheResponseBeanProtocol.h
//  TheNetwork
//
//  Created by DacianSky on 2019/1/15.
//  Copyright © 2019 sdqvsqiu@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,ResultCode){
    ResultCodeSucceed = 0,
    ResultCodeUndefinedError,
    ResultCodeParamsError = 5000,
    ResultCodeFreqOutOfLimit,
    ResultCodeUnauthorized,
    ResultCodeExternalServiceUnavailable,
    ResultCodeServerUndefined,
    ResultCodeVersionDisable
};


@protocol TheResponseBeanProtocol <NSObject>

@property (nonatomic, strong) NSString * msg;
@property (nonatomic) ResultCode resultCode;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END
