//
//  DVCreatePlaceViewController.m
//  FoursquareNearby
//
//  Created by Ilya Puchka on 23.11.12.
//  Copyright (c) 2012 Denivip. All rights reserved.
//

#import "DVFoursquareCreatePlaceViewController.h"
#import "DVTextFieldCell.h"
#import "UIView+FindAndResignFirstResponder.h"
#import "DVFoursquareCategoriesViewController.h"
#import "DVFoursquareAuthViewController.h"

typedef enum DVPlaceCreationTableViewCellTags {
    DVTagName,
    DVTagCategory,
    DVTagAddress,
    DVTagCrossStreet,
    DVTagCity,
    DVTagState,
    DVTagPostcode,
    DVTagPhone,
    DVTagTwitter,
    DVTagsCount
} DVPlaceCreationTableViewCellTag;

@interface DVFoursquareCreatePlaceViewController () <UITextFieldDelegate, DVFoursquareNearbyViewControllerDelegate, DVFoursquareAuthViewControllerDelegate>

@property (nonatomic, strong) NSDictionary *selectedCategory;
@property (nonatomic, strong) DVFoursquareClient *foursquareClient;
@property (nonatomic, strong) NSMutableDictionary *parameters;

@end

@implementation DVFoursquareCreatePlaceViewController

@synthesize parameters = _parameters;

- (NSMutableDictionary *)parameters
{
    if (!_parameters) {
        _parameters = [@{} mutableCopy];
    }
    return _parameters;
}

@synthesize foursquareClient = _foursquareClient;

- (DVFoursquareClient *)foursquareClient
{
    if (!_foursquareClient) {
        _foursquareClient = [DVFoursquareClient sharedClient];
    }
    return _foursquareClient;
}

@synthesize initialName = _initialName;

- (void)setInitialName:(NSString *)initialName
{
    _initialName = [initialName copy];
    self.parameters[@"name"] = _initialName;
}

- (void)setSelectedCategory:(NSDictionary *)selectedCategory
{
    _selectedCategory = selectedCategory;
    self.parameters[@"primaryCategoryId"] = selectedCategory[@"id"];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Create new venue";
    }
    return self;
}

@synthesize addButton = _addButton;

