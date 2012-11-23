//
//  DVFoursquareCategoriesViewController.m
//  FoursquareNearby
//
//  Created by Ilya Puchka on 23.11.12.
//  Copyright (c) 2012 Denivip. All rights reserved.
//

#import "DVFoursquareCategoriesViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DVFoursquareCategoriesViewController ()

@property (nonatomic, strong) NSArray *items;

@end

@implementation DVFoursquareCategoriesViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.refreshEnabled = NO;
        self.searchEnabled = NO;
        
        self.title = @"Category";
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.refreshEnabled = NO;
        self.searchEnabled = NO;
        
        self.title = @"Category";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *category = self.items[indexPath.row];
    
    if (category[@"icon"]) {
        cell.imageView.image = [UIImage imageNamed:@"category_placeholder"];
    }
    
    [[AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:category[@"icon"]]] success:^(UIImage *image) {
        cell.imageView.image = image;
        [cell setNeedsLayout];
    }] start];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *category = self.items[indexPath.row];
    
    if ([category[@"categories"] count] != 0) {
        DVFoursquareCategoriesViewController *categoryViewControlle = [[DVFoursquareCategoriesViewController alloc] init];
        categoryViewControlle.superCategoryId = self.items[indexPath.row][@"id"];
        [self.navigationController pushViewController:categoryViewControlle animated:YES];
    }
}

- (void)refreshData:(id)sender
{
    self.items = @[];
    
    [self.foursquareClient searchCategories:^(NSArray *categories, NSError *error) {

        if (categories && !error) {
            if (self.superCategoryId) {
                [categories enumerateObjectsUsingBlock:^(NSDictionary *category, NSUInteger idx, BOOL *stop) {
                    if ([category[@"id"] isEqualToString:self.superCategoryId]) {
                        self.items = category[@"categories"];
                        *stop = YES;
                    }
                }];
            }
            else {
                self.items = categories;
            }
        }
        else if (error) {
            NSLog(@"Error while fetching categories: %@", error.description);
        }

    }];
}

@end
