//
//  HYBSelectEmployeeController.h
//  SelectDemo
//
//  Created by huangyibiao on 16/5/2.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBEmployeeModel.h"

// 数组中的元素是HYBEmployeeModel类型
typedef void(^HYBSelectedCallback)(NSArray *selectedModels);

@interface HYBSelectEmployeeController : UIViewController

// models中的元素必须是HYBEmployeeModel类型
- (instancetype)initWithModels:(NSArray *)models onSelected:(HYBSelectedCallback)callback;

@end
