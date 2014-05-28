//
//  ArticleItemCell.m
//  LaFigaro-example
//
//  Created by Sergei Merenkov  on 5/28/14.
//  Copyright (c) 2014 PlaySoft. All rights reserved.

#import "ArticleItemCell.h"

@interface ArticleItemCell ()
{
    IBOutlet __weak UIImageView *_pictureView;
    IBOutlet __weak UITextView *_titleLabel;
    IBOutlet __weak UILabel *_subtitleLabel;
}

@end

@implementation ArticleItemCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
    // Do not change text color when highlighted
    _subtitleLabel.highlightedTextColor = _subtitleLabel.textColor;

}

- (void)setTitle:(NSString *)titleText
{
    _title = [titleText copy];
    _titleLabel.text = _title;
}

- (void)setDescription:(NSString *)description
{
    _description = [description copy];
    _subtitleLabel.text = _description;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    _pictureView.image = _image;
}

- (void)setImageLink:(NSString *)imageLink
{
    _imageLink = [imageLink copy];
    if (_imageLink) {
        [[ImageLoader sharedLoader] downloadImage:_imageLink to:self];
    } else {
        [self didLoadImage:nil fromUrlString:_imageLink];
    }
    
}

- (void)didLoadImage:(UIImage *)image fromUrlString:(NSString *)urlString
{
    if (image && [urlString isEqualToString:self.imageLink])
    {
        _pictureView.image = image;
        _pictureView.hidden = NO;
    } else {
        _pictureView.hidden = YES;
    }
}

@end
