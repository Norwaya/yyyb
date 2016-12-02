//
//  OfflineViewController.m
//  Category_demo
//
//  Created by songjian on 13-7-9.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "OfflineViewController.h"
#import "OfflineDetailViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface OfflineViewController()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@end

@implementation OfflineViewController
#pragma mark - Life Cycle
- (void)configLocationManager
{
   
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    //设置定位超时时间
    [self.locationManager setLocationTimeout:6];
    
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:3];
}
- (void)cleanUpAction
{
    //停止定位
    [self.locationManager stopUpdatingLocation];
    
    [self.locationManager setDelegate:nil];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
}

- (void)reGeocodeAction
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    //进行单次带逆地理定位请求
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}

- (void)locAction
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    //进行单次定位请求
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:self.completionBlock];
}

#pragma mark - Initialization

- (void)initCompleteBlock
{
    __weak OfflineViewController *weakSelf = self;
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            //如果为定位失败的error，则不进行annotation的添加
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        //得到定位信息，添加annotation
        if (location)
        {
            
            MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
            [annotation setCoordinate:location.coordinate];
            
            if (regeocode)
            {
                [annotation setTitle:[NSString stringWithFormat:@"%@", regeocode.formattedAddress]];
                [annotation setSubtitle:[NSString stringWithFormat:@"%@-%@-%.2fm", regeocode.citycode, regeocode.adcode, location.horizontalAccuracy]];
            }
            else
            {
                [annotation setTitle:[NSString stringWithFormat:@"lat:%f;lon:%f;", location.coordinate.latitude, location.coordinate.longitude]];
                [annotation setSubtitle:[NSString stringWithFormat:@"accuracy:%.2fm", location.horizontalAccuracy]];
            }
            
            OfflineViewController *strongSelf = weakSelf;
            [strongSelf addAnnotationToMapView:annotation];
        }
    };
}

- (void)addAnnotationToMapView:(id<MAAnnotation>)annotation
{
    [self.mapView addAnnotation:annotation];
    
    [self.mapView selectAnnotation:annotation animated:YES];
    [self.mapView setZoomLevel:15.1 animated:NO];
    [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(returnAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"城市列表"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(detailAction)];

    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    self.mapView.zoomLevel = 11;
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(39.907728, 116.397968);
//    self.mapView.showsUserLocation = true;
    
    [self.view addSubview:self.mapView];
    
    [self initCompleteBlock];
    [self configLocationManager];
    [self reGeocodeAction];
}

#pragma mark - Action Handlers
- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)detailAction
{
    OfflineDetailViewController *detailViewController = [[OfflineDetailViewController alloc] init];
    detailViewController.mapView = self.mapView;
    detailViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    
    [self presentViewController:navi animated:YES completion:nil];
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout   = YES;
        annotationView.animatesDrop     = YES;
        annotationView.draggable        = NO;
        annotationView.pinColor         = MAPinAnnotationColorPurple;
        
        return annotationView;
    }
    
    return nil;
}

@end
