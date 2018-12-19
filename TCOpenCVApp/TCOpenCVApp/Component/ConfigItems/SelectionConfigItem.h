//
//  SelectionConfigItem.h
//  TCOpenCVApp
//
//  Created by Jackie on 2018/12/18.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "OpCvConfigItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectionConfigItem : OpCvConfigItem
+ (instancetype)selectConfigWithTitle:(NSString* _Nonnull)title
                                  key:(NSString* _Nonnull) key
                           selections:(NSDictionary* _Nonnull) selections
                         defaultValue:(NSString*)defaultvalue;
@end

NS_ASSUME_NONNULL_END
