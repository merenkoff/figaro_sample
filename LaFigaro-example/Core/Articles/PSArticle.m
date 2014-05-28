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

- (instancetype)initWithDictionary:(NSDictionary*)dataDictionary {
	if ((self = [super init])) {
        [self setValuesForKeysWithDictionary:dataDictionary];
        
        _ID = dataDictionary[@"id"];
        _date = [NSDate dateWithTimeIntervalSince1970:[dataDictionary[@"date"] integerValue]];
    }
	return self;
}

- (void)addDetailFromDictionary:(NSDictionary *)dataDictionary
{
    [self setValuesForKeysWithDictionary:dataDictionary];
    _date = [NSDate dateWithTimeIntervalSince1970:[dataDictionary[@"date"] integerValue]];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    NSLog(@"Article received an undefined key during init: %@", key);
}

#pragma mark - Images
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
#pragma mark -
- (NSString *)stringDate
{
    NSString *dateString = [NSDateFormatter localizedStringFromDate:self.date
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterMediumStyle];

    return dateString;
}
-(NSString *)getContent
{
    if (self.imageLink) {
        return [NSString stringWithFormat:@"<html><body><h2>%@</h2><h5>%@, %@</h5><img src=\"%@\"  height=\"182\" width=\"280\"><b>%@</b> %@</body></html>",_title , _author, [self stringDate], [self detailImageLink], _subtitle, _content];
    }

    return [NSString stringWithFormat:@"<html><body><h2>%@</h2><h5>%@, %@</h5><b>%@</b> %@</body></html>", _title, _author, [self stringDate], _subtitle, _content];
}

@end
