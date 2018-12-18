//
//  RandomDrawTestCase.m
//  TCOpenCVApp
//
//  Created by Jackie on 2018/12/18.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "RandomDrawTestCase.h"

@interface RandomDrawTestCase ()

@end

@implementation RandomDrawTestCase


- (NSString*)title{
    return @"随机绘制";
}
- (NSArray*)controlItems{
    return @[
             
             
             ];
}
- (cv::Mat)prcessImageWithConfigs:(NSDictionary*)config{
    
    Mat src = [self imageNamed:@"test.png"];
    
    RNG rng( 0xFFFFFFFF );
    
    [self drawing_Random_Lines:src rand:rng];
    
    return src;
}

#define NUMBER 300
-(Scalar)randomColor:(RNG)rng
{
    int icolor = (unsigned) rng;
    return Scalar( icolor&255, (icolor>>8)&255, (icolor>>16)&255,255);
}

- (int)drawing_Random_Lines:(Mat)image
                       rand:(RNG)rng
{
    
    cv::Point pt1, pt2;
    int x_1 = 0;
    int x_2 = image.size().width;
    int y_1 = 0;
    int y_2 = image.size().height;
    
    for( int i = 0; i < NUMBER; i++ )
    {
        pt1.x = rng.uniform( x_1, x_2 );
        pt1.y = rng.uniform( y_1, y_2 );
        pt2.x = rng.uniform( x_1, x_2 );
        pt2.y = rng.uniform( y_1, y_2 );
        
        line( image, pt1, pt2, [self randomColor:rng], rng.uniform(1, 10), 8 );
    }
    return 0;
}

@end
