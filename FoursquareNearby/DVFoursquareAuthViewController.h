//
//  FoursquareAuthViewController.m
//  CoreDataTalk
//
//  Created by Anoop Ranganath on 2/19/11.
//  Copyright 2011 foursquare. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DVFoursquareAuthViewController;

@protocol DVFoursquareAuthViewControllerDelegate <NSObject>

- (void)controller:(DVFoursquareAuthViewController *)controller didLoginUser:(NSDictionary *)user;

@end

@interface DVFoursquareAuthViewController : UIViewController

@property (nonatomic, weak) id<DVFoursquareAuthViewControllerDelegate> delegate;

@end
