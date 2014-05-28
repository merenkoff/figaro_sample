//
//  PSArticlesVController.m
//  LaFigaro-example
//
//  Created by Sergei Merenkov  on 5/28/14.
//  Copyright (c) 2014 PlaySoft. All rights reserved.
//

#import "PSArticlesVController.h"
#import "ArticleItemCell.h"

#import "PSArticleController.h"
#import "PSArticlesManager.h"
#import "PSArticlesTransmitter.h"

NSString *const kReuseCellID = @"kReuseArticleItemCell";

@interface PSArticlesVController ()
{
    NSArray *_articles;
    NSString *_categoryName;
    NSInteger _currentCattegory;

    __weak IBOutlet UIPageControl *_pageControl;
    __weak IBOutlet UITableView *_tableView;
    NSString *_category;
    UIRefreshControl *_refreshControl;
}

@end

@implementation PSArticlesVController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)configTable
{
    NSBundle *classBundle = [NSBundle bundleForClass:[ArticleItemCell class]];
    UINib *cellNib;
 
    cellNib = [UINib nibWithNibName:@"ArticleItemCell" bundle:classBundle];
 
    [_tableView registerNib:cellNib forCellReuseIdentifier:kReuseCellID];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refreshControl];
    
}

- (void)configDataAndFiles
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configTable];
    [self configDataAndFiles];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refreshTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data source & Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_articles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseCellID forIndexPath:indexPath];
    NSAssert(cell, @"ERROR: You must register cell: [_tableView registerNib:cell forCellReuseIdentifier:cellID]; ");

    PSArticle *article = [self articleAtIndexPath:indexPath];
    cell.title = article.title;
    cell.description = article.subtitle;
    cell.imageLink = article.imageLink;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    return _categoryName;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GRKPageViewController *articlePages = [GRKPageViewController new];
    articlePages.delegate = self;
    articlePages.dataSource = self;
    [articlePages setCurrentIndex:indexPath.row animated:YES];
    
    [self.navigationController pushViewController:articlePages animated:YES];
    
}

#pragma mark - Article

- (PSArticle *)articleAtIndexPath:(NSIndexPath *)indexPath
{
    return [self articleAtIndex:indexPath.row];
}

- (PSArticle *)articleAtIndex:(NSInteger)index
{
    return _articles[index];
}

#pragma mark - Load & Parce DATA
- (void) reloadDataForCategory:(NSString *)category withName:(NSString *)categoryName
{

    [_refreshControl beginRefreshing];
    [_tableView setContentOffset:CGPointMake(0, - _refreshControl.frame.size.height) animated:YES];
    
    _category = category;
    _categoryName = categoryName;
    [[PSArticlesTransmitter sharedArticlesTransmitter] downloadArticles:_category
                                                               complete:^(NSString *timeStamp, NSArray *returnedArticles)
     {
         //Save to PSArticlesManager;
         PSArticlesManager *manager = [PSArticlesManager sharedArticlesManager];
         [manager parceArticlesToArray:returnedArticles];
         
         _articles = [manager articles];
         [_tableView reloadData];
         [_refreshControl endRefreshing];
         
     }];
}

-(void) refreshTable
{
    [self reloadDataForCategory:_category withName:_categoryName];
}

#pragma mark - Slide Data
- (NSUInteger)pageCount
{
    return [_articles count];
}

- (UIViewController *)viewControllerForIndex:(NSUInteger)index
{
    NSBundle *classBundle = [NSBundle bundleForClass:[PSArticleController class]];

    __strong PSArticleController *articleController = [[PSArticleController alloc] initWithNibName:@"PSArticleController" bundle:classBundle];
    [articleController view];
    
    __weak PSArticle *article = [self articleAtIndex:index];
    
    articleController.article = article;
    [[PSArticlesTransmitter sharedArticlesTransmitter] downloadArticle:article.ID
                                                              complete:^(NSDictionary *fullArticle)
     {
         if (fullArticle) {
             [article addDetailFromDictionary:fullArticle];
             articleController.article = article;
         } else {
             //We must show error because detail page didn't downloaded
             
         }
     }];
    
    return articleController;
}

@end
