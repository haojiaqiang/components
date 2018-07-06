//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTTableViewCell.h"
#import "HTObject.h"

@implementation HTTableViewCell{
    UIView *_view;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (instancetype)cellWithTableView:(nonnull __kindof UITableView *)tableView reuseIdentifier:(nonnull NSString *)identifier {
    return [self.class cellWithTableView:tableView reuseIdentifier:identifier andStyle:UITableViewCellStyleDefault];
}

+ (instancetype)cellWithTableView:(nonnull __kindof UITableView *)tableView reuseIdentifier:(nonnull NSString *)identifier andStyle:(UITableViewCellStyle)style {
    HTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:style reuseIdentifier:identifier];
    }
    return cell;
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
}

- (void) showWithData:(HTObject *)data{
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
