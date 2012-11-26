//
//  DVFoursquareCreatePlaceViewControllerDelegate.h
//  FoursquareNearby
//
//  Created by Ilya Puchka on 26.11.12.
//  Copyright (c) 2012 Denivip. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DVFoursquareCreatePlaceViewController;

/** The delegate of DVFoursquareCreatePlaceViewController can adopt DVFoursquareCreatePlaceViewControllerDelegate protocol to manage actions on venue creation or fail.
 */
@protocol DVFoursquareCreatePlaceViewControllerDelegate <NSObject>

@optional
- (void)controller:(DVFoursquareCreatePlaceViewController *)controller didCreateVenue:(NSDictionary *)venue;
- (void)controller:(DVFoursquareCreatePlaceViewController *)controller didFailToCreateVenueWithError:(NSError *)error;

@end