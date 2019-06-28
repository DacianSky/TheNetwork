//
//  NSString+TheNetworkt.m
//  TheNetwork
//
//  Created by TheMe on 2019/1/15.
//  Copyright © 2019 sdqvsqiu@gmail.com. All rights reserved.
//

#import "NSString+TheNetwork.h"

id themeNetworkJson(NSString *fileName)
{
    return [NSString jsonWithAppFileName:fileName andThemeName:@"theme"];
}

@implementation NSString (TheNetworkt)

+ (BOOL)isEmptyOrNull: (NSString *)string
{
    if ([string isKindOfClass:[NSNull class]] || string == nil || [string isEqualToString:@""] || [string isEqualToString:@"undefined"] || [string isEqualToString:@"null"])
        return true;
    return false;
}

- (NSString *)stringByDecodingURLFormat
{
    NSString *result = [(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

- (NSString *)URLEncodedString
{
    NSString *unencodedString = self;
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)unencodedString,(CFStringRef)@"!*'();:@&=+$,/?%#[]",NULL,kCFStringEncodingUTF8));
    
    return encodedString;
}

+ (NSString *)urlDictToStringWithUrlStr:(NSString *)urlStr WithDict:(NSDictionary *)parameters
{
    if (!parameters.allKeys.count) {
        return urlStr;
    }
    
    NSMutableArray *parts = [NSMutableArray array];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *finalKey = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        if ([obj isKindOfClass:[NSNumber class]]) {
            obj = [NSString stringWithFormat:@"%g",[obj floatValue]];
        }
        NSString *finalValue = [obj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *part =[NSString stringWithFormat:@"%@=%@",finalKey,finalValue];
        [parts addObject:part];
    }];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSArray *descriptors = [NSMutableArray arrayWithObject:descriptor];
    NSArray *finalParts = [parts sortedArrayUsingDescriptors:descriptors];
    
    NSString *queryString = [finalParts componentsJoinedByString:@"&"];
    queryString = queryString ? [NSString stringWithFormat:@"?%@",queryString] : @"";
    
    return [NSString stringWithFormat:@"%@%@",urlStr,queryString];
}

- (NSString *)parseURLPlacehold:(NSDictionary *)dict
{
    NSMutableString *resultUrl = [self mutableCopy];
    
    for (NSString *key in dict.allKeys) {
        NSString *value = dict[key];
        BOOL replaceResult = [self replaceEL:resultUrl key:key withValue:value];
        
        if (replaceResult && [dict isKindOfClass:[NSMutableDictionary class]]) {
            [((NSMutableDictionary *)dict) removeObjectForKey:key];
        }
    }
    
    return resultUrl;
}

/**
 *  单次替换url中占位符为实际参数
 *
 *  @param resultUrl 被替换的url地址可变字符串
 *  @param key       被替换占位名
 *  @param value     被替换占位值
 *
 *  @return          替换是否成功
 */
- (BOOL)replaceEL:(NSMutableString *)resultUrl key:(NSString *)key withValue:(id)value
{
    BOOL result = NO;
    
    NSString *searchKey = [NSString stringWithFormat:@"{%@}",key];
    
    NSRange patternRange = [resultUrl rangeOfString:searchKey];
    
    if(patternRange.location != NSNotFound && patternRange.length > 2){
        result = YES;
        if ([value isKindOfClass:[NSString class]]) {
            [resultUrl replaceCharactersInRange:patternRange withString:[value URLEncodedString]];
        }else if ([value isKindOfClass:[NSNumber class]]) {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            NSString *numberStr = [formatter stringFromNumber:value];
            [resultUrl replaceCharactersInRange:patternRange withString:numberStr];
        }else{
            result = NO;
        }
    }
    
    return result;
}

#define kThemeName @"theme.bundle"
+ (id)jsonWithAppFileName:(NSString *)filename andThemeName:(NSString *)themeName
{
    NSString *jsonstr = [self jsonStringWithFileName:filename andThemeName:themeName];
    return [self json2Object:jsonstr];
}

+ (NSString *)jsonStringWithFileName:(NSString *)filename andThemeName:(NSString *)themeName
{
    if ([NSString isEmptyOrNull:filename]) {
        return nil;
    }
    if ([NSString isEmptyOrNull:themeName]) {
        themeName = kThemeName;
    }
    NSString *directory = [NSString stringWithFormat:@"%@/json", kThemeName];
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:filename ofType:@".json" inDirectory:directory];
    NSString *jsonstr = [NSString stringWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:nil];
    
    return jsonstr;
}

+ (id)json2Object:(NSString *)jsonstr
{
    id json;
    NSData *jsonData = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
    
    if (jsonData) {
        json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    }
    
    return json;
}


@end
