//
//  AppDelegate.m
//  PayPalZone
//
//  Created by Tringapps Inc on 5/28/14.
//  Copyright (c) 2014 TringApps. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.pkManager = [PKManager managerWithDelegate:self];
    [self.pkManager start];
    return YES;
}

-(void) applicationDidBecomeActive:(UIApplication *) application
{
    [self.pkManager.locationManager stopMonitoringSignificantLocationChanges];
    for (PKCircle *aCircle in self.pkManager.kit.map.overlays) {
        [self.pkManager.locationManager stopMonitoringForRegion:aCircle.region];
    }
    
    [self.pkManager.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.pkManager start];
}

-(void) applicationDidEnterBackground:(UIApplication *) application
{
    for (PKCircle *aCircle in self.pkManager.kit.map.overlays) {
        [aCircle.region setNotifyOnEntry:YES];
        [aCircle.region setNotifyOnExit:YES];
        [self.pkManager.locationManager startMonitoringForRegion:aCircle.region];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    for (PKCircle *aCircle in self.pkManager.kit.map.overlays) {
        [aCircle.region setNotifyOnEntry:YES];
        [aCircle.region setNotifyOnExit:YES];
        [self.pkManager.locationManager startMonitoringForRegion:aCircle.region];
    }
}

- (void)proximityKit:(PKManager *)manager didEnter:(PKRegion *)region {
    [self checkForGeofenceRegions:manager];
}

- (void)checkForGeofenceRegions:(PKManager *)manager {
    @synchronized (self) {
        CLLocation *deviceLocation = [[manager locationManager] location];
        
        [[manager.kit valueForKeyPath:kMapOverlayKeyPath] enumerateObjectsUsingBlock:^(id iObject, NSUInteger iIndex, BOOL *iStop) {
            PKCircle *aMap = (PKCircle *)iObject;
            
            CGFloat latitude = aMap.latitude;
            CGFloat longtitude = aMap.longitude;
            CGFloat radius = aMap.radius + 3.000000;
            
            CLCircularRegion *aRegion = [[CLCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(latitude, longtitude) radius:radius identifier:aMap.identifier];
            
            if ([aRegion containsCoordinate:CLLocationCoordinate2DMake(deviceLocation.coordinate.latitude, deviceLocation.coordinate.longitude)]) {
                
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                notification.alertBody = kNtfnMsg;
                notification.soundName = UILocalNotificationDefaultSoundName;
                [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
                
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                [userInfo setValue:aMap.name forKeyPath:kBuidlingNumber];
                [userInfo setValue:[NSString stringWithFormat:@"%f", latitude] forKeyPath:kLatitude];
                [userInfo setValue:[NSString stringWithFormat:@"%f", longtitude] forKeyPath:kLongtitude];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kLocationUpdateNtfn object:nil userInfo:userInfo];
                iStop = false;
                return;
            }
        }];
    }
}

- (void)proximityKit:(PKManager *)manager didExit:(PKRegion *)region {
}

- (void) proximityKit:(PKManager *)manager
    didDetermineState:(PKRegionState)state
            forRegion:(PKRegion *)region {
}


- (void)proximityKit:(PKManager *)manager
    didFailWithError:(NSError *)error {
    NSLog(@"Error while monitoring");
}

@end
