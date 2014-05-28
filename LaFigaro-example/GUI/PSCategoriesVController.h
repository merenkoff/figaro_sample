//
//  PSArticlesVController.h
//  LaFigaro-example
//
//  Created by Sergei Merenkov  on 5/28/14.
//  Copyright (c) 2014 PlaySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GRKPageViewController/GRKPageViewController.h>

@interface PSCategoriesVController : GRKPageViewController <GRKPageViewControllerDataSource, GRKPageViewControllerDelegate>//<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, assign) NSInteger currentCattegory;
@property (nonatomic, assign) NSInteger maxCattegory;

@end
