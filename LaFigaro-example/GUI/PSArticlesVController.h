//
//  PSArticlesVController.h
//  LaFigaro-example
//
//  Created by Sergei Merenkov  on 5/28/14.
//  Copyright (c) 2014 PlaySoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSArticlesVController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) NSInteger currentCattegory;
- (void) reloadDataForCategory:(NSString *)category withName:(NSString *)categoryName;

@end
