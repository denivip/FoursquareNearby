//
//  DVFoursquareAuthViewControllerDelegate.h
//  FoursquareNearby
//
//  Created by Ilya Puchka on 26.11.12.
//  Copyright (c) 2012 Denivip. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DVFoursquareAuthViewController;

@protocol DVFoursquareAuthViewControllerDelegate <NSObject>

- (void)controller:(DVFoursquareAuthViewController *)controller didLoginUser:(NSDictionary *)user;

@end
