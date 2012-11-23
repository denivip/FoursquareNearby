//
//  DVFoursquareNearbyViewController.h
//  FoursquareNearby
//
//  Created by Ilya Puchka on 23.11.12.
//  Copyright (c) 2012 Denivip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVFoursquareClient.h"

@interface DVFoursquareNearbyViewController : UITableViewController

@property (nonatomic, strong, readonly) DVFoursquareClient *foursquareClient;

@property (nonatomic, strong) UIBarButtonItem *activityBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *refreshBarButtonItem;

@property (nonatomic, copy) NSString *initialSearchQuery;
@property (nonatomic) BOOL searchEnabled;
@property (nonatomic) BOOL refreshEnabled;

@property (nonatomic, strong, readonly) NSArray *items;

@end
