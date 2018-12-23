//
//  DrawRectMaskView.m
//  TCOpenCVApp
//
//  Created by Chao Deng on 2018/12/23.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "DrawRectMaskView.h"

@implementation DrawRectMaskView
{
    CGPoint _beginPoint;
    CGPoint _endPoint;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    _beginPoint = point;
//    _beginPoint = [self transToImagePoint:point];
    
}

- (CGPoint)transToImagePoint:(CGPoint)point{
    
    float dx = point.x/self.frame.size.width;
    float dy = point.y/self.frame.size.height;

    float picX = self.image.size.width*dx;
////    float picY = self.image.size.height - self.image.size.height*dy;
    float picY = self.image.size.height*dy;
    return CGPointMake(picX, picY);
    return point;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
//    point = [self transToImagePoint:point];

    _endPoint = point;
//        NSLog(@"%@-%@",NSStringFromCGPoint(_beginPoint),NSStringFromCGPoint(_endPoint));
    [self setNeedsDisplay];
}

- (CGRect)maskRect{
  
    CGPoint begin = [self transToImagePoint:_beginPoint];
    CGPoint end = [self transToImagePoint:_endPoint];
    
    return CGRectMake(begin.x, begin.y, abs(begin.x-end.x), abs(begin.y-end.y));
}

- (CGRect)drawRect{
    CGPoint begin = _beginPoint;
    CGPoint end = _endPoint;
    
    return CGRectMake(begin.x, begin.y, abs(begin.x-end.x), abs(begin.y-end.y));
}

- (void)drawRect:(CGRect)rect{
    
    [self.image drawInRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context,[UIColor whiteColor].CGColor);
    
    CGContextStrokeRect(context, [self drawRect]);
    
}


- (NSDictionary*)maskValue{
    
    return @{@"maskRect":[NSValue valueWithCGRect:[self maskRect]],@"image":[self image]};
}
@end
