//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTView.h"

@interface HTActionSheetView : HTView

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, copy) void (^onTouch)(NSInteger index);

@end
