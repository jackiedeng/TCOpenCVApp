//
//  ViewController.m
//  TCOpenCVApp
//
//  Created by jackiedeng on 2018/12/17.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "ViewController.h"
#import "OpenCVTool.h"
#import "OpCVBaseViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray<OpCVBaseViewController*> * _testCtrs;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSLog(@"did load!!!!!");
    self.navigationItem.title = @"opencv lab";
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    //read info
    NSString * path = [[NSBundle mainBundle] pathForResource:@"testcase"
                                                      ofType: @"info"];
    
    NSError * error = nil;
    NSString * setting = [NSString stringWithContentsOfFile:path
                                                   encoding:NSUTF8StringEncoding
                                                      error:&error];
    NSArray * testcases = @[];
    
    if(error){
        NSLog(@"read error");
    }else{
        setting = [setting stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        testcases = [setting componentsSeparatedByString:@","];
    }
    
    NSLog(@"read file:%@",setting);

    _testCtrs = [NSMutableArray<OpCVBaseViewController*> array];
    
    for(int i = 0; i < testcases.count;i++){
        Class vc = NSClassFromString(testcases[i]);
        if(vc){
            id vcinstance = [[vc alloc] init];
            
            if(vcinstance && [vcinstance isKindOfClass:[OpCVBaseViewController class]]){
                [_testCtrs addObject:vcinstance];
            }
        }else{
            NSLog(@"not found class for [%@]",testcases[i]);
        }
    }
  
    UITableView * _tv = [[UITableView alloc] initWithFrame:self.view.bounds
                                                     style:UITableViewStylePlain];
    
    [_tv registerClass:[UITableViewCell class]
forCellReuseIdentifier:@"cell"];
    
    _tv.delegate = self;
    _tv.dataSource = self;
    
    [self.view addSubview:_tv];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  [_testCtrs count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"
                                                             forIndexPath:  indexPath];
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text =[NSString stringWithFormat:@"%ld. %@",indexPath.row+1,[[_testCtrs objectAtIndex:indexPath.row] title]];

    return  cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OpCVBaseViewController * vc = (OpCVBaseViewController*)[_testCtrs objectAtIndex:indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    [self.navigationController pushViewController:vc
                                         animated:YES];
    
}
@end
