//
//  DVFoursquareClient.h
//  FoursquareNearby
//
//  Created by Ilya Puchka on 23.11.12.
//  Copyright (c) 2012 Denivip. All rights reserved.
//

#import "AFHTTPClient.h"

typedef void (^DVFoursquareClientCompletionBlock)(NSArray* venues, NSError *error);

#define kCLIENTID @"Your Foursquare Client ID"
#define kCLIENTSECRET @"Your Foursquare Client Secret"

@interface DVFoursquareClient : AFHTTPClient

+ (id)sharedClient;

- (void)nearbyPlacesForLocation:(CGPoint)location
                  onCompletion:(DVFoursquareClientCompletionBlock)completion;

- (void)searchPlacesWithQuery:(NSString *)query
                 onCompletion:(DVFoursquareClientCompletionBlock)completion;

- (void)searchPlacesWithQuery:(NSString *)query
                    location:(CGPoint)location
                      radius:(CGFloat)radius
                onCompletion:(DVFoursquareClientCompletionBlock)completion;

@end
