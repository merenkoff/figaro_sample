//
//  BBUsersManager.m
//  baseexample
//
//  Created by Sergei Merenkov  on 4/3/14.
//  Copyright (c) 2014 Swivl. All rights reserved.
//

#import "PSArticlesTransmitter.h"

@implementation PSArticlesTransmitter

+ (instancetype)sharedArticlesTransmitter
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [PSArticlesTransmitter clientWithBaseURL:[NSURL URLWithString:@"http://figaro.service.yagasp.com/article/"]];
    });
    return sharedInstance;
}

- (void)downloadArticles:(NSString *)category complete:(void(^)(NSString*, NSArray*))complete
{
    [self cancelAllHTTPOperationsWithMethod:@"GET" path:[NSString stringWithFormat:@"header/%@",category]];
    [self getPath:[NSString stringWithFormat:@"header/%@",category]
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, NSData *responseObject) {
              NSArray *arrayData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
              //NSLog(@"ARRAY of Articles:\n%@", arrayData);
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
          success:^(AFHTTPRequestOperation *operation, NSData *responseObject) {
              NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
              complete(dictData);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"ERROR %@", [error description]);
              complete(nil);
          }];


}

@end
