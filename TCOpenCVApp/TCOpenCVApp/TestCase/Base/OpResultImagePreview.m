//
//  OpResultImagePreview.m
//  TCOpenCVApp
//
//  Created by jackiedeng on 2018/12/18.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "OpResultImagePreview.h"

@implementation OpResultImageItem
+ (OpResultImageItem*)itemWithImage:(UIImage*)image label:(NSString*)label{
    OpResultImageItem * item = [OpResultImageItem new];
    item.title = label;
    item.image = image;
    return item;
}

- (float)createDisplayViewToContentView:(UIView*)contentView
                       withLayoutHeight:(float)height{
    
    if(self.displayView){
        [self clean];
    }
    
    OpResultImagePreview * preview = [[OpResultImagePreview alloc] initWithImageItem:self];
    self.displayView = preview;
    [contentView addSubview:preview];
    
    preview.layer.anchorPoint = CGPointZero;
    preview.center = CGPointMake(0, height);
    
    return height+preview.frame.size.height;
}

- (void)clean{
    [self.displayView removeFromSuperview];
}
@end

@implementation OpResultImagePreview

- (void)createMainWithItem:(OpResultImageItem*)item{
    
    //label
    UILabel * label = [[UILabel alloc] init];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:13];
    label.text = item.title;
    [label sizeToFit];
    //imageview
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.image = item.image;
    [imageView sizeToFit];
    
    //size to fit
    CGRect rect = imageView.bounds;
    rect.size.height *=  ([UIScreen mainScreen].bounds.size.width/rect.size.width);
    rect.size.width = [UIScreen mainScreen].bounds.size.width;
    imageView.frame = rect;

    //layout
    [self addSubview:label];
    [self addSubview:imageView];
    
    label.layer.anchorPoint = CGPointZero;
    label.center = CGPointMake(10, 10);
    
    imageView.layer.anchorPoint = CGPointZero;
    imageView.center = CGPointMake(0, label.frame.origin.y+label.frame.size.height+10);
    
    [self setFrame:CGRectMake(0, 0,
                              imageView.frame.size.width,
                              imageView.frame.size.height+imageView.frame.origin.y+10)];
}

- (id)initWithImageItem:(OpResultImageItem*)item{
    
    self = [super initWithFrame:CGRectZero];
    
    if(self){
        [self createMainWithItem:item];
    }
    
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
