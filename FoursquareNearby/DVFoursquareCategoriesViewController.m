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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.superCategory) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.superCategory && section == 0) {
        return 1;
    }
    else return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *category;

    if (self.superCategory && indexPath.section == 0) {
        category = self.superCategory;
    }
    else {
        category = self.items[indexPath.row];
    }
    
    cell.textLabel.text = category[@"name"];
    
    if (category[@"icon"]) {
        cell.imageView.image = [UIImage imageNamed:@"Images.bundle/category_placeholder"];
    }
    
    [[AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:category[@"icon"]]] success:^(UIImage *image) {
        cell.imageView.image = image;
        [cell setNeedsLayout];
    }] start];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.superCategory && indexPath.section == 0) {
        if ([self.delegate respondsToSelector:@selector(controller:didSelectCategory:)]) {
            [self.delegate controller:self didSelectCategory:self.superCategory];
        }
        return;
    }
    
    NSDictionary *category = self.items[indexPath.row];
    
    if ([category[@"categories"] count] != 0) {
        DVFoursquareCategoriesViewController *categoryViewControlle = [[DVFoursquareCategoriesViewController alloc] initWithStyle:UITableViewStyleGrouped];
        categoryViewControlle.superCategory = category;
        categoryViewControlle.delegate = self.delegate;
        [self.navigationController pushViewController:categoryViewControlle animated:YES];
    }
    else {
        if ([self.delegate respondsToSelector:@selector(controller:didSelectCategory:)]) {
            [self.delegate controller:self didSelectCategory:self.items[indexPath.row]];
        }
    }
}

- (void)populateSubCategoriesFromObject:(NSArray *)object
{
    [object enumerateObjectsUsingBlock:^(NSDictionary *category, NSUInteger idx, BOOL *stop) {
        if ([category[@"id"] isEqualToString:self.superCategory[@"id"]]) {
            self.items = category[@"categories"];
            *stop = YES;
        }
        else if (category[@"categories"] && [category[@"categories"] count] != 0) {
            [self populateSubCategoriesFromObject:category[@"categories"]];
        }
    }];
}

- (void)refreshData:(id)sender
{
    self.items = @[];
    
    [self.foursquareClient searchCategories:^(NSArray *categories, NSError *error) {

        if (categories && !error) {
            if (self.superCategory) {
                [self populateSubCategoriesFromObject:categories];
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
