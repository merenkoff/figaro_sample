//
//  PSArticlesVController.h
//  LaFigaro-example
//
//  Created by Sergei Merenkov  on 5/28/14.
//  Copyright (c) 2014 PlaySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GRKPageViewController/GRKPageViewController.h>

@interface PSArticlesVController : UIViewController <UITableViewDataSource, UITableViewDelegate, GRKPageViewControllerDataSource, GRKPageViewControllerDelegate>
@property (nonatomic, assign) NSInteger currentCattegory;
- (void) reloadDataForCategory:(NSString *)category withName:(NSString *)categoryName;

@end
