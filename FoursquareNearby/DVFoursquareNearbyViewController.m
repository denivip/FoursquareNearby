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

@interface DVFoursquareNearbyViewController () <UISearchDisplayDelegate>

@property (nonatomic, strong) DVFoursquareClient *foursquareClient;
@property (nonatomic, strong) NSArray *items;

@end

@implementation DVFoursquareNearbyViewController

@synthesize items = _venues;
@synthesize initialSearchQuery = _initialSearchQuery;
@synthesize searchEnabled = _searchEnabled;
@synthesize refreshEnabled = _refreshEnabled;
@synthesize activityBarButtonItem = _activityBarButtonItem;
@synthesize refreshBarButtonItem = _refreshBarButtonItem;

- (DVFoursquareClient *)foursquareClient
{
    if (!_foursquareClient) {
        _foursquareClient = [DVFoursquareClient sharedClient];
    }
    return _foursquareClient;
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
        _refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData:)];
    }
    return _refreshBarButtonItem;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"FoursquareNearby";
        self.searchEnabled = YES;
        self.refreshEnabled = YES;
        _venues = @[];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"FoursquareNearby";
        self.searchEnabled = YES;
        self.refreshEnabled = YES;
        _venues = @[];
    }
    return self;
}

- (void)setItems:(NSArray *)venues
{
    _venues = venues;

    [self.tableView reloadData];
}

- (void)setInitialSearchQuery:(NSString *)initialSearchQuery
{
    _initialSearchQuery = [initialSearchQuery copy];
    
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
    
    if (self.searchEnabled) {
        [self.tableView setTableHeaderView:self.searchDisplayController.searchBar];
    }
    else {
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
    
    if (self.initialSearchQuery &&
        ![self.initialSearchQuery isEqual:@""]) {
        [self refreshDataWithQuery:self.initialSearchQuery];
    }
    else {
        [self refreshData:nil];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 2;
    }
    else {
        return self.items.count;
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
        static NSString *CellIdentifier = @"VenueCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        NSDictionary *venue = self.items[indexPath.row];
        
        cell.textLabel.text = venue[@"name"];
        cell.detailTextLabel.text = venue[@"location"][@"address"];
        
        if ([venue[@"categories"] lastObject][@"icon"]) {
            cell.imageView.image = [UIImage imageNamed:@"category_placeholder"];
        }
        
        [[AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[venue[@"categories"] lastObject][@"icon"]]] success:^(UIImage *image) {
            cell.imageView.image = image;
            [cell setNeedsLayout];
        }] start];
        
        return cell;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        switch (indexPath.row) {
            case 0: {
                DVFoursquareCreatePlaceViewController *createPlaceViewControlle = [[DVFoursquareCreatePlaceViewController alloc] initWithStyle:UITableViewStyleGrouped];
                [self.navigationController pushViewController:createPlaceViewControlle animated:YES];
            }
                break;
            case 1: {
                DVFoursquareNearbyViewController *foursquareNearbyViewController = [[DVFoursquareNearbyViewController alloc] initWithNibName:@"DVFoursquareNearbyViewController" bundle:nil];
                foursquareNearbyViewController.initialSearchQuery = self.searchDisplayController.searchBar.text;
                foursquareNearbyViewController.searchEnabled = NO;
                foursquareNearbyViewController.refreshEnabled = NO;
                foursquareNearbyViewController.title = @"Nearby";
                [self.navigationController pushViewController:foursquareNearbyViewController animated:YES];
            }
                break;
        }
    }
}

- (void)refreshData:(id)sender
{
    if (self.initialSearchQuery) {
        [self refreshDataWithQuery:self.initialSearchQuery];
        return;
    }
    
    self.items = @[];
    
    if (self.refreshEnabled) {
        self.navigationItem.rightBarButtonItem = self.activityBarButtonItem;
    }
    
    [self.foursquareClient nearbyPlacesForLocation:CGPointZero
                                      onCompletion:^(NSArray *venues, NSError *error) {
        
        if (self.refreshEnabled) {
            self.navigationItem.rightBarButtonItem = self.refreshBarButtonItem;
        }

        if (venues && !error) {
            self.items = venues;
        }
        else if (error) {
            NSLog(@"Error while fetching nearby venues: %@", error.description);
        }
        
    }];
}

- (void)refreshDataWithQuery:(NSString *)query
{
    self.items = @[];
    
    if (self.refreshEnabled) {
        self.navigationItem.rightBarButtonItem = self.activityBarButtonItem;
    }
    
    [self.foursquareClient searchPlacesWithQuery:query
                                        location:CGPointZero
                                          radius:0.0f
                                    onCompletion:^(NSArray *venues, NSError *error) {
                                                   
                                           if (self.refreshEnabled) {
                                               self.navigationItem.rightBarButtonItem = self.refreshBarButtonItem;
                                           }
                                           
                                           if (venues && !error) {
                                               self.items = venues;
                                           }
                                           else if (error) {
                                               NSLog(@"Error while fetching nearby venues: %@", error.description);
                                           }

                                       }];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - UISearchDisplayController Delegate Methods

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    return YES;
}

@end
