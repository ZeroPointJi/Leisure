//
//  RadioPlayInfoModel.h
//  Leisure
//
//  Created by zero on 16/4/6.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "BaseModel.h"
#import "RadioUserInfoModel.h"

@interface RadioPlayInfoModel : BaseModel

@property (nonatomic, strong) NSDictionary *authorinfo;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *musicUrl;
@property (nonatomic, strong) NSDictionary *shareinfo;
@property (nonatomic, copy) NSString *sharepic;
@property (nonatomic, copy) NSString *sharetext;
@property (nonatomic, copy) NSString *shareurl;
@property (nonatomic, copy) NSString *ting_contentid;
@property (nonatomic, copy) NSString *tingid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) RadioUserInfoModel *userinfoModel;
@property (nonatomic, copy) NSString *webview_url;

@end
