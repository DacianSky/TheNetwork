//
//  TheResponseBaseBean.m
//  TheNetwork
//
//  Created by TheMe on 6/20/16.
//  Copyright © 2016 sdqvsqiu@gmail.com. All rights reserved.
//

#import "TheResponseBaseBean.h"

NSString *const kThouResponseBeanBody = @"Body";
NSString *const kThouResponseBeanMsg = @"Msg";
NSString *const kThouResponseBeanResultCode = @"ResultCode";
NSString *const kThouResponseBeanSucceed = @"Succeed";

@implementation TheResponseBaseBean

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kThouResponseBeanBody] isKindOfClass:[NSNull class]]){
		self.body = [dictionary[kThouResponseBeanBody] copy];
	}

	if(![dictionary[kThouResponseBeanMsg] isKindOfClass:[NSNull class]]){
		self.msg = dictionary[kThouResponseBeanMsg];
	}	
	if(![dictionary[kThouResponseBeanResultCode] isKindOfClass:[NSNull class]]){
        id result = dictionary[kThouResponseBeanResultCode];
        if ([result isKindOfClass:[NSNumber class]]) {
            self.resultCode = [result integerValue];
        }else{
            self.resultCode = [self convertResultCode:result];
        }
	}	
	if(![dictionary[kThouResponseBeanSucceed] isKindOfClass:[NSNull class]]){
		self.succeed = [dictionary[kThouResponseBeanSucceed] boolValue];
	}

	return self;
}

- (ResultCode)convertResultCode:(id)result
{
    if([@"Succeed" isEqualToString:result]){
        return ResultCodeSucceed;
    }else if([@"UndefinedError" isEqualToString:result]){
        return ResultCodeUndefinedError;
    }else if([@"ParamsError" isEqualToString:result]){
        return ResultCodeParamsError;
    }else if([@"FreqOutOfLimit" isEqualToString:result]){
        return ResultCodeFreqOutOfLimit;
    }else if([@"Unauthorized" isEqualToString:result]){
        return ResultCodeUnauthorized;
    }else if([@"ExternalServiceUnavailable" isEqualToString:result]){
        return ResultCodeExternalServiceUnavailable;
    }else{
        return ResultCodeServerUndefined;
    }
}

- (NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.body != nil){
		dictionary[kThouResponseBeanBody] = [self.body copy];
	}
	if(self.msg != nil){
		dictionary[kThouResponseBeanMsg] = self.msg;
	}
    dictionary[kThouResponseBeanResultCode] = @(self.resultCode);
	dictionary[kThouResponseBeanSucceed] = @(self.succeed);
	return dictionary;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	if(self.body != nil){
		[aCoder encodeObject:self.body forKey:kThouResponseBeanBody];
	}
	if(self.msg != nil){
		[aCoder encodeObject:self.msg forKey:kThouResponseBeanMsg];
	}
    [aCoder encodeObject:@(self.resultCode) forKey:kThouResponseBeanResultCode];
	[aCoder encodeObject:@(self.succeed) forKey:kThouResponseBeanSucceed];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.body = [aDecoder decodeObjectForKey:kThouResponseBeanBody];
	self.msg = [aDecoder decodeObjectForKey:kThouResponseBeanMsg];
	self.resultCode = [[aDecoder decodeObjectForKey:kThouResponseBeanResultCode] integerValue];
	self.succeed = [[aDecoder decodeObjectForKey:kThouResponseBeanSucceed] boolValue];
	return self;

}

- (instancetype)copyWithZone:(NSZone *)zone
{
	TheResponseBaseBean *copy = [TheResponseBaseBean new];

	copy.body = [self.body copyWithZone:zone];
	copy.msg = [self.msg copyWithZone:zone];
	copy.resultCode = self.resultCode;
	copy.succeed = self.succeed;

	return copy;
}

@end
