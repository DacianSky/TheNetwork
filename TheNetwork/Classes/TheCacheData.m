//
//  TheCacheData.m
//  TheNetwork
//
//  Created by DacianSky on 7/5/16.
//  Copyright © 2016 sdqvsqiu@gmail.com. All rights reserved.
//

#import "TheCacheData.h"

#define kEncodeKeyUrl @"kEncodeKeyUrl"
#define kEncodeKeyExtraParameter @"kEncodeKeyExtraParameter"
#define kEncodeKeyCacheData @"kEncodeKeyCacheData"
#define kEncodeKeyTimestamp @"kEncodeKeyTimestamp"
#define kEncodeKeyCacheDuration @"kEncodeKeyCacheDuration"

@implementation TheCacheData

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.url forKey:kEncodeKeyUrl];
    [coder encodeObject:self.extraParameter forKey:kEncodeKeyExtraParameter];
    [coder encodeObject:self.cacheData forKey:kEncodeKeyCacheData];
    [coder encodeInteger:self.timestamp forKey:kEncodeKeyTimestamp];
    [coder encodeInteger:self.cacheDuration forKey:kEncodeKeyCacheDuration];
}

- (nullable instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        if (decoder == nil)return self;
        
        self.url = [decoder decodeObjectForKey:kEncodeKeyUrl];
        self.extraParameter = [decoder decodeObjectForKey:kEncodeKeyExtraParameter];
        self.cacheData = [decoder decodeObjectForKey:kEncodeKeyCacheData];
        self.timestamp = [decoder decodeIntegerForKey:kEncodeKeyTimestamp];
        self.cacheDuration = [decoder decodeIntegerForKey:kEncodeKeyCacheDuration];
    }
    return self;
}

@end
