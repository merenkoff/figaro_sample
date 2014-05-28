//
//  ArticleItemCell.h
//  LaFigaro-example
//
//  Created by Sergei Merenkov  on 5/28/14.
//  Copyright (c) 2014 PlaySoft. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface ArticleItemCell : UITableViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *imageLink;
@property (nonatomic, weak) UIImage *image;

@end
