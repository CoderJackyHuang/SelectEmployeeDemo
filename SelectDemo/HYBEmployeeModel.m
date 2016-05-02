//
//  HYBEmployeeModel.m
//  SelectDemo
//
//  Created by huangyibiao on 16/5/2.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "HYBEmployeeModel.h"
#import "PinYin4Objc.h"
#import "HanyuPinyinOutputFormat.h"

@implementation HYBEmployeeModel

- (NSString *)capitalize {
  if (_capitalize == nil && self.username.length) {
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
    
    NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:self.username withHanyuPinyinOutputFormat:outputFormat withNSString:@" "];
    if (outputPinyin) {
      _capitalize = [[outputPinyin substringToIndex:1] uppercaseString];
    } else {
      _capitalize = @"";
    }
  }
  
  return _capitalize;
}

@end
