//
//  HYBSelectEmployeeController.m
//  SelectDemo
//
//  Created by huangyibiao on 16/5/2.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "HYBSelectEmployeeController.h"
#import "HYBEmployeeCell.h"
#import "HYBEmployeeModel.h"

@interface HYBSelectEmployeeController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *hasSelectLabel;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UIButton *allSelectButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasources;
@property (nonatomic, strong) NSMutableArray *capitalSources;

@property (nonatomic, copy) HYBSelectedCallback callback;
@property (nonatomic, strong) NSArray *defaultModels;

@end

@implementation HYBSelectEmployeeController

- (instancetype)initWithModels:(NSArray *)models onSelected:(HYBSelectedCallback)callback {
  if (self = [super init]) {
    self.defaultModels = models;
    self.callback = callback;
  }
  
  return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
  self.edgesForExtendedLayout = UIRectEdgeNone;
  self.title = @"选择工人";
  [self configUI];
  
  [self testData];
}

- (void)testData {
  // 假设下面是服务器返回来的数据数组
  NSMutableArray *requestDataModels = [[NSMutableArray alloc] init];
  for (NSUInteger i = 0; i <= 25; ++i) {
    HYBEmployeeModel *model = [[HYBEmployeeModel alloc] init];
    model.username = [NSString stringWithFormat:@"张朋鹏%c", (unichar)('A' + i)];
    model.type = @(i % 3);
    model.workid = [NSString stringWithFormat:@"%ld", i + 1];
    model.headPortait = @"头像";
    
    // 在接口请求回来数据后，若传有默认值，使之默认选中
    if (self.defaultModels.count) {
      [self.defaultModels enumerateObjectsUsingBlock:^(HYBEmployeeModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.workid isEqualToString:model.workid]) {
          model.isSelected = YES;
        }
      }];
      self.hasSelectLabel.text = [NSString stringWithFormat:@"已选择 %ld 人", self.defaultModels.count];
    } else {
      self.hasSelectLabel.text = [NSString stringWithFormat:@"已选择 0 人"];
    }
    
    [requestDataModels addObject:model];
  }
    self.totalLabel.text = [NSString stringWithFormat:@"(%ld 人)", requestDataModels.count];
  
  // 分组
  for (NSUInteger i = 'A'; i <= 'Z'; ++i) {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self.datasources addObject:array];
  }
  
  [requestDataModels enumerateObjectsUsingBlock:^(HYBEmployeeModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
    NSString *captialized = model.capitalize;
    NSUInteger index = [captialized characterAtIndex:0] - 'A';
    NSMutableArray *array = [self.datasources objectAtIndex:index];
    [array addObject:model];
  }];
  
  [self.tableView reloadData];
}

- (NSMutableArray *)capitalSources {
  if (_capitalSources == nil) {
    _capitalSources = [[NSMutableArray alloc] init];
    for (unichar i = 'A'; i <= 'Z'; ++i) {
      NSString *str = [NSString stringWithFormat:@"%c", i];
      [_capitalSources addObject:str];
    }
  }
  
  return _capitalSources;
}

- (void)configUI {
  UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
  [self.view addSubview:topView];
  topView.backgroundColor = [UIColor lightGrayColor];
  self.hasSelectLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, topView.frame.size.height)];
  [topView addSubview:self.hasSelectLabel];
  
  self.totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100, 0, 95, topView.frame.size.height)];
  [topView addSubview:self.totalLabel];
  self.totalLabel.textAlignment = NSTextAlignmentRight;
  
  CGFloat h = [UIScreen mainScreen].bounds.size.height;
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, h - 64 - 40 - 40) style:UITableViewStylePlain];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.tableView registerClass:[HYBEmployeeCell class]
         forCellReuseIdentifier:@"HYBEmployeeCell"];
  [self.view addSubview:self.tableView];
  
  UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, h - 64 - 40, self.view.frame.size.width, 40)];
  [self.view addSubview:bottomView];
  bottomView.backgroundColor = [UIColor whiteColor];
  self.allSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
  self.allSelectButton.frame = CGRectMake(10, (40 - 17) / 2, 17, 17);
  [self.allSelectButton setImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
  [self.allSelectButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
  [bottomView addSubview:self.allSelectButton];
  
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.allSelectButton.frame.origin.x + self.allSelectButton.frame.size.width + 10, 0, 100, 40)];
  label.text = @"全选";
  label.textAlignment = NSTextAlignmentLeft;
  [bottomView addSubview:label];
  
  // 放大点击范围
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [bottomView addSubview:button];
  button.frame = CGRectMake(0, 0, 80, 40);
  [button addTarget:self
             action:@selector(onSelectAll)
   forControlEvents:UIControlEventTouchUpInside];
  
  self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
  self.confirmButton.frame = CGRectMake(self.view.frame.size.width - 80, 0, 80, 40);
  [bottomView addSubview:self.confirmButton];
  self.confirmButton.backgroundColor = [UIColor redColor];
  [self.confirmButton setTitle:@"确定添加" forState:UIControlStateNormal];
  [self.confirmButton addTarget:self
                         action:@selector(onConfirmButtonClicked)
               forControlEvents:UIControlEventTouchUpInside];
}

- (NSMutableArray *)datasources {
  if (_datasources == nil) {
    _datasources = [[NSMutableArray alloc] init];
  }
  
  return _datasources;
}

#pragma mark - 确定
- (void)onConfirmButtonClicked {
  NSMutableArray *selectedModels = [[NSMutableArray alloc] init];
  [self.datasources enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger idx, BOOL * _Nonnull stop) {
    [array enumerateObjectsUsingBlock:^(HYBEmployeeModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
      if (model.isSelected) {
        [selectedModels addObject:model];
      }
    }];
  }];

  if (selectedModels.count <= 0) {
    NSLog(@"请选择");
  } else {
    if (self.callback) {
      self.callback(selectedModels);
    }
  }
}

#pragma mark - 点击全选或者取消全选
- (void)onSelectAll {
  self.allSelectButton.selected = !self.allSelectButton.isSelected;
  
  [self.datasources enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger idx, BOOL * _Nonnull stop) {
    [array enumerateObjectsUsingBlock:^(HYBEmployeeModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
      model.isSelected = self.allSelectButton.isSelected;
    }];
  }];
  [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.datasources.count;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  return self.capitalSources;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSArray *array = self.datasources[section];
  return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  HYBEmployeeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HYBEmployeeCell"
                                                          forIndexPath:indexPath];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  NSArray *array = self.datasources[indexPath.section];
  HYBEmployeeModel *model = array[indexPath.row];
  cell.model = model;
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *array = self.datasources[indexPath.section];
  HYBEmployeeModel *model = array[indexPath.row];
  model.isSelected = !model.isSelected;
  
  [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
  
  [self allSelectOrNo];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 90;
}

- (void)allSelectOrNo {
  __block NSUInteger count = 0;
  __block NSUInteger totalCount = 0;
  [self.datasources enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger idx, BOOL * _Nonnull stop) {
    [array enumerateObjectsUsingBlock:^(HYBEmployeeModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
      if (model.isSelected) {
        count++;
      }
      totalCount++;
    }];
  }];

  self.allSelectButton.selected = totalCount == count;
}

@end
