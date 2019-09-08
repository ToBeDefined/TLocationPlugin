//
//  TAddLocationDataViewController.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/4.
//  Copyright © 2019 TBD. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TAddLocationDataViewController.h"
#import "TLocationTableViewCell.h"
#import "TAlertController.h"
#import "UIImage+TLocationPlugin.h"
#import "UIWindow+TLocationPluginToast.h"

typedef void (^GetPlaceInfoBlock)(NSArray<TLocationModel *> *_Nullable models);

typedef NS_ENUM(NSUInteger, TMapViewAnnotationType) {
    TMapViewAnnotationTypeFirst,
    TMapViewAnnotationTypeAll,
};

static NSString * const TAddLocationDataTableViewCellID = @"TAddLocationDataTableViewCellID";

@interface TAddLocationDataViewController () <UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, UITextFieldDelegate>

@property (nonatomic, assign) BOOL shouldRefreshUserLocation;

@property (nonatomic, strong) IBOutlet UIView *searchContent;
@property (nonatomic, strong) IBOutlet UITextField *searchTextField;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSArray<TLocationModel *> *tableViewData;
@property (nonatomic, strong) TLocationModel *selectedModel;

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation TAddLocationDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加位置";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage t_imageNamed:@"user_location"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(backUserLocation:)];
    [self requestLocationAuthorization];
    if (self.mapView.userLocation.location) {
        [self refreshViewWithLocation:self.mapView.userLocation.location
                     setMapViewCenter:YES
                             animated:NO
                       annotationType:TMapViewAnnotationTypeFirst];
    }
    self.shouldRefreshUserLocation = YES;
    UITapGestureRecognizer *mapViewTouch = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(touchMapView:)];
    [self.mapView addGestureRecognizer:mapViewTouch];
    
    self.searchContent.layer.shadowColor = UIColor.blackColor.CGColor;
    self.searchContent.layer.shadowOpacity = 0.5;
    self.searchContent.layer.shadowOffset = CGSizeMake(0, 5);
    self.searchContent.layer.shadowRadius = 10;
}

- (void)requestLocationAuthorization {
    if (![CLLocationManager locationServicesEnabled]) {
        return;
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
        return;
    }
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
}

- (void)touchMapView:(UIGestureRecognizer *)gestureRecognizer {
    if (self.searchTextField.isEditing) {
        [self.searchTextField resignFirstResponder];
        return;
    }
    self.shouldRefreshUserLocation = NO;
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint
                                                      toCoordinateFromView:self.mapView];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude
                                                      longitude:touchMapCoordinate.longitude];
    [self refreshViewWithLocation:location
                 setMapViewCenter:NO
                         animated:YES
                   annotationType:TMapViewAnnotationTypeFirst];
}

- (void)backUserLocation:(UIBarButtonItem *)sender {
    self.shouldRefreshUserLocation = YES;
    [self refreshViewWithLocation:self.mapView.userLocation.location
                 setMapViewCenter:YES
                         animated:NO
                   annotationType:TMapViewAnnotationTypeFirst];
}


- (IBAction)addALocationModelToLocalList:(UIButton *)sender {
    if (self.selectedModel == nil) {
        TAlertController *alert = [TAlertController singleActionAlertWithTitle:@"请选择一个位置"
                                                                       message:nil
                                                                   actionTitle:@"确定"
                                                                   actionBlock:nil];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    TAlertController *alert = [TAlertController editAlertWithTitle:@"请输入标记名称"
                                                           message:nil
                                                        labelTexts:nil
                                                     defaultValues:@[self.selectedModel.name ?: @""]
                                                       cancelTitle:@"取消"
                                                       cancelBlock:nil
                                                      confirmTitle:@"确定"
                                                      confirmBlock:^(TAlertController * _Nonnull alert, UIAlertAction * _Nonnull action) {
        NSString *name = alert.textFields.firstObject.text;
        [self saveSelectedModelWithNewName:name];
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)saveSelectedModelWithNewName:(NSString *)name {
    if (name.length <= 0) {
        TAlertController *alertError = [TAlertController singleActionAlertWithTitle:@"请输入标记名称"
                                                                            message:nil
                                                                        actionTitle:@"确定"
                                                                        actionBlock:nil];
        [self presentViewController:alertError animated:YES completion:nil];
        return;
    }
    
    /// 使用 copy 防止添加多次同一个对象出现问题
    TLocationModel *model = [self.selectedModel copy];
    model.name = name;
    /// 默认不选择
    model.isSelect = NO;
    if (self.addLocationBlock) {
        self.addLocationBlock(model);
        NSString *toastText = [NSString stringWithFormat:@"添加成功: %@\n%@", model.name, model.locationText];
        [UIWindow t_showTostForMessage:toastText];
    }
}

- (void)setMapViewCenter:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated {
    self.mapView.centerCoordinate = coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.0015, 0.0015);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    MKCoordinateRegion fitRegion = [self.mapView regionThatFits:region];
    if (CLLocationCoordinate2DIsValid(fitRegion.center)) {
        [self.mapView setRegion:fitRegion animated:animated];
    } else {
        [self.mapView setRegion:region animated:animated];
    }
}


- (void)updateTableViewForArray:(NSArray<TLocationModel *> *)array {
    /// 刷新清空
    self.selectedModel = nil;
    self.tableViewData = array;
    if (self.tableViewData.count > 0) {
        /// 默认选择第一个
        self.selectedModel = self.tableViewData.firstObject;
        self.selectedModel.isSelect = YES;
    }
    [self.tableView reloadData];
}

- (void)refreshAnnotationsForModelArray:(NSArray<TLocationModel *> *)modelArray {
    [self.mapView removeAnnotations:self.mapView.annotations];
    for (TLocationModel *model in modelArray) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(model.latitude, model.longitude);
        MKPointAnnotation *annoation = [[MKPointAnnotation alloc] init];
        annoation.coordinate = coordinate;
        annoation.title = model.name;
        [self.mapView addAnnotation:annoation];
    }
}

/// 刷新标记
- (void)refreshViewWithLocation:(CLLocation *)location
               setMapViewCenter:(BOOL)setMapViewCenter
                       animated:(BOOL)animated
                 annotationType:(TMapViewAnnotationType)annotationType {
    if (location == nil) {
        self.tableViewData = nil;
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.tableView reloadData];
        return;
    }
    if (setMapViewCenter) {
        [self setMapViewCenter:location.coordinate animated:animated];
    }
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks == nil) {
            self.tableViewData = nil;
            [self.mapView removeAnnotations:self.mapView.annotations];
            [self.tableView reloadData];
            return;
        }
        
        NSMutableArray<TLocationModel *> *locationModelArray = [NSMutableArray<TLocationModel *> array];
        for (CLPlacemark *placemark in placemarks) {
            TLocationModel *model =[TLocationModel modelWithSubLocality:placemark.subLocality
                                                                   name:placemark.name
                                                               latitude:placemark.location.coordinate.latitude
                                                              longitude:placemark.location.coordinate.longitude];
            [locationModelArray addObject:model];
        }
        
        if (annotationType == TMapViewAnnotationTypeFirst && locationModelArray.count >= 1) {
            [self refreshAnnotationsForModelArray:@[locationModelArray.firstObject]];
        } else {
            [self refreshAnnotationsForModelArray:locationModelArray];
        }
        [self updateTableViewForArray:locationModelArray];
    }];
}

