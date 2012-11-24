//
//  DVFoursquareNearbyViewController.h
//  FoursquareNearby
//
//  Created by Ilya Puchka on 23.11.12.
//  Copyright (c) 2012 Denivip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVFoursquareClient.h"
#import <CoreLocation/CoreLocation.h>

#define CLLocationToCGPoint(location) CGPointMake(location.coordinate.latitude, location.coordinate.longitude)

@class DVFoursquareNearbyViewController;

@protocol DVFoursquareNearbyViewControllerDelegate <NSObject>

@optional
- (void)controller:(DVFoursquareNearbyViewController *)controller didSelectVenue:(NSDictionary *)venue;
- (void)controller:(DVFoursquareNearbyViewController *)controller didSelectCategory:(NSDictionary *)category;

@end

@interface DVFoursquareNearbyViewController : UITableViewController

@property (nonatomic, weak) id<DVFoursquareNearbyViewControllerDelegate> delegate;
@property (nonatomic, strong, readonly) DVFoursquareClient *foursquareClient;

@property (nonatomic, strong) UIBarButtonItem *activityBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *refreshBarButtonItem;

@property (nonatomic, copy) NSString *initialSearchQuery;
@property (nonatomic) BOOL searchEnabled;
@property (nonatomic) BOOL refreshEnabled;
@property (nonatomic) CGFloat searchRadius;

@property (nonatomic, strong, readonly) NSArray *items;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong, readonly) CLLocation *currentLocation;

@end
