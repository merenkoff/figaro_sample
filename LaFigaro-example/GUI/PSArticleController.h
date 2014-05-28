//
//  PSArticleController.h
//  LaFigaro-example
//
//  Created by Sergei Merenkov  on 5/28/14.
//  Copyright (c) 2014 PlaySoft. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ImageLoader.h"
#import "PSArticle.h"

@interface PSArticleController : UIViewController <ImageLoaderProtocol, UIWebViewDelegate>

@property (nonatomic, assign) PSArticle *article;

@end
