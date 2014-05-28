//
//  BBUsersManager.m
//  baseexample
//
//  Created by Sergei Merenkov  on 4/3/14.
//  Copyright (c) 2014 Swivl. All rights reserved.
//

#import "PSArticlesTransmitter.h"
#import "AFNetworking.h"

#define kAPIBaseURL @"http://figaro.service.yagasp.com/article/"

@implementation PSArticlesTransmitter

+ (instancetype)sharedArticlesTransmitter
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:kAPIBaseURL]];
    });
    return sharedInstance;
}

- (id)initWithBaseURL:(NSURL *)URL
{
    self = [super initWithBaseURL:URL];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    return self;
}

#pragma mark - Articles
- (void)downloadArticles:(NSString *)category complete:(void(^)(NSString*, NSArray*))complete
{
    [self cancelAllHTTPOperationsWithMethod:@"GET" path:[NSString stringWithFormat:@"header/%@",category]];
    [self getPath:[NSString stringWithFormat:@"header/%@",category]
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, NSArray *arrayData) {

              if ([arrayData count] == 2) {
                  NSArray *timeStampArray = [arrayData firstObject];
                  NSDictionary *timeStampDict = [timeStampArray firstObject];
                  if (timeStampDict) {
                        complete([timeStampDict objectForKey:@"timestamp"], arrayData[1]);
                  }
                  
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"ERROR %@", [error description]);
              complete(@"",@[]);
          }];
}

- (void)downloadArticle:(NSString *)articleID complete:(void (^)(NSDictionary *))complete
{
    [self cancelAllHTTPOperationsWithMethod:@"GET" path:[NSString stringWithFormat:@"%@", articleID]];
    [self getPath:[NSString stringWithFormat:@"%@", articleID]
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, NSDictionary *dictData) {
              complete(dictData);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"ERROR %@", [error description]);
              complete(nil);
          }];
}

@end
