//
//  TheNetwork.m
//  Pods-TheNetwork_Tests
//
//  Created by DacianSky on 2019/1/16.
//

#import <Foundation/Foundation.h>

//! Project version number for ThouRoute.
FOUNDATION_EXPORT double ThouRouteVersionNumber;

//! Project version string for ThouRoute.
FOUNDATION_EXPORT const unsigned char ThouRouteVersionString[];

#ifndef PureStandard_ThouRoute

#define PureStandard_ThouRoute

#if __has_include(<TheNetwork/TheNetworkCenter.h>)
// In this header, you should import all the public headers of your framework using statements like #import <ThouRoute/PublicHeader.h>

    #import <TheNetwork/TheNetworkCenter.h>
    #import <TheNetwork/TheApi.h>
    #import <TheNetwork/TheBasicRequestHandle.h>
    #import <TheNetwork/TheBeanInterface.h>
    #import <TheNetwork/TheCacheData.h>

    #import <TheNetwork/TheNetworkAPI.h>
    #import <TheNetwork/TheNetworkCache.h>
    #import <TheNetwork/TheNetworkCacheProtocol.h>
    #import <TheNetwork/TheNetworkCenter.h>
    #import <TheNetwork/TheNetworkRequest.h>

    #import <TheNetwork/TheRequestBaseBean.h>
    #import <TheNetwork/TheRequestHandleProtocol.h>
    #import <TheNetwork/TheResponseBaseBean.h>
    #import <TheNetwork/TheResponseBeanProtocol.h>

#else

    #import "NSString+TheNetwork.h"
    #import "TheApi.h"
    #import "TheBasicRequestHandle.h"
    #import "TheBeanInterface.h"
    #import "TheCacheData.h"

    #import "TheNetworkAPI.h"
    #import "TheNetworkCache.h"
    #import "TheNetworkCacheProtocol.h"
    #import "TheNetworkCenter.h"
    #import "TheNetworkRequest.h"

    #import "TheRequestBaseBean.h"
    #import "TheRequestHandleProtocol.h"
    #import "TheResponseBaseBean.h"
    #import "TheResponseBeanProtocol.h"

#endif

#endif
