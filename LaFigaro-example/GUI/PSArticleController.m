//
//  PSArticleController.m
//  LaFigaro-example
//
//  Created by Sergei Merenkov  on 5/28/14.
//  Copyright (c) 2014 PlaySoft. All rights reserved.

#import "PSArticleController.h"

@interface PSArticleController ()
{
    IBOutlet __weak UIImageView *_pictureView;
    IBOutlet __weak UITextView *_titleLabel;
    IBOutlet __weak UIWebView *_contentWeb;
}

@end

@implementation PSArticleController

- (void)setArticle:(PSArticle *)article
{
    _article = article;
    _titleLabel.text = article.title;
   [_contentWeb loadHTMLString:article.content baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    
    if (_article.detailImageLink) {
        [[ImageLoader sharedLoader] downloadImage:_article.detailImageLink to:self];
    } else {
        [self didLoadImage:nil fromUrlString:nil];
    }
    
}

- (void)didLoadImage:(UIImage *)image fromUrlString:(NSString *)urlString
{
    if (image && [urlString isEqualToString:_article.detailImageLink])
    {
        _pictureView.image = image;
        _pictureView.hidden = NO;
    } else {
        _pictureView.hidden = YES;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return NO;
}

@end
