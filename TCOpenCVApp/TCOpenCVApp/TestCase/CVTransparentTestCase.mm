//
//  CVTransparentTestCase.m
//  TCOpenCVApp
//
//  Created by Chao Deng on 2018/12/17.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "CVTransparentTestCase.h"
#import "SlideConfigItem.h"

@implementation CVTransparentTestCase
- (NSString*)title{
    return @"图片叠加";
}
- (NSArray*)controlItems{
    return @[
             [SlideConfigItem slideConfigWithTitle:@"alpha"
                                               key:@"alpha"
                                             range:NSMakeRange(0, 1)
                                      defaultValue: 0.5]
             ];
}
- (cv::Mat)prcessImageWithConfigs:(NSDictionary*)configs{
    
    float alpha = getFloatValue(@"alpha",configs);
    
    Mat src = [self imageNamed:@"test.png"];
    
    Mat bk = Mat(src.rows,src.cols,src.type(),Scalar(255,255,0,255));
    
    addWeighted(src, alpha, bk, 1.0-alpha, 0.0, src);
    
    return src;
}
@end
