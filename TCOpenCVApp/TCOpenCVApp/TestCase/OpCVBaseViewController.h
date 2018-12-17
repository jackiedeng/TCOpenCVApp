//
//  OpCVBaseViewController.h
//  TCOpenCVApp
//
//  Created by jackiedeng on 2018/12/17.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/core/types.hpp>
#import <opencv2/core/utility.hpp>
#import <opencv2/imgproc/types_c.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpCVBaseViewController : UIViewController
- (NSString*)title;
- (NSArray*)controlItems;
- (cv::Mat)prcessImageWithConfigs:(NSDictionary*)configs;
@end

NS_ASSUME_NONNULL_END
