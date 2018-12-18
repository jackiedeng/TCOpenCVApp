//
//  OpResultImagePreview.h
//  TCOpenCVApp
//
//  Created by jackiedeng on 2018/12/18.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OpResultImagePreview;

NS_ASSUME_NONNULL_BEGIN

@interface OpResultImageItem : NSObject
@property (strong) UIImage * image;
@property (strong) NSString * title;
@property (weak)  OpResultImagePreview * displayView;

+ (OpResultImageItem*)itemWithImage:(UIImage*)image
                              label:(NSString*)label;
- (float)createDisplayViewToContentView:(UIView*)contentView
                       withLayoutHeight:(float)height;
- (void)clean;

@end

NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN

@interface OpResultImagePreview : UIView
- (id)initWithImageItem:(OpResultImageItem*)item;
@end

NS_ASSUME_NONNULL_END
