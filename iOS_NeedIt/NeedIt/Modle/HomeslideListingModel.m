//
//  HomeslideListingModel.m
//  NeedIt
//
//  Created by 湘汇天承 on 16/4/28.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

#import "HomeslideListingModel.h"

@implementation HomeslideListingModel


- (HomeslideListingModel *)initWithDict:(NSDictionary *)dic{
    
    if (self  = [super init]) {
        
        self.Itemid = [dic objectForKey:@"id"];
        self.Itemimg = [dic objectForKey:@"img"];
        self.Itemaccount = [dic objectForKey:@"to_account"];
        self.Itemname = [dic objectForKey:@"name"];
        self.Itemprice = [dic objectForKey:@"price"];
    }
    return self;
}


+ (HomeslideListingModel *)statusWithDictionary:(NSDictionary *)dic{
    HomeslideListingModel * status = [[HomeslideListingModel alloc] initWithDict:dic];
    return status;
}




@end
