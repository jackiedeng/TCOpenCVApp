//
//  DrawMaskView.m
//  TCOpenCVApp
//
//  Created by Chao Deng on 2018/12/23.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "DrawMaskView.h"


@implementation DrawMaskView


- (UIImage*)maskImage{
    
    CGRect rect = CGRectMake(0, 0, _image.size.width, _image.size.height);
    
    UIGraphicsBeginImageContextWithOptions(_image.size, false, 1.0);
    
    [[UIColor blackColor] setFill];
    
    UIRectFill(rect);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(_drawContext);
    
    [[UIImage imageWithCGImage:imageRef] drawInRect:rect];
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)clean{
    
    CGContextClearRect(_drawContext, CGRectMake(0, 0, _image.size.width, _image.size.height));
    
    [self setNeedsDisplay];
}

- (CGContextRef)createNewContext{
    //create context
    int piexlWidth = _image.size.width;
    int piexlHeight = _image.size.height;
    int bitmapBytesPreRow = piexlWidth*4;
    //    int bitmapByteCount = bitmapBytesPreRow * piexlHeight;
    
    CGContextRef newContext = CGBitmapContextCreate(NULL
                                                    , piexlWidth
                                                    , piexlHeight
                                                    ,8
                                                    , bitmapBytesPreRow
                                                    , CGColorSpaceCreateDeviceRGB(),
                                                    kCGImageAlphaPremultipliedLast);
    
    if(newContext == NULL){
        NSLog(@">>>>>>>>:::create context faile!");
        return NULL;
    }
    
    
    CGContextSetBlendMode(newContext, kCGBlendModeCopy);
    CGContextSetStrokeColorWithColor(newContext, [UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor);
    CGContextSetLineWidth(newContext, 10);
    CGContextSetLineJoin(newContext, kCGLineJoinRound);
    CGContextSetLineCap(newContext, kCGLineCapRound);
    
    return newContext;
}

- (void)setImage:(UIImage *)image{
    
    _image = image;
    
    NSLog(@"do some thing");
    _drawContext = [self createNewContext];
    
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    //    _lastPoint = eent
    _lastPoint = [self transToImagePoint:point];
    
}

- (CGPoint)transToImagePoint:(CGPoint)point{
    
    float dx = point.x/self.frame.size.width;
    float dy = point.y/self.frame.size.height;
    
    float picX = _image.size.width*dx;
    float picY = _image.size.height - _image.size.height*dy;
    
    return CGPointMake(picX, picY);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"end->>");
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    point = [self transToImagePoint:point];
    
    CGContextMoveToPoint(_drawContext, _lastPoint.x, _lastPoint.y);
    CGContextAddLineToPoint(_drawContext, point.x, point.y);
    CGContextStrokePath(_drawContext);
    
    _lastPoint = point;
    //    NSLog(@"%@",NSStringFromCGPoint(_lastPoint));
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    
    [self.image drawInRect:rect];
    
    CGImageRef imageRef = CGBitmapContextCreateImage(_drawContext);
    
    [[UIImage imageWithCGImage:imageRef] drawInRect:rect];
    
}

- (NSDictionary*)maskValue{
 
    return @{@"mask":[self maskImage],@"image":[self image]};
}
@end
