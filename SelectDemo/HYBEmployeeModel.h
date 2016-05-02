//
//  HYBEmployeeModel.h
//  SelectDemo
//
//  Created by huangyibiao on 16/5/2.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYBEmployeeModel : NSObject

@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *headPortait;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *workid;

// 辅助字段
// 首字母
@property (nonatomic, copy) NSString *capitalize;
@property (nonatomic, assign) BOOL isSelected;

@end
