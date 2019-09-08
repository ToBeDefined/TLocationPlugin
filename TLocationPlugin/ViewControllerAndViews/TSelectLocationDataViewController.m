//
//  TSelectLocationDataViewController.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/4.
//  Copyright © 2019 TBD. All rights reserved.
//

#import "TSelectLocationDataViewController.h"
#import "TLocationNavigationController.h"
#import "TAddLocationDataViewController.h"
#import "TLocationSettingViewController.h"
#import "TLocationTableViewCell.h"
#import "TLocationManager.h"
#import "TAlertController.h"
#import "UIImage+TLocationPlugin.h"
#import "UITableView+TLocationPlugin.h"
#import "UIWindow+TLocationPluginToast.h"

static NSString * const TSelectLocationDataTableViewCellID = @"TSelectLocationDataTableViewCellID";

@interface TSelectLocationDataViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView      *tableView;
@property (nonatomic, assign) BOOL                      hasChangedLocationData;

@property (nonatomic, copy) NSArray<TLocationModel *>   *tableViewData;
@property (nonatomic, assign) NSUInteger                lastSavedCacheDataArrayHash;
@property (nonatomic, readonly, nullable) NSIndexPath   *currentSelectIndex;
@property (nonatomic, strong) TLocationModel            *selectedModel;

@property (nonatomic, copy) NSArray<UIBarButtonItem *>  *leftBarButtonItems;
@property (nonatomic, copy) NSArray<UIBarButtonItem *>  *rightBarButtonItems;

@end

@implementation TSelectLocationDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择位置";
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithImage:[UIImage t_imageNamed:@"close"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(closeSetLocationViewController)];
    
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithImage:[UIImage t_imageNamed:@"setting"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(openLocationSettingViewController)];
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(editTableView)];
    self.leftBarButtonItems = @[closeItem];
    self.rightBarButtonItems = @[settingItem, sortItem];
    self.navigationItem.leftBarButtonItems = self.leftBarButtonItems;
    self.navigationItem.rightBarButtonItems = self.rightBarButtonItems;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.lastSavedCacheDataArrayHash = TLocationManager.shared.cacheDataArrayHash;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshTableView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self storageCacheDataArray];
}

- (NSArray<TLocationModel *> *)tableViewData {
    return TLocationManager.shared.cacheDataArray;
}

- (void)setTableViewData:(NSArray<TLocationModel *> *)tableViewData {
    TLocationManager.shared.cacheDataArray = tableViewData;
}

- (NSIndexPath *)currentSelectIndex {
    __block NSIndexPath *index = nil;
    [self.tableViewData enumerateObjectsUsingBlock:^(TLocationModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelect) {
            index = [NSIndexPath indexPathForRow:idx inSection:0];
            *stop = YES;
        }
    }];
    return index;
}

- (void)refreshTableView {
    [self.tableView reloadData];
    if (self.currentSelectIndex) {
        [self.tableView selectRowAtIndexPath:self.currentSelectIndex
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)closeSetLocationViewController {
    [self.view endEditing:YES];
    [self storageCacheDataArray];
    
    /// 修改了数据但是没有启用
    if (self.hasChangedLocationData && !TLocationManager.shared.usingHookLocation) {
        TAlertController *alert = [TAlertController confirmAlertWithTitle:@"是否启用位置拦截?" message:nil cancelTitle:@"否" cancelBlock:^(TAlertController * _Nonnull alert, UIAlertAction * _Nonnull action) {
            [self dismissSelf];
        } confirmTitle:@"是" confirmBlock:^(TAlertController * _Nonnull alert, UIAlertAction * _Nonnull action) {
            TLocationManager.shared.usingHookLocation = YES;
            [self dismissSelf];
        }];
        [alert reverseActions];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }

    [self dismissSelf];
}

- (void)editTableView {
    if (self.tableView.isEditing || self.tableView.isBeginingEdit) {
        return;
    }
    [self.tableView setEditing:YES animated:YES];
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"删除"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(removeTableViewCell)];
    self.navigationItem.leftBarButtonItems = @[deleteItem];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(doneEditTableView)];
    self.navigationItem.rightBarButtonItems = @[doneItem];
}

- (void)removeTableViewCell {
    if (self.tableView.indexPathsForSelectedRows.count == 0) {
        return;
    }
    NSMutableArray<TLocationModel *> *tableViewDataArray = [self.tableViewData mutableCopy];
    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    [self.tableView.indexPathsForSelectedRows enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [indexSet addIndex:obj.row];
    }];
    [tableViewDataArray removeObjectsAtIndexes:indexSet];
    self.tableViewData = tableViewDataArray;
    [self storageCacheDataArray];
    [self.tableView deleteRowsAtIndexPaths:self.tableView.indexPathsForSelectedRows
                          withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)doneEditTableView {
    if (!self.tableView.isEditing || self.tableView.isEndingEdit) {
        return;
    }
    [self.tableView setEditing:NO animated:YES];
    self.navigationItem.leftBarButtonItems = self.leftBarButtonItems;
    self.navigationItem.rightBarButtonItems = self.rightBarButtonItems;
}

