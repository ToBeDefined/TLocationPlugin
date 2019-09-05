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
#import "TAddLocationTableViewCell.h"
#import "UIImage+TLocationPlugin.h"

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
    self.title = @"添加位置数据";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage t_imageNamed:@"my_location"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(backUserLocation:)];
    [self requestLocationAuthorization];
    self.shouldRefreshUserLocation = YES;
    self.searchContent.layer.shadowColor = UIColor.blackColor.CGColor;
    self.searchContent.layer.shadowOpacity = 0.5;
    self.searchContent.layer.shadowOffset = CGSizeMake(0, 5);
    self.searchContent.layer.shadowRadius = 10;
    UITapGestureRecognizer *mapViewTouch = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(touchMapView:)];
    [self.mapView addGestureRecognizer:mapViewTouch];
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

- (void)touchMapView:(UIGestureRecognizer*)gestureRecognizer {
    if (self.searchTextField.isFirstResponder) {
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
                   annotationType:TMapViewAnnotationTypeFirst];
}

- (void)backUserLocation:(UIBarButtonItem *)sender {
    self.shouldRefreshUserLocation = YES;
    [self refreshViewWithLocation:self.mapView.userLocation.location
                 setMapViewCenter:YES
                   annotationType:TMapViewAnnotationTypeFirst];
}


- (IBAction)addALocationModelToLocalList:(UIButton *)sender {
    if (self.selectedModel == nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:@"请选择一个位置"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"输入标签" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入标记名称";
        textField.text = self.selectedModel.name;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *name = alert.textFields.firstObject.text;
        if (name.length <= 0) {
            UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:nil
                                                                            message:@"请输入标记名称"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
            [alert2 addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert2 animated:YES completion:nil];
            return;
        }
        self.selectedModel.name = name;
        if (self.addLocationBlock) {
            self.addLocationBlock(self.selectedModel);
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setMapViewCenter:(CLLocationCoordinate2D)coordinate {
    self.mapView.centerCoordinate = coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.003, 0.003);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    MKCoordinateRegion fitRegion = [self.mapView regionThatFits:region];
    if (CLLocationCoordinate2DIsValid(fitRegion.center)) {
        [self.mapView setRegion:fitRegion animated:YES];
    } else {
        [self.mapView setRegion:region animated:YES];
    }
}


- (void)updateTableViewForArray:(NSArray<TLocationModel *> *)array {
    /// 刷新清空
    self.selectedModel = nil;
    self.tableViewData = array;
    [self.tableView reloadData];
    /// 默认选择第一个
    if (self.tableViewData.count > 0) {
        self.selectedModel = self.tableViewData.firstObject;
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionTop];
    }
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
                 annotationType:(TMapViewAnnotationType)annotationType {
    if (location == nil) {
        self.tableViewData = nil;
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.tableView reloadData];
        return;
    }
    if (setMapViewCenter) {
        [self setMapViewCenter:location.coordinate];
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
    [self.searchTextField resignFirstResponder];
    [self searchMapForText:self.searchTextField.text];
}

/// 输入文字结束搜索, 其他情况不搜索
- (void)searchMapForText:(NSString *)text {
    if (text.length <= 0) {
        // 恢复用户当前位置
        self.shouldRefreshUserLocation = YES;
        [self refreshViewWithLocation:self.mapView.userLocation.location
                     setMapViewCenter:YES
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
        
        [self setMapViewCenter:response.mapItems.firstObject.placemark.location.coordinate];
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
    self.shouldRefreshUserLocation = NO;
    [self.searchTextField resignFirstResponder];
    TAddLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TAddLocationDataTableViewCellID];
    if (cell == nil) {
        cell = [[TAddLocationTableViewCell alloc] initWithReuseIdentifier:TAddLocationDataTableViewCellID];
    }
    TLocationModel *model = self.tableViewData[indexPath.row];
    cell.textLabel.text = model.name;
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.text = model.locationText;
    cell.detailTextLabel.numberOfLines = 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedModel = self.tableViewData[indexPath.row];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.selectedModel.latitude
                                                      longitude:self.selectedModel.longitude];
    [self setMapViewCenter:location.coordinate];
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self searchMapForText:textField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(nonnull MKUserLocation *)userLocation {
    if (self.shouldRefreshUserLocation) {
        [self refreshViewWithLocation:userLocation.location
                     setMapViewCenter:YES
                       annotationType:TMapViewAnnotationTypeFirst];
    }
}

//- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
//}


#pragma mark - Touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