- (UIButton *)addButton
{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _addButton.frame = CGRectMake(0, 0, 150, 44);
        [_addButton setTitle:@"Add venue" forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundView = nil;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    footer.backgroundColor = [UIColor clearColor];
    
    [footer addSubview:self.addButton];
    self.addButton.center = CGPointMake(CGRectGetMidX(footer.bounds), CGRectGetMidY(footer.bounds));

    [self.tableView setTableFooterView:footer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return DVTagsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;

    switch (indexPath.row) {
        case DVTagName:
        {
            cell = [[DVTextFieldCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = @"Name";
            ((DVTextFieldCell*)cell).textField.text = self.initialName;
            ((DVTextFieldCell*)cell).textField.placeholder = @"Required";
            ((DVTextFieldCell*)cell).textField.returnKeyType = UIReturnKeyNext;
            ((DVTextFieldCell*)cell).textField.delegate = self;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
            break;
        case DVTagCategory:
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            if (self.selectedCategory) {
                cell.textLabel.text = [NSString stringWithFormat:@"Category: %@", self.selectedCategory[@"name"]];
            }
            else {
                cell.textLabel.text = @"Category";
            }
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case DVTagAddress:
        {
            cell = [[DVTextFieldCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = @"Address";
        }
            break;
        case DVTagCrossStreet:
        {
            cell = [[DVTextFieldCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = @"Cross street";
        }
            break;
        case DVTagCity:
        {
            cell = [[DVTextFieldCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = @"City";
        }
            break;
        case DVTagState:
        {
            cell = [[DVTextFieldCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = @"State";
        }
            break;
        case DVTagPostcode:
        {
            cell = [[DVTextFieldCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = @"Postcode";
        }
            break;
        case DVTagPhone:
        {
            cell = [[DVTextFieldCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = @"Phone";
        }
            break;
        case DVTagTwitter:
        {
            cell = [[DVTextFieldCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = @"Twitter";
            ((DVTextFieldCell*)cell).textField.returnKeyType = UIReturnKeyDone;
            ((DVTextFieldCell*)cell).textField.delegate = self;
            ((DVTextFieldCell*)cell).textField.placeholder = @"Not required";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor clearColor];
            label.text = @"@";
            [label sizeToFit];
            ((DVTextFieldCell*)cell).textField.leftView = label;
            ((DVTextFieldCell*)cell).textField.leftViewMode = UITextFieldViewModeAlways;
            return cell;
        }
            break;
    }
    
    ((DVTextFieldCell*)cell).textField.returnKeyType = UIReturnKeyNext;
    ((DVTextFieldCell*)cell).textField.delegate = self;
    ((DVTextFieldCell*)cell).textField.placeholder = @"Not required";
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case DVTagCategory:
        {
            DVFoursquareCategoriesViewController *categoriesViewController = [[DVFoursquareCategoriesViewController alloc] initWithStyle:UITableViewStyleGrouped];
            categoriesViewController.delegate = self;
            [self.navigationController pushViewController:categoriesViewController animated:YES];
        }
            break;
            
        default:
        {
            DVTextFieldCell *cell = (DVTextFieldCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell.textField becomeFirstResponder];
        }
            break;
    }
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITableViewCell *cell = (UITableViewCell*)[textField superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    [textField resignFirstResponder];
    
    if (indexPath.row != DVTagTwitter) {
        NSIndexPath *nextCellIndexPath;
        
        if (indexPath.row == DVTagName) {
            nextCellIndexPath = [NSIndexPath indexPathForRow:indexPath.row+2 inSection:indexPath.section];
        }
        else {
            nextCellIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
        }
        
        DVTextFieldCell *cell = (DVTextFieldCell *)[self.tableView cellForRowAtIndexPath:nextCellIndexPath];
        [cell.textField becomeFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UITableViewCell *cell = (UITableViewCell*)[textField superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSString *key = @"";
    switch (indexPath.row) {
        case DVTagName:
            key = @"name";
            break;
        case DVTagAddress:
            key = @"address";
            break;
        case DVTagCity:
            key = @"city";
            break;
        case DVTagCrossStreet:
            key = @"crossStreet";
            break;
        case DVTagPhone:
            key = @"phone";
            break;
        case DVTagPostcode:
            key = @"zip";
            break;
        case DVTagState:
            key = @"state";
            break;
        case DVTagTwitter:
            key = @"twitter";
            break;
        case DVTagCategory:
            key = @"primaryCategoryId";
        break;
    }
    
    self.parameters[key] = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    return YES;
}

#pragma mark - DVFoursquareNearbyViewController Delegate

- (void)controller:(DVFoursquareNearbyViewController *)controller didSelectCategory:(NSDictionary *)category
{
    [self.navigationController popToViewController:self animated:YES];
    self.selectedCategory = category;
    [self.tableView reloadData];
}

- (NSDictionary *)populateData
{
    NSMutableDictionary *parameters = [@{} mutableCopy];
    [self.parameters enumerateKeysAndObjectsUsingBlock:^(id key, NSString *obj, BOOL *stop) {
        if (![obj isEqualToString:@""]) {
            parameters[key] = obj;
        }
    }];
    return parameters;
}

- (void)addButtonTapped:(id)sender
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"foursquare_access_token"]) {
        [self createVenue];
    }
    else {
        DVFoursquareAuthViewController *authController = [[DVFoursquareAuthViewController alloc] init];
        authController.delegate = self;
        UINavigationController *authNavigationControlle = [[UINavigationController alloc] initWithRootViewController:authController];
        [self.navigationController presentViewController:authNavigationControlle animated:YES completion:NULL];
    }
}

- (void)createVenue
{
    //need to pass ll also
    NSDictionary *parameters = [self populateData];
    [self.foursquareClient addPlaceWithParameters:parameters onCompletion:^(BOOL success, NSError *error) {
        if (error) {
            NSLog(@"%@", error.description);
        }
    }];
}

- (void)controller:(DVFoursquareAuthViewController *)controller didLoginUser:(NSDictionary *)user
{
    [self createVenue];
}

@end
