//
//  BBUsersManager.h
//  baseexample
//
//  Created by Sergei Merenkov  on 4/3/14.
//  Copyright (c) 2014 Swivl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface PSArticlesTransmitter : AFHTTPClient

+ (instancetype)sharedArticlesTransmitter;

//Category
- (void)downloadCategoriesWithComplete:(void(^)(NSArray*))complete;

//Articles
- (void)downloadArticles:(NSString *)category complete:(void(^)(NSString*, NSArray*))complete;
- (void)downloadArticle:(NSString *)articleID complete:(void (^)(NSDictionary *))complete;
@end
