//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTCollectionViewCell.h"

@implementation HTCollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collecctionView identifier:(NSString *)identifier forIndexPatch:(NSIndexPath *)indexPatch {
    HTCollectionViewCell *cell = [collecctionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPatch];
    if (!cell) {
        cell = [[HTCollectionViewCell alloc] init];
    }
    
    [cell loadSubView];
    
    return cell;
}

- (void)loadSubView {
    
}

@end
