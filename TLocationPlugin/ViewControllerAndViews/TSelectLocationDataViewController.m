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
    self.tableViewData = TLocationCache.shared.cacheDataArray;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)cleanCacheData:(UIBarButtonItem *)barButtonItem {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"确定清空已保存数据?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction * _Nonnull action) {
        self.tableViewData = nil;
        TLocationCache.shared.cacheDataArray = nil;
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
        TLocationCache.shared.cacheDataArray = newDataArray;
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


@end
