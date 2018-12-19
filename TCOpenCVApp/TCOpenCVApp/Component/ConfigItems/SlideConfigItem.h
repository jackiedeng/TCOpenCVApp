//
//  SlideConfigItem.h
//  TCOpenCVApp
//
//  Created by jackiedeng on 2018/12/17.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "OpCvConfigItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface SlideConfigItem : OpCvConfigItem
+ (instancetype)slideConfigWithTitle:(NSString* _Nonnull)title
                                key:(NSString* _Nonnull) key
                              range:(NSRange)range
                       defaultValue:(float)defaultvalue;
@end

NS_ASSUME_NONNULL_END
