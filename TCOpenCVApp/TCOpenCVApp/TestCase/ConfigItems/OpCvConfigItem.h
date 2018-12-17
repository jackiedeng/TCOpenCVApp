//
//  OpCvConfigItem.h
//  TCOpenCVApp
//
//  Created by jackiedeng on 2018/12/17.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class OpCvConfigItem;

@protocol OpCvConfigItemProtocol <NSObject>
@required
- (UIView* _Nonnull)createView:(NSDictionary* _Nonnull)config;
- (void)fillValueToDict:(NSMutableDictionary* _Nonnull)dict;
@end

@protocol OpCvConfigItemUpdateProtocol <NSObject>
@required
- (void)opCvConfigItemDidUpdateValue:(OpCvConfigItem* _Nonnull)item;
@end

NS_ASSUME_NONNULL_BEGIN

@interface OpCvConfigItem : NSObject <OpCvConfigItemProtocol>
    
@property(strong) NSMutableDictionary * config;
@property(strong) NSString * title;
@property(strong) NSString * key;
@property(weak) UILabel * displayLabel;
@property(weak) id value;
@property(weak) id view;
@property(weak) id<OpCvConfigItemUpdateProtocol> delegate;
    
- (instancetype)initWithTitle:(NSString* _Nonnull)title
                          key:(NSString* _Nonnull)key
                       Config:(void(^)(NSMutableDictionary* _Nonnull))dictBlock;
- (UIView* _Nonnull)itemView;
- (NSString* _Nonnull)displayText;
- (CGRect)rectWithHeight:(float)height;
- (void)setNeedUpdate;
@end

NS_ASSUME_NONNULL_END
