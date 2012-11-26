//
//  DVFoursquareNearbyViewController.m
//  FoursquareNearby
//
//  Created by Ilya Puchka on 23.11.12.
//  Copyright (c) 2012 Denivip. All rights reserved.
//

#import "DVFoursquareNearbyViewController.h"
#import "DVFoursquareCreatePlaceViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIView+FindAndResignFirstResponder.h"

@interface DVFoursquareNearbyViewController ()

@property (nonatomic, strong) DVFoursquareClient *foursquareClient;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) CLLocation *currentLocation;

@end

@implementation DVFoursquareNearbyViewController

- (void)setItems:(NSArray *)items
{
    _items = [items sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"location.distance" ascending:YES]]];
    [self.tableView reloadData];
}

- (DVFoursquareClientCompletionBlock)searchPlacesCompletionBlock
{
    return ^(NSArray* results, NSError *error){
        if (self.refreshEnabled) {
            self.navigationItem.rightBarButtonItem = self.refreshBarButtonItem;
        }
        else {
            self.navigationItem.rightBarButtonItem = nil;
        }
        
        if (results && !error) {
            self.items = results;
        }
        else if (error) {
            NSLog(@"Error while fetching nearby venues: %@", error.description);
        }
    };
}

@synthesize currentLocation = _currentLocation;

- (CLLocation *)currentLocation
{
    if (!_currentLocation) {
        _currentLocation = self.locationManager.location;
    }
    return _currentLocation;
}

- (void)setCurrentLocation:(CLLocation *)currentLocation
{
    _currentLocation = currentLocation;
    
    //to prevent many apdates
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayedDataRefreshing) object:nil];
    [self performSelector:@selector(delayedDataRefreshing) withObject:nil afterDelay:0.2];
}

- (void)delayedDataRefreshing
{
    [self.locationManager stopUpdatingLocation];
    [self refreshData];
}

- (DVFoursquareClient *)foursquareClient
{
    if (!_foursquareClient) {
        _foursquareClient = [DVFoursquareClient sharedClient];
    }
    return _foursquareClient;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager && self.needUpdateOnLocationChange) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 100;
    }
    return _locationManager;
}

- (UIBarButtonItem *)activityBarButtonItem
{
    if (!_activityBarButtonItem) {
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 35, 20)];
        
        _activityBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
        
        [activityIndicator startAnimating];
    }
    return _activityBarButtonItem;
}

- (UIBarButtonItem *)refreshBarButtonItem
{
    if (!_refreshBarButtonItem) {
        _refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonTapped:)];
    }
    return _refreshBarButtonItem;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (void)setupDefaults
{
    self.title = @"FoursquareNearby";
    self.searchEnabled = YES;
    self.refreshEnabled = YES;
    self.needUpdateOnLocationChange = YES;
    _items = @[];
    _searchRadius = 1000;
}

- (void)setInitialSearchQuery:(NSString *)initialSearchQuery
{
    _initialSearchQuery = [initialSearchQuery copy];
    self.title = [NSString stringWithFormat:@"Search \"%@\"", _initialSearchQuery];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.refreshEnabled) {
        self.navigationItem.rightBarButtonItem = self.refreshBarButtonItem;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"poweredByFoursquare_gray"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 40)];
    [footerView addSubview:imageView];
    footerView.backgroundColor = [UIColor clearColor];
    imageView.center = CGPointMake(CGRectGetMidX(footerView.bounds), CGRectGetMidY(footerView.bounds));
    imageView.frame = CGRectIntegral(imageView.frame);
    [self.tableView setTableFooterView:footerView];
    
    if (!self.searchEnabled) {
        [self.tableView setTableHeaderView:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshButtonTapped:nil];
}

