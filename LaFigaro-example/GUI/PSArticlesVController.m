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

#define MAIN_CATEGORY @"QWN0dWFsaXTDqXNBY3R1YWxpdMOpcw=="

NSString *const kReuseCellID = @"kReuseArticleItemCell";

@interface PSArticlesVController ()
{
    NSArray *_articles;
    IBOutlet UITableView *_tableView;
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configTable];
    
    [[PSArticlesTransmitter sharedArticlesTransmitter] downloadArticles:MAIN_CATEGORY
                                                               complete:^(NSString *timeStamp, NSArray *returnedArticles)

    {
        //Save to PSArticlesManager;
        PSArticlesManager *manager = [PSArticlesManager sharedArticlesManager];
        [manager parceArticlesToArray:returnedArticles];
        
        _articles = [manager articles];
        [_tableView reloadData];
        
    }];

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak PSArticle *article = [self articleAtIndexPath:indexPath];
    [[PSArticlesTransmitter sharedArticlesTransmitter] downloadArticle:article.ID
                                                              complete:^(NSDictionary *fullArticle)
    {
        if (fullArticle) {
            [article setValuesForKeysWithDictionary:fullArticle];
            NSLog(@"Article \n %@", fullArticle);
            
            NSBundle *classBundle = [NSBundle bundleForClass:[PSArticleController class]];
            PSArticleController *articleController = [[PSArticleController alloc] initWithNibName:@"PSArticleController" bundle:classBundle];
            [articleController view];
            [self.navigationController pushViewController:articleController animated:YES];
            articleController.article = article;
        } else {
            //We must show error because detail page didn't downloaded
            
        }
        
    }];
    
}

#pragma mark - Article

- (PSArticle *)articleAtIndexPath:(NSIndexPath *)indexPath
{
    return _articles[indexPath.row];
}

@end
