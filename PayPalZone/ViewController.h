//
//  ViewController.h
//  PayPalZone
//
//  Created by Tringapps Inc on 5/28/14.
//  Copyright (c) 2014 TringApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)changeMapViewType:(id)sender;

@end
