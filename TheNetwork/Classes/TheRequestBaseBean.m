//
//  TheRequestBaseBean.m
//  TheNetwork
//
//  Created by TheMe on 6/23/16.
//  Copyright © 2016 sdqvsqiu@gmail.com. All rights reserved.
//

#import "TheRequestBaseBean.h"

NSString *const BeanParameterTrue = @"true";
NSString *const BeanParameterFalse = @"false";

NSString *const BeanTypeUnpackJsonData = @"unpackJsonData";

@implementation TheRequestBaseBean
@synthesize beanApi = _beanApi;
@synthesize actualParams = _actualParams;

- (NSDictionary *)parameterDict
{
    NSMutableDictionary *dict = [@{} mutableCopy];
    if (self.unpackJsonData) {
        dict[@"unpackJsonData"] = self.unpackJsonData;
    }
    if (self.uploadData) {
        dict[@"uploadData"] = self.uploadData;
    }
    return dict;
}

@end
