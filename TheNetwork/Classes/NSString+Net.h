//
//  NSString+Net.h
//  TheNetwork
//
//  Created by DacianSky on 2019/1/15.
//  Copyright © 2019 sdqvsqiu@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define ThemeAppJson(filename) [NSString jsonWithAppFileName:(filename) andThemeName:@"theme"]

@interface NSString (Net)

+ (NSString *)urlDictToStringWithUrlStr:(NSString *)urlStr WithDict:(NSDictionary *)parameters;

- (NSString *)parseURLPlacehold:(NSDictionary *)dict;

+ (id)jsonWithAppFileName:(NSString *)filename andThemeName:(NSString *)themeName;

@end

NS_ASSUME_NONNULL_END
