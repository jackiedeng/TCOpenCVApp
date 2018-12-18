//
//  BaseDrawTestVase.m
//  TCOpenCVApp
//
//  Created by Jackie on 2018/12/18.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "BaseDrawTestVase.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface BaseDrawTestVase ()
{
    Mat src;
}
@end

@implementation BaseDrawTestVase

- (NSString*)title{
    return @"基本绘制";
}
- (NSArray*)controlItems{
    return @[
            [SelectionConfigItem  selectConfigWithTitle:@"基本图形"
                                                    key:@"type"
                                             selections:@{
                                                          @"线条":@"drawLines",
                                                          @"椭圆":@"drawEll",
                                                          @"矩形":@"drawRect",
                                                          @"圆形":@"drawCircle",
                                                          @"多边形":@"drawPoly"
                                                          }
                                           defaultValue:@"poly"]
             ];
}
- (cv::Mat)prcessImageWithConfigs:(NSDictionary*)config{
    
    NSString * type = getValue(@"type", config);
    
    NSLog(@"select type %@",type);
    
    src = Mat(cv::Size(600,600),CV_8UC4,Scalar(0,0,0,255));
    
    SEL sel = NSSelectorFromString(type);
    if(sel && [self respondsToSelector:sel]){
        objc_msgSend(self,sel);
    }
    return src;
}

- (void)drawLines{
    
    cv::line(src,cv::Point(0,0),cv::Point(src.size().width,src.size().height),Scalar(255,0,0,255),3);
    cv::line(src,cv::Point(src.size().width,src.size().height),cv::Point(0,0),Scalar(255,0,0,255),3);
    cv::line(src,cv::Point(src.size().width/2,0),cv::Point(src.size().width/2,src.size().height),Scalar(255,0,0,255),3);
    cv::line(src,cv::Point(0,src.size().height/2),cv::Point(src.size().width,src.size().height/2),Scalar(255,0,0,255),3);
}

- (void)drawEll{
    
    cv::ellipse(src, cv::Point(300,300), cv::Size(300,100), 0, 0, 360, Scalar(0,255,0,255));
}

- (void)drawRect{
    cv::rectangle(src, cv::Point(10,10), cv::Point(300,300), Scalar(255,0,0,255));
    
}

- (void)drawPoly{
    
    int lineType = 8;
    float w = 300.0;
    /** 创建一些点 */
    cv::Point rook_points[1][20];
    rook_points[0][0] = cv::Point( w/4.0, 7*w/8.0 );
    rook_points[0][1] = cv::Point( 3*w/4.0, 7*w/8.0 );
    rook_points[0][2] = cv::Point( 3*w/4.0, 13*w/16.0 );
    rook_points[0][3] = cv::Point( 11*w/16.0, 13*w/16.0 );
    rook_points[0][4] = cv::Point( 19*w/32.0, 3*w/8.0 );
    rook_points[0][5] = cv::Point( 3*w/4.0, 3*w/8.0 );
    rook_points[0][6] = cv::Point( 3*w/4.0, w/8.0 );
    rook_points[0][7] = cv::Point( 26*w/40.0, w/8.0 );
    rook_points[0][8] = cv::Point( 26*w/40.0, w/4.0 );
    rook_points[0][9] = cv::Point( 22*w/40.0, w/4.0 );
    rook_points[0][10] = cv::Point( 22*w/40.0, w/8.0 );
    rook_points[0][11] = cv::Point( 18*w/40.0, w/8.0 );
    rook_points[0][12] = cv::Point( 18*w/40.0, w/4.0 );
    rook_points[0][13] = cv::Point( 14*w/40.0, w/4.0 );
    rook_points[0][14] = cv::Point( 14*w/40.0, w/8.0 );
    rook_points[0][15] = cv::Point( w/4.0, w/8.0 );
    rook_points[0][16] = cv::Point( w/4.0, 3*w/8.0 );
    rook_points[0][17] = cv::Point( 13*w/32.0, 3*w/8.0 );
    rook_points[0][18] = cv::Point( 5*w/16.0, 13*w/16.0 );
    rook_points[0][19] = cv::Point( w/4.0, 13*w/16.0) ;
    
    const cv::Point* ppt[1] = { rook_points[0] };
    int npt[] = { 20 };
    
    fillPoly( src,
             ppt,
             npt,
             1,
             Scalar( 255, 255, 255 ),
             lineType );
}

- (void)drawCircle{
    
    circle(src, cv::Point(300,300), 50, Scalar(0,0,255,255));
}
@end
