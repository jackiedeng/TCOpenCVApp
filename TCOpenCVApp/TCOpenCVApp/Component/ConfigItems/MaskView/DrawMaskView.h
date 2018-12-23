//
//  DrawMaskView.h
//  TCOpenCVApp
//
//  Created by Chao Deng on 2018/12/23.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DrawMaskView : UIView{
    CGContextRef _drawContext;
    CGPoint _lastPoint;

}
@property (nonatomic,strong) UIImage * image;

- (void)clean;
- (UIImage*)maskImage;
- (NSDictionary*)maskValue;
@end

NS_ASSUME_NONNULL_END
