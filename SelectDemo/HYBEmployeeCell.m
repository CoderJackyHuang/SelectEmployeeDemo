//
//  HYBEmployeeCell.m
//  SelectDemo
//
//  Created by huangyibiao on 16/5/2.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "HYBEmployeeCell.h"

@interface HYBEmployeeCell ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UIImageView *typImageView;
@property (nonatomic, strong) UILabel  *nameLabel;
@property (nonatomic, strong) UIView   *lineView;

@end

@implementation HYBEmployeeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
    [self.button setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    self.button.frame = CGRectMake(10, (90 - 17) / 2, 17, 17);
    self.button.userInteractionEnabled = NO;
    [self.contentView addSubview:self.button];
    
    self.headView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 10, 80, 70)];
    self.headView.image = [UIImage imageNamed:@"头像"];
    [self.contentView addSubview:self.headView];
    self.typImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80 - 22, 149 / 2.0, 22)];
    [self.headView addSubview:self.typImageView];
    
    CGFloat x = self.headView.frame.origin.x + self.headView.frame.size.width + 20;
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, width - x - 10, 90)];
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(self.headView.frame.origin.x, 89.5, width - self.headView.frame.origin.x, 0.5)];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.lineView];
  }
  
  return self;
}

- (void)setModel:(HYBEmployeeModel *)model {
  if (_model != model) {
    _model = model;
  }
  
  if (model) {
    self.button.selected = model.isSelected;
    self.nameLabel.text = model.username;
    if (model.type.integerValue == 0) {
      self.typImageView.image = [UIImage imageNamed:@"工人"];
    } else if (model.type.integerValue == 1) {// 组长
      self.typImageView.image = [UIImage imageNamed:@"工人"];
    } else if (model.type.integerValue == 2) { // 老板
      self.typImageView.image = [UIImage imageNamed:@"老板"];
    }
  }
}

@end
