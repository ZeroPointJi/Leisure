//
//  NetWorkRequestManager.h
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RequestType) {
    GET,
    POST
};

typedef void (^RequestFinish) (NSData *data);
typedef void (^RequestError) (NSError *error);

@interface NetWorkRequestManager : NSObject

+ (void)requestWithType:(RequestType)type urlString:(NSString *)urlString parDic:(NSDictionary *)parDic requestFinish:(RequestFinish)requestFinish requestError:(RequestError)requestError;

@end
