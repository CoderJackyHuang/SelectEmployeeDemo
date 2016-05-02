//
//  ViewController.m
//  SelectDemo
//
//  Created by huangyibiao on 16/5/2.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "ViewController.h"
#import "HYBSelectEmployeeController.h"
#import "HYBEmployeeModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  

  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(onSelect)];
}

- (void)onSelect {
  HYBEmployeeModel *model1 = [[HYBEmployeeModel alloc] init];
  model1.workid = @"1";
  HYBEmployeeModel *model2 = [[HYBEmployeeModel alloc] init];
  model2.workid = @"2";
   NSArray *models = @[model1, model2];
HYBSelectEmployeeController *vc = [[HYBSelectEmployeeController alloc] initWithModels:models onSelected:^(NSArray *selectedModels) {
  
}];
  [self.navigationController pushViewController:vc animated:YES];
}

@end
