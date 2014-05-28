//
//  BBUsersManager.h
//  baseexample
//
//  Created by Sergei Merenkov  on 4/3/14.
//  Copyright (c) 2014 Swivl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSArticle : NSObject

@property (nonatomic, retain) NSString *ID;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, assign) NSInteger ranking;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) NSDictionary *thumb;
@property (nonatomic, readonly) NSURL *imageURL;

+ (instancetype)articleWithDictionary:(NSDictionary *)userDictionary;

@end
