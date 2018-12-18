//
//  SelectionConfigItem.m
//  TCOpenCVApp
//
//  Created by Jackie on 2018/12/18.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "SelectionConfigItem.h"

#define SelectionsKey @"selections"

@implementation SelectionConfigItem
{
    NSDictionary * _selections;
}

+ (instancetype)selectConfigWithTitle:(NSString* _Nonnull)title
                                  key:(NSString* _Nonnull) key
                           selections:(NSDictionary* _Nonnull) selections
                         defaultValue:(NSString*)defaultvalue{
    
    SelectionConfigItem * newItem = [[SelectionConfigItem alloc] initWithTitle:title
                                                                   key:key
                                                                Config:^(NSMutableDictionary * _Nonnull dict) {
                                                                    
                                                                    [dict setObject:selections                                                                             forKey:SelectionsKey];
                                                                
                                                                }];
    newItem.value = defaultvalue;
    
    return newItem;
}

- (UIView* _Nonnull)createView:(NSDictionary* _Nonnull)config{
   
    //get segementArray from selections
    NSDictionary * selections = [config objectForKey:SelectionsKey];

    _selections = selections;
    
    int defalutSelectIndex = 0;
    
    for(int i = 0; i < selections.allKeys.count; i++){
    
        NSString * key = [selections.allKeys objectAtIndex:i];
        if([self.value isEqualToString:[selections objectForKey:key]]){
            defalutSelectIndex = i;
        }
    }
    
    
    UISegmentedControl * segment = [[UISegmentedControl alloc] initWithItems:selections.allKeys];
    
    segment.frame = [self rectWithHeight:44];
    
    [segment setSelectedSegmentIndex:defalutSelectIndex];
    
    [segment addTarget:self
                action:@selector(onValueChange:)
      forControlEvents:UIControlEventValueChanged];
    
    return segment;
}

- (id)getCurrentValue{
    return [_selections objectForKey:[[_selections allKeys] objectAtIndex:[(UISegmentedControl*)self.view selectedSegmentIndex]]];
}

- (void)onValueChange:(UISlider*)sender{
    [self setNeedUpdate];
}

@end
