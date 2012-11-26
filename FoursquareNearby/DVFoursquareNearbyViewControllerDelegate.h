//
//  DVFoursquareNearbyViewControllerDelegate.h
//  FoursquareNearby
//
//  Created by Ilya Puchka on 26.11.12.
//  Copyright (c) 2012 Denivip. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DVFoursquareNearbyViewController;

/** The delegate of DVFoursquareNearbyViewController can adopt DVFoursquareNearbyViewControllerDelegate protocol to manage actions of venue selection.
*/
@protocol DVFoursquareNearbyViewControllerDelegate <NSObject>

@optional

/** Tells the delegate that a specific venue was selected.
 
 @param controller DVFoursquareNearbyViewController object in which selection occured.
 @param venue NSDictionary object containing information about selected venue (see Foursquare detailes for more info).
 */
- (void)controller:(DVFoursquareNearbyViewController *)controller didSelectVenue:(NSDictionary *)venue;

/** Tells the delegate that a specific category was selected.
 
 @param controller DVFoursquareNearbyViewController object in which selection occured.
 @param category NSDictionary object containing information about selected category (see Foursquare detailes for more info).
 */
- (void)controller:(DVFoursquareNearbyViewController *)controller didSelectCategory:(NSDictionary *)category;

@end
