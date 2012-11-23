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
        @"ll" : [self locationStringFromCGPoint:CGPointMake(37, -122)]
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
            @"ll" : [self locationStringFromCGPoint:CGPointMake(37, -122)],
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

@end
