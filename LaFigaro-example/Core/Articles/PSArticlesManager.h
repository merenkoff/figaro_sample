//
//  BBUsersManager.h
//  baseexample
//
//  Created by Sergei Merenkov  on 4/3/14.
//  Copyright (c) 2014 Swivl. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PSArticle.h"

@interface PSArticlesManager : NSObject

+(instancetype)sharedArticlesManager;

@property (nonatomic, strong) NSArray *articles;

- (void)parceArticlesToArray:(NSArray *)arrayOfArticles;

@end
