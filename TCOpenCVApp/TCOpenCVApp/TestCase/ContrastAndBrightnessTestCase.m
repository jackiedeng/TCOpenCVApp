//
//  ContrastAndBrightnessTestCase.m
//  TCOpenCVApp
//
//  Created by Jackie on 2018/12/18.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "ContrastAndBrightnessTestCase.h"

@interface ContrastAndBrightnessTestCase ()

@end

@implementation ContrastAndBrightnessTestCase

- (NSString*)title{
    return @"对比度&亮度";
}
- (NSArray*)controlItems{
    return @[
             [SlideConfigItem slideConfigWithTitle:@"constrast(对比度)"
                                               key:@"constrast"
                                             range:NSMakeRange(0, 3)
                                      defaultValue: 1],
             [SlideConfigItem slideConfigWithTitle:@"brightness(亮度)"
                                               key:@"brightness"
                                             range:NSMakeRange(0, 255)
                                      defaultValue: 1]
             
             ];
}
- (cv::Mat)prcessImageWithConfigs:(NSDictionary*)config{
    
    float constrast = getFloatValue(@"constrast", config);
    float brightness = getFloatValue(@"brightness", config);
    
    Mat src = [self imageNamed:@"test.png"];
    
    Mat process = lhImg(src);
    
    process.convertTo(process, -1,constrast,brightness);
    
    return src;
}

@end
