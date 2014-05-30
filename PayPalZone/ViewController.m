//
//  ViewController.m
//  PayPalZone
//
//  Created by Tringapps Inc on 5/28/14.
//  Copyright (c) 2014 TringApps. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView:) name:kLocationUpdateNtfn object:nil];
}

- (void)refreshView:(NSNotification *)iNotification {
    self.label.text = [NSString stringWithFormat:@"%@ %@", kNtfnWelcomeMsg, [iNotification.userInfo valueForKey:kBuidlingNumber]];
    
    CLLocationCoordinate2D buildingCoodinates;
    
    buildingCoodinates.latitude = [[iNotification.userInfo valueForKey:kLatitude] doubleValue];
    buildingCoodinates.longitude = [[iNotification.userInfo valueForKey:kLongtitude] doubleValue];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(buildingCoodinates, 500, 500);
    [self.mapView setRegion:viewRegion animated:YES];
}

- (IBAction)changeMapViewType:(id)sender {
    if (self.mapView.mapType == MKMapTypeStandard)
        self.mapView.mapType = MKMapTypeSatellite;
    else
        self.mapView.mapType = MKMapTypeStandard;
}

@end
