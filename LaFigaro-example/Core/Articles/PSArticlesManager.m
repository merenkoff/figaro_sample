//
//  BBUsersManager.m
//  baseexample
//
//  Created by Sergei Merenkov  on 4/3/14.
//  Copyright (c) 2014 Swivl. All rights reserved.
//

#import "PSArticlesManager.h"
#import "PSArticle.h"

@implementation PSArticlesManager

+(instancetype)sharedArticlesManager
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)parceArticlesToArray:(NSArray *)arrayOfArticles
{
    NSMutableArray *_parsedArticles = [NSMutableArray new];
    
    for (NSDictionary *_article  in arrayOfArticles) {
        PSArticle *_articleParsed = [PSArticle articleWithDictionary:_article];
        [_parsedArticles addObject:_articleParsed];
    }
    self.articles = [[NSArray alloc] initWithArray:_parsedArticles];
}
@end