- (NSString *)distanceStringFromValue:(NSNumber *)value
{
    NSUInteger km = value.integerValue / 1000;
    NSUInteger m = value.integerValue % 1000;
    if (km) {
        return [NSString stringWithFormat:@"%i км. %i м.", km, m];
    }
    else {
        return [NSString stringWithFormat:@"%i м.", m];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 2;
    }
    else {
        return MAX(1, self.items.count);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = [NSString stringWithFormat:@"Create \"%@\"", self.searchDisplayController.searchBar.text];
                cell.detailTextLabel.text = @"Create new location";
            }
                break;
            case 1:
            {
                cell.textLabel.text = [NSString stringWithFormat:@"Find \"%@\"", self.searchDisplayController.searchBar.text];
                cell.detailTextLabel.text = @"Search more places nearby";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
        }
        
        return cell;
    }
    else {
        if (self.items.count) {
            static NSString *CellIdentifier = @"VenueCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            
            NSDictionary *venue = self.items[indexPath.row];
            
            cell.textLabel.text = venue[@"name"];
            
            NSString *detailString;
            NSNumber *distance = venue[@"location"][@"distance"];
            
            if (distance) detailString = [self distanceStringFromValue:distance];
            
            NSString *address = venue[@"location"][@"address"];
            if (address) {
                if (detailString) {
                    detailString = [detailString stringByAppendingString:@" - "];
                }
                detailString = [detailString stringByAppendingString:address];
            }
            
            cell.detailTextLabel.text = detailString;
            
            return cell;
        }
        else {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = @"No results";
            cell.textLabel.textColor = [UIColor grayColor];
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            return cell;
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        switch (indexPath.row) {
            case 0: {
                DVFoursquareCreatePlaceViewController *createPlaceViewController = [[DVFoursquareCreatePlaceViewController alloc] initWithStyle:UITableViewStyleGrouped];
                createPlaceViewController.name = self.searchDisplayController.searchBar.text;
                createPlaceViewController.location = CLLocationToCGPoint(self.currentLocation);
                createPlaceViewController.delegate = self;
                [self.navigationController pushViewController:createPlaceViewController animated:YES];
            }
                break;
            case 1: {
                DVFoursquareNearbyViewController *foursquareNearbyViewController = [[DVFoursquareNearbyViewController alloc] initWithNibName:@"DVFoursquareNearbyViewController" bundle:nil];
                foursquareNearbyViewController.initialSearchQuery = self.searchDisplayController.searchBar.text;
                foursquareNearbyViewController.searchEnabled = NO;
                foursquareNearbyViewController.refreshEnabled = NO;
                foursquareNearbyViewController.delegate = self.delegate;
                [self.navigationController pushViewController:foursquareNearbyViewController animated:YES];
            }
                break;
        }
    }
    else {
        if ([self.delegate respondsToSelector:@selector(controller:didSelectVenue:)]) {
            [self.delegate controller:self didSelectVenue:self.items[indexPath.row]];
        }
    }
}

#pragma mark -

- (void)refreshButtonTapped:(id)sender
{
    if (![CLLocationManager locationServicesEnabled] && self.needUpdateOnLocationChange) {
        return;
    }
    
    self.navigationItem.rightBarButtonItem = self.activityBarButtonItem;

    if (self.needUpdateOnLocationChange) {
        [self.locationManager startUpdatingLocation];
    }
    else {
        [self refreshData];
    }
}

- (void)refreshData
{
    if (self.initialSearchQuery &&
        ![self.initialSearchQuery isEqual:@""]) {
        [self refreshDataWithQuery:self.initialSearchQuery];
        return;
    }
    
    self.items = @[];
    
    [self.foursquareClient nearbyPlacesForLocation:CLLocationToCGPoint(self.currentLocation)
                                      onCompletion:[self searchPlacesCompletionBlock]];
}

- (void)refreshDataWithQuery:(NSString *)query
{
    self.items = @[];
    
    [self.foursquareClient searchPlacesWithQuery:query
                                        location:CLLocationToCGPoint(self.currentLocation)
                                          radius:self.searchRadius
                                    onCompletion:[self searchPlacesCompletionBlock]];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - UISearchDisplayController Delegate Methods

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.searchPlacesCompletionBlock(nil, error);
    [self.locationManager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (self.needUpdateOnLocationChange) {
        self.currentLocation = newLocation;
    }
}


@end
