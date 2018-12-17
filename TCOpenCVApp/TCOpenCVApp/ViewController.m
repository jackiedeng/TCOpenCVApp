//
//  ViewController.m
//  TCOpenCVApp
//
//  Created by jackiedeng on 2018/12/17.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "ViewController.h"
#import "OpenCVTool.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    
    imageView.image = [OpenCVTool test];
    
    [imageView sizeToFit];
    
    imageView.layer.anchorPoint = CGPointZero;
    imageView.center = CGPointMake(0, (self.view.frame.size.height-imageView.frame.size.height)/2);
    [self.view addSubview:imageView];
    
}


@end
