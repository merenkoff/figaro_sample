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
        sharedInstance = [PSArticlesTransmitter clientWithBaseURL:[NSURL URLWithString:@"http://figaro.service.yagasp.com/article/header/"]];
    });
    return sharedInstance;
}

- (void)downloadArticles:(NSString *)category complete:(void(^)(NSString*, NSArray*))complete
{
    [self cancelAllHTTPOperationsWithMethod:@"GET" path:category];
    [self getPath:category
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
              //complete(arrayData);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"ERROR %@", [error description]);
              complete(@"",@[]);
          }];
}

@end
