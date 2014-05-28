//
//  BBUsersManager.m
//  baseexample
//
//  Created by Sergei Merenkov  on 4/3/14.
//  Copyright (c) 2014 Swivl. All rights reserved.
//

#import "PSArticle.h"

@implementation PSArticle

+ (instancetype)articleWithDictionary:(NSDictionary *)userDictionary {
    return [[self alloc] initWithDictionary:userDictionary];
}

- (instancetype)initWithDictionary:(NSDictionary*)userDictionary {
	if ((self = [super init])) {
        [self setValuesForKeysWithDictionary:userDictionary];
        
        _ID = userDictionary[@"id"];
        _date = [NSDate dateWithTimeIntervalSince1970:[userDictionary[@"date"] integerValue]];
    }
	return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    NSLog(@"Article received an undefined key during init: %@", key);
}

- (NSURL *)imageURL
{
    return [NSURL URLWithString:[self getImageLinkWidth:174 height:114]];
}


- (NSString *)imageLink
{
    return [self getImageLinkWidth:174 height:114];
}

- (NSString *)detailImageLink
{
    return [self getImageLinkWidth:805 height:453];
}
- (NSString *)getImageLinkWidth:(NSInteger)width height:(NSInteger)height
{
    if (self.thumb[@"link"] && ![self.thumb[@"link"] isEqualToString:@""]) {
        return [NSString stringWithFormat:self.thumb[@"link"], width, height];
    }
    
    return nil;  
}

-(NSString *)getContent
{
    return [NSString stringWithFormat:@"<html><body>%@</body></html>", _content];
}

@end
