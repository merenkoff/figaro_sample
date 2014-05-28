//
//  PSArticlesVController.m
//  LaFigaro-example
//
//  Created by Sergei Merenkov  on 5/28/14.
//  Copyright (c) 2014 PlaySoft. All rights reserved.
//

#import "PSArticlesVController.h"
#import "ArticleItemCell.h"

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
    return 3;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseCellID forIndexPath:indexPath];
    NSAssert(cell, @"ERROR: You must register cell: [_tableView registerNib:cell forCellReuseIdentifier:cellID]; ");

    cell.title = @"Article name\nTesting long text with\nlines 2";
    cell.description = @"Article Description";

    return cell;
}

@end
