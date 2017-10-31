//
//  HomeslideListingModel.h
//  NeedIt
//
//  Created by 湘汇天承 on 16/4/28.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeslideListingModel : NSObject

@property (nonatomic, copy) NSString *Itemid;
@property (nonatomic, copy) NSString *Itemimg;
@property (nonatomic, copy) NSString *Itemaccount;
@property (nonatomic, copy) NSString *Itemname;
@property (nonatomic, copy) NSString *Itemprice;

#pragma mark - 方法
#pragma mark 根据字典初始化商品对象
- (HomeslideListingModel * )initWithDict:(NSDictionary *)dic;

#pragma mark 初始化商品对象（静态方法）
+ (HomeslideListingModel *)statusWithDictionary:(NSDictionary *)dic;


@end
