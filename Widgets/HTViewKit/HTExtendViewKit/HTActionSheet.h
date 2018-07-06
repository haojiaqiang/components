//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTPopoverView.h"
#import "HTObject.h"

@class HTButton;
@interface HTActionSheet : HTPopoverView

@property (nonatomic, copy) void (^selectAtIndex)(NSInteger index);
@property (nonatomic, assign) NSTextAlignment titleAlignment;

- (id) initWithTitle:(NSString*) title maxColumns:(NSInteger) columns items:(NSArray*) items;
- (id) initWithTitle:(NSString*) title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
- (id) initWithTitle:(NSString*) title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitlesInArray:(NSArray*)otherButtonTitles;

- (void) setActionEnabled:(BOOL) enabled atIndex:(NSInteger) buttonIndex;
- (HTButton *) buttonAtIndex:(NSInteger) buttonIndex;

@end

@interface HTActionSheetItem : HTObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *normalImage;
@property (nonatomic, copy) NSString *selectedImage;
@property (nonatomic, copy) NSString *highlightImage;
@property (nonatomic, copy) NSString *disabledImage;

@end
