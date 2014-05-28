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

    [self setCurrentIndex:0];
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
        
        [self setCurrentIndex:0 animated:YES];
        [self performSelector:@selector(initPages) withObject:nil];
    }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configPages];
    [self configDataAndFiles];
}


#pragma mark - UIPageView Data source & Delegate
- (NSUInteger)pageCount
{
    return [_categories count];
}

- (UIViewController *)viewControllerForIndex:(NSUInteger)index
{
    PSArticlesVController *articlesVController = [[PSArticlesVController alloc] initWithNibName:@"PSArticlesVController" bundle:nil];
    [articlesVController reloadDataForCategory:_categories[index] withName:_categoryNames[index]];
    return articlesVController;
}

@end
