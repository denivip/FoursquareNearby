//
//  DVCreatePlaceViewController.h
//  FoursquareNearby
//
//  Created by Ilya Puchka on 23.11.12.
//  Copyright (c) 2012 Denivip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVFoursquareClient.h"

@interface DVFoursquareCreatePlaceViewController : UITableViewController

@property (nonatomic, strong, readonly) DVFoursquareClient *foursquareClient;

@property (nonatomic, copy) NSString *initialName;
@property (nonatomic) CGPoint location;
@property (nonatomic, strong) UIButton *addButton;

@end
