//
//  DVFoursquareCategoriesViewController.h
//  FoursquareNearby
//
//  Created by Ilya Puchka on 23.11.12.
//  Copyright (c) 2012 Denivip. All rights reserved.
//

#import "DVFoursquareNearbyViewController.h"

/** A subclass of DVFoursquareNearbyViewController that manages iterface for selecting categories or subcategories.
 */
@interface DVFoursquareCategoriesViewController : DVFoursquareNearbyViewController

@property (nonatomic, strong) NSDictionary *superCategory;

@end
