//
//  SlideConfigItem.m
//  TCOpenCVApp
//
//  Created by jackiedeng on 2018/12/17.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "SlideConfigItem.h"

#define rangeKey @"rangeKey"
#define defaultValueKey @"defaultValueKey"

@implementation SlideConfigItem

+ (instancetype)slideConfigWithTitle:(NSString* _Nonnull)title
                                key:(NSString* _Nonnull) key
                              range:(NSRange)range
                       defaultValue:(float)defaultvalue{
    
    SlideConfigItem * newItem = [[SlideConfigItem alloc] initWithTitle:title
                                                                   key:key
                                                                Config:^(NSMutableDictionary * _Nonnull dict) {
                                                                    
                                                                    [dict setObject:[NSValue valueWithRange:range]
                                                                             forKey:rangeKey];
                                                                    [dict setObject:[NSNumber numberWithFloat:defaultvalue]
                                                                             forKey:defaultValueKey];
                                                                }];
    newItem.value = [NSNumber numberWithFloat:defaultvalue];
    
    return newItem;
}
    
- (UIView* _Nonnull)createView:(NSDictionary* _Nonnull)config{

    NSRange range = [[config objectForKey:rangeKey] rangeValue];
    float defaultValue = [[config objectForKey:defaultValueKey] floatValue];
    
    UISlider * slide = [[UISlider alloc] initWithFrame:[self rectWithHeight:100]];
    
    [slide setMinimumValue:range.location];
    [slide setMaximumValue:range.location+range.length];
    [slide setValue:defaultValue];
    
    [slide addTarget:self
              action:@selector(onValueChange:)
    forControlEvents:UIControlEventValueChanged];
    
    return slide;
}

- (id)getCurrentValue{
    return [NSNumber numberWithFloat:[(UISlider*)[self itemView] value]];
}
    
- (void)onValueChange:(UISlider*)sender{
    [self setNeedUpdate];
}

@end
