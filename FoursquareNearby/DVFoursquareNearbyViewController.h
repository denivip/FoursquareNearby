//
//  DVFoursquareNearbyViewController.h
//  FoursquareNearby
//
//  Created by Ilya Puchka on 23.11.12.
//  Copyright (c) 2012 Denivip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVFoursquareClient.h"

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

@property (nonatomic, strong, readonly) NSArray *items;

@end
