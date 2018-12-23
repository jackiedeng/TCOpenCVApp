//
//  DrawMaskConfigItem.h
//  TCOpenCVApp
//
//  Created by Chao Deng on 2018/12/22.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "OpCvConfigItem.h"

typedef enum{
    DRAW_MASK=0,
    RECT_MASK,
    NONE_MASK
}DrawMaskType;

NS_ASSUME_NONNULL_BEGIN

@interface DrawMaskConfigItem : OpCvConfigItem 
+ (instancetype)drawMask:(NSString* _Nonnull)title
                     key:(NSString* _Nonnull) key
                   image:(UIImage* _Nonnull)image;

+ (instancetype)drawMaskWithType:(DrawMaskType)type
                           title:(NSString* _Nonnull)title
                         key:(NSString* _Nonnull) key
                       image:(UIImage* _Nonnull)image;
@end

NS_ASSUME_NONNULL_END