- (void)openLocationSettingViewController {
    [self doneEditTableView];
    TLocationSettingViewController *vc = [[TLocationSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)storageCacheDataArray {
    if (self.lastSavedCacheDataArrayHash == TLocationManager.shared.cacheDataArrayHash) {
        return;
    }
    [TLocationManager.shared saveCacheDataArray];
    self.lastSavedCacheDataArrayHash = TLocationManager.shared.cacheDataArrayHash;
}

- (void)storageLocation:(TLocationModel * _Nonnull)model {
    if (model == nil) {
        return;
    }
    self.hasChangedLocationData = YES;
    TLocationManager.shared.locationName = model.name;
    TLocationManager.shared.latitude = model.latitude;
    TLocationManager.shared.longitude = model.longitude;
}

- (void)dismissSelf {
    [self dismissViewControllerAnimated:YES completion:^{
        TLocationNavigationController.isShowing = NO;
    }];
}

- (IBAction)addLocationData:(UIButton *)sender {
    [self doneEditTableView];
    TAddLocationDataViewController *vc = [[TAddLocationDataViewController alloc] init];
    vc.addLocationBlock = ^(TLocationModel * _Nonnull model) {
        NSMutableArray<TLocationModel *> *newDataArray = [self.tableViewData mutableCopy];
        if (newDataArray == nil) {
            newDataArray = [NSMutableArray<TLocationModel *> array];
        }
        [newDataArray insertObject:model atIndex:0];
        self.tableViewData = newDataArray;
        [self storageCacheDataArray];
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
    TLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TSelectLocationDataTableViewCellID];
    if (cell == nil) {
        cell = [[TLocationTableViewCell alloc] initWithReuseIdentifier:TSelectLocationDataTableViewCellID];
        cell.tableView = tableView;
    }
    cell.model = self.tableViewData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing) {
        return;
    }
    
    NSIndexPath *oldIndex = self.currentSelectIndex;
    if (oldIndex) {
        self.tableViewData[oldIndex.row].isSelect = NO;
        [tableView reloadRowsAtIndexPaths:@[oldIndex] withRowAnimation:UITableViewRowAnimationNone];
    }
    TLocationModel *model = self.tableViewData[indexPath.row];
    model.isSelect = YES;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self storageLocation:model];
    [self storageCacheDataArray];
    NSString *toastText = [NSString stringWithFormat:@"已保存为: %@\n%@", model.name, model.locationText];
    [UIWindow t_showTostForMessage:toastText];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath.row == destinationIndexPath.row) {
        return;
    }
    NSMutableArray<TLocationModel *> *tableViewDataArray = [self.tableViewData mutableCopy];
    TLocationModel *model = [tableViewDataArray objectAtIndex:sourceIndexPath.row];
    [tableViewDataArray removeObjectAtIndex:sourceIndexPath.row];
    [tableViewDataArray insertObject:model atIndex:destinationIndexPath.row];
    self.tableViewData = tableViewDataArray;
    [self storageCacheDataArray];
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
        [self topTableViewDataInIndexPath:indexPath];
    }];

    deleleteBtn.backgroundColor = UIColor.redColor;
    editBtn.backgroundColor = UIColor.grayColor;
    topBtn.backgroundColor = UIColor.blackColor;
    return @[deleleteBtn, editBtn, topBtn];
}


#pragma mark - 辅助函数
- (void)topTableViewDataInIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
    [self.tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];

    NSMutableArray<TLocationModel *> *tableViewDataArray = [self.tableViewData mutableCopy];
    TLocationModel *model = [tableViewDataArray objectAtIndex:indexPath.row];
    [tableViewDataArray removeObjectAtIndex:indexPath.row];
    [tableViewDataArray insertObject:model atIndex:0];
    self.tableViewData = tableViewDataArray;
    [self storageCacheDataArray];
}

- (void)removeTableViewDataInIndexPath:(NSIndexPath *)indexPath {
    TLocationModel *model = self.tableViewData[indexPath.row];
    TAlertController *alert = [TAlertController destructiveAlertWithTitle:@"确定删除数据?"
                                                                  message:model.name
                                                              cancelTitle:@"取消"
                                                              cancelBlock:nil
                                                         destructiveTitle:@"确定"
                                                         destructiveBlock:^(TAlertController * _Nonnull alert, UIAlertAction * _Nonnull action) {
        NSMutableArray<TLocationModel *> *tableViewDataArray = [self.tableViewData mutableCopy];
        [tableViewDataArray removeObjectAtIndex:indexPath.row];
        self.tableViewData = tableViewDataArray;
        [self storageCacheDataArray];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationLeft];
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)editTableViewDataInIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == nil) {
        return;
    }
    TLocationModel *model = self.tableViewData[indexPath.row];
    TAlertController *alert = [TAlertController editAlertWithTitle:@"修改数据"
                                                           message:model.name
                                                        labelTexts:@[@"名称", @"纬度", @"经度"]
                                                     defaultValues:@[
                                                         model.name ?: @"",
                                                         @(model.latitude).stringValue,
                                                         @(model.longitude).stringValue,
                                                     ]
                                                       cancelTitle:@"取消"
                                                       cancelBlock:nil
                                                      confirmTitle:@"确定"
                                                      confirmBlock:^(TAlertController * _Nonnull alert, UIAlertAction * _Nonnull action) {
        model.name = alert.textFields[0].text;
        model.latitude = alert.textFields[1].text.doubleValue;
        model.longitude = alert.textFields[2].text.doubleValue;
        if (model.isSelect) {
            [self storageLocation:model];
        }
        [self storageCacheDataArray];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
