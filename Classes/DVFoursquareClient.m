//
//  DVFoursquareClient.m
//  FoursquareNearby
//
//  Created by Ilya Puchka on 23.11.12.
//  Copyright (c) 2012 Denivip. All rights reserved.
//

#import "DVFoursquareClient.h"
#import "AFJSONRequestOperation.h"

@implementation NSString (URLEncoding)

-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
	return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                               (CFStringRef)self,
                                                               NULL,
                                                               (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                               CFStringConvertNSStringEncodingToEncoding(encoding)));
}
@end

static NSString *const kBaseURLString = @"https://api.foursquare.com/v2/";

@implementation DVFoursquareClient

+ (id)sharedClient
{
    // singleton initialization
    
    static dispatch_once_t pred = 0;
    __strong static id client = nil;
    dispatch_once(&pred, ^{
        client = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBaseURLString]];
        [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [client setDefaultHeader:@"Accept" value:@"application/json"];
    });
    return client;
}

- (void)populateNearbyPlacesWithObject:(id)object onCompletion:(DVFoursquareClientCompletionBlock)completion
{
    if (![object isKindOfClass:[NSDictionary class]] ||
        !object[@"response"][@"groups"]) {
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, [NSError errorWithDomain:@"DVFoursquaerClientErrorDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"Invalid response structure"}]);
            });
        }
        return;
    }
    
    NSMutableArray *venues = [@[] mutableCopy];
    
    [object[@"response"][@"groups"] enumerateObjectsUsingBlock:^(NSDictionary *group, NSUInteger idx, BOOL *stop) {
        [venues addObjectsFromArray:group[@"items"]];
    }];
    
    if (completion) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(venues, nil);
        });
    }

}

- (NSString *)locationStringFromCGPoint:(CGPoint)location
{
    return [[NSStringFromCGPoint(location) stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{ }"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void)nearbyPlacesForLocation:(CGPoint)location onCompletion:(DVFoursquareClientCompletionBlock)completion
{
    NSDictionary *queryParameters = @{
        @"client_id" : kCLIENTID,
        @"client_secret" : kCLIENTSECRET,
        @"ll" : [self locationStringFromCGPoint:location]
    };
    
    [self getPath:@"venues/search" parameters:queryParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        dispatch_queue_t concurentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(concurentQueue, ^{
            [self populateNearbyPlacesWithObject:responseObject onCompletion:completion];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

- (void)searchPlacesWithQuery:(NSString *)query onCompletion:(DVFoursquareClientCompletionBlock)completion
{
    NSDictionary *queryParameters = @{
        @"client_id" : kCLIENTID,
        @"client_secret" : kCLIENTSECRET,
        @"intent" : @"global",
        @"query" : query
    };
    
    [self getPath:@"venues/search" parameters:queryParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        dispatch_queue_t concurentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(concurentQueue, ^{
            [self populateNearbyPlacesWithObject:responseObject onCompletion:completion];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

- (void)searchPlacesWithQuery:(NSString *)query location:(CGPoint)location radius:(CGFloat)radius onCompletion:(DVFoursquareClientCompletionBlock)completion
{
    if ((location.x == 0.0f && location.y == 0.0f) || radius == 0.0f) {
        [self searchPlacesWithQuery:query onCompletion:completion];
    }
    else {
        
        NSDictionary *queryParameters = @{
            @"client_id" : kCLIENTID,
            @"client_secret" : kCLIENTSECRET,
            @"intent" : @"browse",
            @"query" : query,
            @"ll" : [self locationStringFromCGPoint:location],
            @"radius" : [NSString stringWithFormat:@"%f",radius]
        };
        
        [self getPath:@"venues/search" parameters:queryParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            dispatch_queue_t concurentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(concurentQueue, ^{
                [self populateNearbyPlacesWithObject:responseObject onCompletion:completion];
            });
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (completion) {
                completion(nil, error);
            }
        }];
    }
}

- (void)addPlaceWithParameters:(NSDictionary *)parameters onCompletion:(DVFoursquareClientPostRequestCompletionBlock)completion
{
    NSMutableDictionary *queryParameters = [parameters mutableCopy];
    
    queryParameters[@"client_id"] = kCLIENTID;
    queryParameters[@"client_secret"] = kCLIENTSECRET;
    queryParameters[@"oauth_token"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"foursquare_access_token"];
    queryParameters[@"ll"] = [self locationStringFromCGPoint:[queryParameters[@"ll"] CGPointValue]];
    
    [self postPath:@"venues/add" parameters:queryParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (completion) completion(YES, responseObject, nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        if (completion) completion(NO, nil, error);

    }];
}

- (void)populateCategoriesWithObject:(id)object superCategoryId:(NSString *)superCategoryId onCompletion:(DVFoursquareClientCompletionBlock)completion
{
    if (![object isKindOfClass:[NSDictionary class]] ||
        !object[@"response"][@"categories"]) {
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, [NSError errorWithDomain:@"DVFoursquaerClientErrorDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"Invalid response structure"}]);
            });
        }
        return;
    }
    
    NSMutableArray *categories = object[@"response"][@"categories"];
    
    if (superCategoryId && ![superCategoryId isEqualToString:@""]) {
        categories = [self populateSubCategoriesFromObject:categories superCategoryId:superCategoryId];
    }
    
    if (completion) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(categories, nil);
        });
    }
}

- (NSMutableArray *)populateSubCategoriesFromObject:(NSArray *)object superCategoryId:(NSString *)superCategoryId
{
    __block NSMutableArray *subCategories = [@[] mutableCopy];
    [object enumerateObjectsUsingBlock:^(NSDictionary *category, NSUInteger idx, BOOL *stop) {
        if ([category[@"id"] isEqualToString:superCategoryId]) {
            subCategories = category[@"categories"];
            *stop = YES;
        }
        else if (category[@"categories"] && [category[@"categories"] count] != 0) {
            subCategories = [self populateSubCategoriesFromObject:category[@"categories"]
                                                  superCategoryId:superCategoryId];
            if (subCategories.count) *stop = YES;
        }
    }];
    
    return subCategories;
}

- (void)searchCategories:(DVFoursquareClientCompletionBlock)completion
{
    NSDictionary *queryParameters = @{
        @"client_id" : kCLIENTID,
        @"client_secret" : kCLIENTSECRET,
    };
    
    [self getPath:@"venues/categories" parameters:queryParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        dispatch_queue_t concurentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(concurentQueue, ^{
            [self populateCategoriesWithObject:responseObject superCategoryId:nil onCompletion:completion];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

- (void)searchCategoriesWithSuperCategory:(NSDictionary *)category onCompletion:(DVFoursquareClientCompletionBlock)completion
{
    if (!category) {
        [self searchCategories:completion];
        return;
    }
    
    NSDictionary *queryParameters = @{
    @"client_id" : kCLIENTID,
    @"client_secret" : kCLIENTSECRET,
    };
    
    [self getPath:@"venues/categories" parameters:queryParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        dispatch_queue_t concurentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(concurentQueue, ^{
            [self populateCategoriesWithObject:responseObject superCategoryId:category[@"id"] onCompletion:completion];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];    
}


@end