- (IBAction)searchMap:(UIButton *)sender {
    [self.view endEditing:YES];
    [self searchMapForText:self.searchTextField.text];
}

/// 输入文字结束搜索, 其他情况不搜索
- (void)searchMapForText:(NSString *)text {
    if (text.length <= 0) {
        // 恢复用户当前位置
        self.shouldRefreshUserLocation = YES;
        [self refreshViewWithLocation:self.mapView.userLocation.location
                     setMapViewCenter:YES
                             animated:YES
                       annotationType:TMapViewAnnotationTypeFirst];
        return;
    }
    // 搜索则拦截用户位置更新, 不进行显示
    self.shouldRefreshUserLocation = NO;
    MKLocalSearchRequest *searchRequest = [[MKLocalSearchRequest alloc] init];
    [searchRequest setNaturalLanguageQuery:text];
    [searchRequest setRegion:self.mapView.region];
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:searchRequest];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        // [self.mapView setRegion:response.boundingRegion];
        NSMutableArray<TLocationModel *> *locationModelArray = [NSMutableArray<TLocationModel *> array];
        for (MKMapItem *item in response.mapItems) {
            TLocationModel *model =[TLocationModel modelWithSubLocality:item.placemark.subLocality
                                                                   name:item.placemark.name
                                                               latitude:item.placemark.location.coordinate.latitude
                                                              longitude:item.placemark.location.coordinate.longitude];
            [locationModelArray addObject:model];
        }
        
        [self setMapViewCenter:response.mapItems.firstObject.placemark.location.coordinate
                      animated:YES];
        [self refreshAnnotationsForModelArray:locationModelArray];
        [self updateTableViewForArray:locationModelArray];
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TAddLocationDataTableViewCellID];
    if (cell == nil) {
        cell = [[TLocationTableViewCell alloc] initWithReuseIdentifier:TAddLocationDataTableViewCellID];
        cell.tableView = tableView;
    }
    cell.model = self.tableViewData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    self.shouldRefreshUserLocation = NO;
    
    NSMutableArray<NSIndexPath *> *reloadIndexPaths = [NSMutableArray<NSIndexPath *> array];
    [reloadIndexPaths addObject:indexPath];
    
    NSUInteger oldIndex = [self.tableViewData indexOfObject:self.selectedModel];
    if (oldIndex != NSNotFound) {
        NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:oldIndex inSection:0];
        [reloadIndexPaths addObject:oldIndexPath];
    }
    self.selectedModel.isSelect = NO;
    self.selectedModel = self.tableViewData[indexPath.row];
    self.selectedModel.isSelect = YES;
    [self.tableView reloadRowsAtIndexPaths:reloadIndexPaths
                          withRowAnimation:UITableViewRowAnimationNone];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.selectedModel.latitude
                                                      longitude:self.selectedModel.longitude];
    [self setMapViewCenter:location.coordinate animated:NO];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self searchMapForText:textField.text];
    return YES;
}


#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(nonnull MKUserLocation *)userLocation {
    if (self.shouldRefreshUserLocation) {
        [self refreshViewWithLocation:userLocation.location
                     setMapViewCenter:YES
                             animated:YES
                       annotationType:TMapViewAnnotationTypeFirst];
    }
}

//- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
//}


@end
