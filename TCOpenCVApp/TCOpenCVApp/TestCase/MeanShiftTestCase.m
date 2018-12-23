//
//  Mean-ShiftTestCase.m
//  TCOpenCVApp
//
//  Created by Chao Deng on 2018/12/23.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "MeanShiftTestCase.h"

@interface MeanShiftTestCase ()

@end

@implementation MeanShiftTestCase

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (NSString*)title{
    return @"[cut]Mean-Shift图像分割";
}

- (NSArray*)controlItems{
    return @[
             [DrawMaskConfigItem drawMaskWithType:NONE_MASK
                                            title:@"mask"
                                              key:@"mask"
                                            image:[UIImage imageNamed:@"test2.png"]]
             ];
}

- (ProcessType)processType{
    return multi_stage;
}

- (void)processImageWithConfigs:(NSDictionary*)configs
                  stageImageSet:(void(^)(Mat img,NSString *label))check
                uiimageStageSet:(void(^)(UIImage* img,NSString *label))uiCheck{
    CV_TEST_CODE_BEGIN
    
 
    NSDictionary * dict = [configs objectForKey:@"mask"];
    UIImage * image = [dict objectForKey:@"image"];
    
    Mat src;
    UIImageToMat(image, src);
    
    cvtColor(src, src, CV_RGBA2RGB);
    
    Mat result;
    
    cv::pyrMeanShiftFiltering(src, result, 20, 40);
    
    check(result,@"result");
    
    
    CV_TEST_CODE_END
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
