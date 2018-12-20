//
//  SobelTestCase.m
//  TCOpenCVApp
//
//  Created by Chao Deng on 2018/12/20.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "SobelTestCase.h"

@interface SobelTestCase ()

@end

@implementation SobelTestCase

- (NSString*)title{
    return @"索贝尔(Sobel)算子";
}

- (NSArray*)controlItems{
    return @[
             [SelectionConfigItem selectConfigWithTitle:@"顺序"
                                                    key:@"order"
                                             selections:@{@"xfirst":@"x",@"yfirst":@"y",@"nox":@"nox",@"noy":@"noy"}
                                           defaultValue:@"x"],
             
             [SelectionConfigItem selectConfigWithTitle:@"kSize"
                                                    key:@"k"
                                             selections:@{@"3":@"3",@"5":@"5",@"7":@"7",@"9":@"9",@"scharr":@"scharr"}
                                           defaultValue:@"3"],
             [SlideConfigItem slideConfigWithTitle:@"scale"
                                               key:@"scale"
                                             range:NSMakeRange(1, 10)
                                      defaultValue:1],
             [SlideConfigItem slideConfigWithTitle:@"delta"
                                               key:@"delta"
                                             range:NSMakeRange(0, 255)
                                      defaultValue:0]
             ];
}

- (ProcessType)processType{
    return multi_stage;
}

- (void)processImageWithConfigs:(NSDictionary*)configs
                  stageImageSet:(void(^)(Mat img,NSString *label))check
                uiimageStageSet:(void(^)(UIImage* img,NSString *label))uiCheck{
    CV_TEST_CODE_BEGIN
 
    NSString* ksize = getValue(@"k", configs);
    float scale = getFloatValue(@"scale", configs);
    float delta = getFloatValue(@"delta", configs);
    NSString* order = getValue(@"order", configs);
    
    Mat src;
    Test1Mat(src);
    cvtColor(src, src, CV_RGBA2RGB);
    
    int xorder = 1;
    int yorder = 2;
    
    if([order isEqualToString:@"y"]){
        xorder = 2;
        yorder = 1;
    }else if([order isEqualToString:@"nox"]){
        xorder = 0;
        yorder = 1;
    }else if([order isEqualToString:@"noy"]){
        xorder = 1;
        yorder = 0;
    }
    
    int size = -1;
    if(![ksize isEqualToString:@"scharr"]){
        size = [ksize intValue];
    }else{
        
        if(xorder+yorder > 1){
            xorder -= 1;
            yorder -= 1;
        }
        
    }

    cv::Sobel(src, src, src.depth(), xorder, yorder,size,scale,delta);
    
 
    check(src,@"result");
    
    CV_TEST_CODE_END
}

@end
