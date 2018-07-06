//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTObject;

@interface HTTableViewCell : UITableViewCell

@property (nonatomic, strong) NSURL *imageUrl;

- (void) showWithData: (HTObject *) data;
/** Initializes with default cell style */
+ (instancetype)cellWithTableView:(__kindof UITableView *)tableView reuseIdentifier:(NSString *)identifier;
/** Initializes with custom cell style */
+ (instancetype)cellWithTableView:(__kindof UITableView *)tableView reuseIdentifier:(NSString *)identifier andStyle:(UITableViewCellStyle)style;

@end
