//
//  TheBasicRequestHandle.m
//  TheNetwork
//
//  Created by TheMe on 2019/1/16.
//  Copyright © 2019 sdqvsqiu@gmail.com. All rights reserved.
//

#import "TheBasicRequestHandle.h"
#import "NSString+TheNetwork.h"

extern NSInteger const kRequestInterval;
extern NSString *const BeanTypeUnpackJsonData;

@implementation TheBasicRequestHandle

- (void)sendRequest:(TheNetworkRequest *)request url:(NSString *)url parameters:(id)parameters progress:(ResponseProgress)progress success:(ResponseSuccess)success failure:(ResponseError)failure
{
    NetWorkRequestType requestType = request.bean.beanApi.requestType;
//    NetWorkResponseType responseType = request.bean.beanApi.responseType;
    if (requestType == NetWorkRequestTypeGet) {
        [self getWithURL:url Params:parameters success:success failure:failure];
    }else if (requestType == NetWorkRequestTypePost){
        [self postWithURL:url Params:parameters success:success failure:failure];
    }else if (requestType == NetWorkRequestTypeUpload){
        [self uploadWithURL:url Params:parameters success:success failure:failure];
    }
}

- (void)getWithURL:(NSString *)urlString Params:(NSDictionary *)parameters success:(ResponseSuccess)success failure:(ResponseError)failure
{
    NSString *pathStr = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:pathStr]];
    request.timeoutInterval = kRequestInterval;
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                !success?:success(responseObject);
            } else {
                !failure?:failure(error);
            }
        });
    }];
    [task resume];
}

- (void)postWithURL:(NSString *)urlString Params:(NSDictionary *)parameters success:(ResponseSuccess)success failure:(ResponseError)failure
{
    NSData *bodyData = nil;
    NSError *error = nil;
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        id unpackJsonData = parameters[BeanTypeUnpackJsonData];    // RESTful风格。body传递纯字符串或数组，如："http://war3.ml" 或 ["12","34","56"]
        if ([unpackJsonData isKindOfClass:[NSArray class]]) {
            bodyData = [NSJSONSerialization dataWithJSONObject:unpackJsonData options:NSJSONWritingPrettyPrinted error:&error];
        }else if ([unpackJsonData isKindOfClass:[NSString class]]){
            bodyData = [unpackJsonData dataUsingEncoding:NSUTF8StringEncoding];
        }
    }else if ([parameters isKindOfClass:[NSDictionary class]]){
        bodyData = (NSData *)parameters;
    }else{
        error = [NSError errorWithDomain:urlString code:400 userInfo:@{NSLocalizedFailureReasonErrorKey:@"Post请求body为空"}];
    }
    if (error) {
        return !failure?:failure(error);
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];

    [request setHTTPBody:bodyData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%@", @((unsigned long)bodyData.length)] forHTTPHeaderField:@"Content-Length"];
    request.timeoutInterval = kRequestInterval;

    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                !success?:success(responseObject);
            } else {
                !failure?:failure(error);
            }
        });
    }];
    [task resume];
}

- (void)uploadWithURL:(NSString *)urlString Params:(NSDictionary *)parameters success:(ResponseSuccess)success failure:(ResponseError)failure
{
    NSData *data = parameters[@"uploadData"];
    NSError *error = nil;
    if (![parameters isKindOfClass:[NSData class]]) {
        data= [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
    }
    if (error) {
        return !failure?:failure(error);
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = data;
    
    [request setValue:[NSString stringWithFormat:@"%@", @(data.length)] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!connectionError) {
                NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                !success?:success(responseObject);
            } else {
                !failure?:failure(connectionError);
            }
        });
    }];
}

@end
