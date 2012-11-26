//
//  DVFoursquareNearbyViewController.h
//  FoursquareNearby
//
//  Created by Ilya Puchka on 23.11.12.
//  Copyright (c) 2012 Denivip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DVFoursquareClient.h"
#import "DVFoursquareCreatePlaceViewControllerDelegate.h"
#import "DVFoursquareNearbyViewControllerDelegate.h"

#define CLLocationToCGPoint(location) CGPointMake(location.coordinate.latitude, location.coordinate.longitude)

/** View controller that provide user interface for searching, selecting and creating foursquare venues.
 
 You should subclass this class to you use it in your app or if you whant to customize it's appearance or logic. In subclass you can customize right navigation bar item by overriding activityBarButtonItem and refreshBarButtonItem properties and behavior of CLLocationManager locationManager by setting it's properties. 
 */
@interface DVFoursquareNearbyViewController : UITableViewController <DVFoursquareCreatePlaceViewControllerDelegate, UISearchDisplayDelegate, CLLocationManagerDelegate>

/** The object that acts as the delegate of the receiving controller.
 
 The delegate must adopt the DVFoursquareNearbyViewControllerDelegate protocol. The delegate is not retained.
 */
@property (nonatomic, weak) id<DVFoursquareNearbyViewControllerDelegate> delegate;

/** Returns the object that acts as Foursquare API client.
 */
- (DVFoursquareClient *)foursquareClient;

/** Returns UIBarButtonItem which replaces refreshBarButtonItem during refreshing data.
 By default returns custom UIBarButtonItem with activity indicator.
 */
@property (nonatomic, strong) UIBarButtonItem *activityBarButtonItem;

/** Returns UIBarButtonItem that is displayed on right side of navigation bar and acts like refresh button.
 By default returns UIBarButtonSystemItemRefresh system item.
 */
@property (nonatomic, strong) UIBarButtonItem *refreshBarButtonItem;

/** NSString object that defines initial query string for venues search.
 */
@property (nonatomic, copy) NSString *initialSearchQuery;

/** Boolean value that determines whether search is enabled. If yes (default) controller displaes search bar in it's table view header.
 */
@property (nonatomic) BOOL searchEnabled;

/** Boolean value that determines whether refuresh button is displayed in navigation bar. Default is TRUE. If this value is FALSE refresh button will nat appear in navigation bar, but UIBarButtonItem provided by activityBarButtonItem property will still appear during search.
 */
@property (nonatomic) BOOL refreshEnabled;

/** Boolean value that determines whether controller need update it's table view content on device location chagens. Default value is YES. If set to FALSE location changes will not cause updating currentLocation property.
 
 Controller adopts CLLocationManagerDelegate and act as a delegate for it's locationManager property which is instance of CLLocationManager class. Default impelmentation of -locationManager:didUpdateToLocation:fromLocation: CLLocationManagerDelegate method cause controller to update it's currentLocation property, which cause data refreshing.
 */
@property (nonatomic) BOOL needUpdateOnLocationChange;

/** Float value that determines search radius (in metres) for Foursquare search requests. Default value is 1000 metres.
 */
@property (nonatomic) CGFloat searchRadius;

/** The object of CLLocationManager class. Controller act's like this object's delegate.
 
 You can set it's distanceFilter and desiredAccuracy to customize controller behaviour. Defalut value for distanceFilter is 100. Default value for desiredAccuracy is kCLLocationAccuracyBest.
 */
@property (nonatomic, strong) CLLocationManager *locationManager;

/** Returns array of current search results.
 */
- (NSArray *)items;

/** Returns devece's current location, provided by locationManager. Initial value is equal to locationManager initial value which can differ from current device location (see CLLocationManager docs).
 */
- (CLLocation *)currentLocation;

@end
