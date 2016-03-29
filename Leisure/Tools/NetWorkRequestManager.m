//
//  NetWorkRequestManager.m
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "NetWorkRequestManager.h"

@implementation NetWorkRequestManager

- (NSData *)parDicToData:(NSDictionary *)parDic
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSString *key in parDic) {
        NSString *keyValue = [NSString stringWithFormat:@"%@=%@", key, parDic[key]];
        [arr addObject:keyValue];
    }
    NSString *dataString = [arr componentsJoinedByString:@"&"];
    return [dataString dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)requestWithType:(RequestType)type urlString:(NSString *)urlString parDic:(NSDictionary *)parDic requestFinish:(RequestFinish)requestFinish requestError:(RequestError)requestError
{
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    if (type == GET) {
        request.HTTPMethod = @"GET";
    } else {
        request.HTTPMethod = @"POST";
        if (parDic.count > 0) {
            request.HTTPBody = [self parDicToData:parDic];
        }
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            requestFinish(data);
        } else {
            requestError(error);
        }
    }];
    [task resume];
}

+ (void)requestWithType:(RequestType)type urlString:(NSString *)urlString parDic:(NSDictionary *)parDic requestFinish:(RequestFinish)requestFinish requestError:(RequestError)requestError
{
    NetWorkRequestManager *manager = [[NetWorkRequestManager alloc] init];
    [manager requestWithType:type urlString:urlString parDic:parDic requestFinish:requestFinish requestError:requestError];
}

@end
