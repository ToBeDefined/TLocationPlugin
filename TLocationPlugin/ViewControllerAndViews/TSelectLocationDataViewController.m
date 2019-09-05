//
//  TSelectLocationDataViewController.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/4.
//  Copyright © 2019 TBD. All rights reserved.
//

#import "TSelectLocationDataViewController.h"
#import "TAddLocationDataViewController.h"
#import "TLocationCache.h"
#import "UIImage+TLocation.h"

static NSString * const TSelectLocationDataTableViewCellID = @"TSelectLocationDataTableViewCellID";

@interface TSelectLocationDataViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray<TLocationModel *> *tableViewData;

@end

@implementation TSelectLocationDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"缓存数据";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                                           target:self
                                                                                           action:@selector(cleanCacheData:)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSArray<TLocationModel *> *)tableViewData {
    return TLocationCache.shared.cacheDataArray;
}

- (void)setTableViewData:(NSArray<TLocationModel *> *)tableViewData {
    TLocationCache.shared.cacheDataArray = tableViewData;
}

- (void)cleanCacheData:(UIBarButtonItem *)barButtonItem {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"确定清空已保存数据?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction * _Nonnull action) {
        self.tableViewData = nil;
        [self.tableView reloadData];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)addLocationData:(UIButton *)sender {
    TAddLocationDataViewController *vc = [[TAddLocationDataViewController alloc] init];
    vc.addLocationBlock = ^(TLocationModel * _Nonnull model) {
        NSMutableArray<TLocationModel *> *newDataArray = [self.tableViewData mutableCopy];
        if (newDataArray == nil) {
            newDataArray = [NSMutableArray<TLocationModel *> array];
        }
        [newDataArray insertObject:model atIndex:0];
        self.tableViewData = newDataArray;
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TSelectLocationDataTableViewCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:TSelectLocationDataTableViewCellID];
    }
    static UIImage *locationImage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationImage = [UIImage t_imageNamed:@"location"];
    });
    TLocationModel *model = self.tableViewData[indexPath.row];
    cell.textLabel.text = model.name;
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.text = model.locationText;
    cell.detailTextLabel.numberOfLines = 0;
    cell.imageView.image = locationImage;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController popViewControllerAnimated:YES];
    if (self.selectLocationBlock) {
        self.selectLocationBlock(self.tableViewData[indexPath.row]);
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleleteBtn = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                                           title:@"删除"
                                                                         handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self removeTableViewDataInIndexPath:indexPath];
    }];
    
    UITableViewRowAction *editBtn = [UITableViewRowAction  rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                        title:@"编辑"
                                                                      handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self editTableViewDataInIndexPath:indexPath];
    }];
    
    UITableViewRowAction *topBtn = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                      title:@"置顶"
                                                                    handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        [tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
        
        NSMutableArray<TLocationModel *> *tableViewDataArray = [self.tableViewData mutableCopy];
        TLocationModel *model = [tableViewDataArray objectAtIndex:indexPath.row];
        [tableViewDataArray removeObjectAtIndex:indexPath.row];
        [tableViewDataArray insertObject:model atIndex:0];
        self.tableViewData = tableViewDataArray;
    }];
    
    deleleteBtn.backgroundColor = UIColor.redColor;
    editBtn.backgroundColor = UIColor.grayColor;
    topBtn.backgroundColor = UIColor.blackColor;
    return @[deleleteBtn, editBtn, topBtn];
}

- (void)removeTableViewDataInIndexPath:(NSIndexPath *)indexPath {
    TLocationModel *model = self.tableViewData[indexPath.row];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定删除数据?"
                                                                   message:model.name
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        
        NSMutableArray<TLocationModel *> *tableViewDataArray = [self.tableViewData mutableCopy];
        [tableViewDataArray removeObjectAtIndex:indexPath.row];
        self.tableViewData = tableViewDataArray;
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)editTableViewDataInIndexPath:(NSIndexPath *)indexPath {
    TLocationModel *model = self.tableViewData[indexPath.row];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改数据"
                                                                   message:model.name
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [self addLabel:@"标记: " toTextField:textField];
        textField.text = model.name;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [self addLabel:@"纬度: " toTextField:textField];
        textField.text = @(model.latitude).stringValue;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [self addLabel:@"经度: " toTextField:textField];
        textField.text = @(model.longitude).stringValue;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        model.name = alert.textFields[0].text;
        model.latitude = alert.textFields[1].text.doubleValue;
        model.longitude = alert.textFields[2].text.doubleValue;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        /// 为了重新保存缓存数据
        self.tableViewData = self.tableViewData;
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)addLabel:(NSString *)text toTextField:(UITextField *)textField {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:14];
    textField.leftView = label;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

@end
