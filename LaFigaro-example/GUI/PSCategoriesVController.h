//
//  PSArticlesVController.h
//  LaFigaro-example
//
//  Created by Sergei Merenkov  on 5/28/14.
//  Copyright (c) 2014 PlaySoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSCategoriesVController : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, assign) NSInteger currentCattegory;
@property (nonatomic, assign) NSInteger maxCattegory;

@end
