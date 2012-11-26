//
//  DVCreatePlaceViewController.h
//  FoursquareNearby
//
//  Created by Ilya Puchka on 23.11.12.
//  Copyright (c) 2012 Denivip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVFoursquareClient.h"
#import "DVFoursquareCategoriesViewController.h"
#import "DVFoursquareAuthViewController.h"

@protocol DVFoursquareNearbyViewControllerDelegate, DVFoursquareAuthViewControllerDelegate;

/** View controller that provides user interface for creating new venue. See Foursqaure docs for list of params.
 */
@interface DVFoursquareCreatePlaceViewController : UITableViewController <UITextFieldDelegate, DVFoursquareNearbyViewControllerDelegate, DVFoursquareAuthViewControllerDelegate>

@property (nonatomic, strong, readonly) DVFoursquareClient *foursquareClient;

@property (nonatomic, weak) id<DVFoursquareCreatePlaceViewControllerDelegate> delegate;

@property (nonatomic, copy) NSString *name;
@property (nonatomic) CGPoint location;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *crossStreet;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *zip;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *twitter;
@property (nonatomic, copy) NSDictionary *category;

@property (nonatomic, strong) UIButton *addButton;

@end
