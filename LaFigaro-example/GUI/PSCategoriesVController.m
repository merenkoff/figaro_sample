//
//  PSArticlesVController.m
//  LaFigaro-example
//
//  Created by Sergei Merenkov  on 5/28/14.
//  Copyright (c) 2014 PlaySoft. All rights reserved.
//

#import "PSCategoriesVController.h"
#import "PSArticlesVController.h"

#import "PSArticlesManager.h"
#import "PSArticlesTransmitter.h"

@interface PSCategoriesVController ()
{
    NSArray *_categories;
    NSArray *_categoryNames;
    PSArticlesVController *_articlesController;
    PSArticlesVController *_articlesControllerNext;
}

@end

@implementation PSCategoriesVController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)configPages
{
    self.delegate = self;
    self.dataSource = self;
    _articlesController = [[PSArticlesVController alloc] initWithNibName:@"PSArticlesVController" bundle:nil];
    _articlesControllerNext = [[PSArticlesVController alloc] initWithNibName:@"PSArticlesVController" bundle:nil];
    
    [self setViewControllers:@[_articlesController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void)configDataAndFiles
{
    NSMutableArray *m_categories = [NSMutableArray new];
    NSMutableArray *m_categoriesNames = [NSMutableArray new];
    
    [[PSArticlesTransmitter sharedArticlesTransmitter] downloadCategoriesWithComplete:^(NSArray *categoies) {
        for (NSDictionary *category in categoies) {
            NSArray *_subCategories = category[@"subcategories"];
            if (_subCategories && _subCategories != [NSNull null]) {
                for (NSDictionary *object in _subCategories) {
                    if ([object[@"isVisible"] boolValue]) {
                        [m_categories addObject:object[@"id"]];
                        [m_categoriesNames addObject:object[@"name"]];
                    }
                    
                }

            }
        }
        _categories = [NSArray arrayWithArray:m_categories];
        _categoryNames = [NSArray arrayWithArray:m_categoriesNames];
        
        _currentCattegory = 0;
        _maxCattegory = [_categories count] - 1;
        
        [_articlesController reloadDataForCategory:_categories[_currentCattegory] withName:_categoryNames[_currentCattegory]];
        [_articlesControllerNext reloadDataForCategory:_categories[_maxCattegory] withName:_categoryNames[_maxCattegory]];
    }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configPages];
    [self configDataAndFiles];
}


#pragma mark - UIPageView Data source & Delegate

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSLog(@"Current category: %d", self.currentCattegory);
    if (_currentCattegory > 0) {
        
        _articlesControllerNext.currentCattegory = _currentCattegory - 1;
        [_articlesControllerNext reloadDataForCategory:_categories[_articlesControllerNext.currentCattegory] withName:_categoryNames[_articlesControllerNext.currentCattegory]];
        return _articlesControllerNext;
    }

    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSLog(@"Current category: %d", self.currentCattegory);
    if (_currentCattegory < _maxCattegory) {
        _articlesControllerNext.currentCattegory = _currentCattegory + 1;
        [_articlesControllerNext reloadDataForCategory:_categories[_articlesControllerNext.currentCattegory] withName:_categoryNames[_articlesControllerNext.currentCattegory]];
        return _articlesControllerNext;
    }
    
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    _currentCattegory = _articlesControllerNext.currentCattegory;
    [_articlesControllerNext reloadDataForCategory:_categories[_currentCattegory] withName:_categoryNames[_currentCattegory]];
    
    id changeController = _articlesController;
    _articlesController = _articlesControllerNext;
    _articlesControllerNext = changeController;
}

@end
