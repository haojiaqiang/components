//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "HTObject.h"

@interface HTCollectionViewCell : UICollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collecctionView identifier:(NSString *)identifier forIndexPatch:(NSIndexPath *)indexPatch;

@end
