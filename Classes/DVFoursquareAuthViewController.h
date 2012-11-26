//
//  FoursquareAuthViewController.m
//  CoreDataTalk
//
//  Created by Anoop Ranganath on 2/19/11.
//  Copyright 2011 foursquare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVFoursquareAuthViewControllerDelegate.h"

@interface DVFoursquareAuthViewController : UIViewController

@property (nonatomic, weak) id<DVFoursquareAuthViewControllerDelegate> delegate;

@end
