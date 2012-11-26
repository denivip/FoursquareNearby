//
//  DVFoursquareClient.h
//  FoursquareNearby
//
//  Created by Ilya Puchka on 23.11.12.
//  Copyright (c) 2012 Denivip. All rights reserved.
//

#import "AFHTTPClient.h"

typedef void (^DVFoursquareClientCompletionBlock)(NSArray* results, NSError *error);
typedef void (^DVFoursquareClientPostRequestCompletionBlock)(BOOL success, id responseObject, NSError *error);

#define kCLIENTID @"KY33OQOSLIEWQCHPLISG2ERQ5DKLQK41MW2QECWNDMGJHJJL"
#define kCLIENTSECRET @"4B2UBSXC5VO1YDJ110O0I2TZDWCHAO1LDRJ054IA2N1PJRN5"

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

- (void)addPlaceWithParameters:(NSDictionary *)parameters 
                  onCompletion:(DVFoursquareClientPostRequestCompletionBlock)completion;

- (void)searchCategories:(DVFoursquareClientCompletionBlock)completion;

- (void)searchCategoriesWithSuperCategory:(NSDictionary *)category
                             onCompletion:(DVFoursquareClientCompletionBlock)completion;

@end
