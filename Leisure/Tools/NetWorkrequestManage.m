//
//  NetWorkrequestManage.m
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "NetWorkrequestManage.h"

@implementation NetWorkrequestManage

+(void)requestWithType:(requestType)type url:(NSString *)urlString parameters:(NSDictionary *)parDic finish:(RequestFinish)requestFinish error:(RequestError)requestError {
    NetWorkrequestManage *manage = [[NetWorkrequestManage alloc] init];
    [manage requestWithType:type url:urlString parameters:parDic finish:requestFinish error:requestError];
}

-(void)requestWithType:(requestType)type url:(NSString *)urlString parameters:(NSDictionary *)parDic finish:(RequestFinish)requestFinish error:(RequestError)requestError {
    // 拿到参数之后进行请求
    NSURL *url = [NSURL URLWithString:urlString];
    // 创建可变的URLRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //如果请求方式是POST需要设置参数和请求方式
    if (type == POST) {
        // 设置请求方式
        [request setHTTPMethod:@"POST"];
        if (parDic.count > 0) {
            NSData *data = [self parDicToDataWithDic:parDic];
            [request setHTTPBody:data];
        }
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            requestFinish(data);
        } else {
            requestError(error);
        }
    }];
    [task resume];
}

//把参数字典转为POST请求所需要的参数体
- (NSData *)parDicToDataWithDic:(NSDictionary *)dic {
    NSMutableArray *array = [NSMutableArray array];
    //遍历字典得到每一个键，得到所有的 Key＝Value类型的字符串
    for (NSString *key in dic) {
        NSString *str = [NSString stringWithFormat:@"%@=%@", key, dic[key]];
        [array addObject:str];
    }
    //数组里所有Key＝Value的字符串通过&符号连接
    NSString *parString = [array componentsJoinedByString:@"&"];
    return [parString dataUsingEncoding:NSUTF8StringEncoding];
}

@end
