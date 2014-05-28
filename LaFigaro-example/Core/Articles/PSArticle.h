//
//  BBUsersManager.h
//  baseexample
//
//  Created by Sergei Merenkov  on 4/3/14.
//  Copyright (c) 2014 Swivl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSArticle : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, assign) NSInteger ranking;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, retain) NSDictionary *thumb;
@property (nonatomic, readonly) NSURL *imageURL;
@property (nonatomic, readonly) NSString *imageLink;
@property (nonatomic, readonly) NSString *detailImageLink;

@property (nonatomic, copy, getter = getContent) NSString *content; //html content

+ (instancetype)articleWithDictionary:(NSDictionary *)userDictionary;

@end
