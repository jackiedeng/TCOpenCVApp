//
//  OpenCVTool.h
//  TCOpenCVApp
//
//  Created by jackiedeng on 2018/12/17.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define Test1Mat(x) UIImageToMat([UIImage imageNamed:@"test.png"], x)

NS_ASSUME_NONNULL_BEGIN

@interface CVUtil : NSObject
+ (UIImage*)test;
@end

NS_ASSUME_NONNULL_END
