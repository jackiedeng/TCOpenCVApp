//
//  Section4TestCase.m
//  TCOpenCVApp
//
//  Created by jackiedeng on 2018/12/19.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "Section4TestCase.h"

@interface Section4TestCase ()

@end

@implementation Section4TestCase

- (NSString*)title{
    return @"第4章节练习";
}

- (NSArray*)controlItems{
    return @[];
}

- (ProcessType)processType{
    return multi_stage;
}

- (void)processImageWithConfigs:(NSDictionary*)configs
                  stageImageSet:(void(^)(Mat img,UIImage*ocimage,NSString *label))check{
    CV_TEST_CODE_BEGIN
    
    Mat src;
    
    Test1Mat(src);
    
    check(src,nil,@"练习2 积分图（练习一打字一很无聊略过了）");
    
    Mat chanels[4];
    
    split(src, chanels);
    
    check(chanels[0],nil,@"0通道");
    check(chanels[1],nil,@"1通道");
    check(chanels[2],nil,@"2通道");
    
    CV_TEST_CODE_END
}

@end
