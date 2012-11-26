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

@interface DVFoursquareCreatePlaceViewController ()

@property (nonatomic, strong) DVFoursquareClient *foursquareClient;
@property (nonatomic, strong) NSMutableDictionary *parameters;

@end

@implementation DVFoursquareCreatePlaceViewController

- (NSMutableDictionary *)parameters
{
    if (!_parameters) {
        _parameters = [@{} mutableCopy];
    }
    return _parameters;
}

- (DVFoursquareClient *)foursquareClient
{
    if (!_foursquareClient) {
        _foursquareClient = [DVFoursquareClient sharedClient];
    }
    return _foursquareClient;
}

- (void)setName:(NSString *)name
{
    _name = [name copy];
    self.parameters[@"name"] = _name;
}

- (void)setCategory:(NSDictionary *)category
{
    _category = category;
    self.parameters[@"primaryCategoryId"] = _category[@"id"];
}

- (void)setCity:(NSString *)city
{
    _city = [city copy];
    self.parameters[@"city"] = _city;
}

- (void)setCrossStreet:(NSString *)crossStreet
{
    _crossStreet = [crossStreet copy];
    self.parameters[@"crossStreet"] = _crossStreet;
}

- (void)setPhone:(NSString *)phone
{
    _phone = [phone copy];
    self.parameters[@"phone"] = _phone;
}

- (void)setTwitter:(NSString *)twitter
{
    _twitter = [twitter copy];
    self.parameters[@"twitter"] = _twitter;
}

- (void)setZip:(NSString *)zip
{
    _zip = [zip copy];
    self.parameters[@"zip"] = _zip;
}

- (void)setState:(NSString *)state
{
    _state = [state copy];
    self.parameters[@"state"] = _state;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Create new venue";
    }
    return self;
}

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

- (DVFoursquareClientPostRequestCompletionBlock)createVenueCompletionBlock
{
    return ^(BOOL success, id responseObject, NSError *error){
        if (success && !error && responseObject) {
            if ([self.delegate respondsToSelector:@selector(controller:didCreateVenue:)]) {
                [self.delegate controller:self didCreateVenue:responseObject[@"response"][@"venue"]];
            }
        }
        else if (error) {
            if ([self.delegate respondsToSelector:@selector(controller:didFailToCreateVenueWithError:)]) {
                [self.delegate controller:self didFailToCreateVenueWithError:error];
            }
        }
    };
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
            ((DVTextFieldCell*)cell).textField.text = self.name;
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
            if (self.category) {
                cell.textLabel.text = [NSString stringWithFormat:@"Category: %@", self.category[@"name"]];
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
    
    NSString *newValue = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    switch (indexPath.row) {
        case DVTagName:
            self.name = newValue;
            break;
        case DVTagAddress:
            self.address = newValue;
            break;
        case DVTagCity:
            self.city = newValue;
            break;
        case DVTagCrossStreet:
            self.crossStreet = newValue;
            break;
        case DVTagPhone:
            self.phone = newValue;
            break;
        case DVTagPostcode:
            self.zip = newValue;
            break;
        case DVTagState:
            self.state = newValue;
            break;
        case DVTagTwitter:
            self.twitter = newValue;
            break;
        default:
        break;
    }
    
    return YES;
}

#pragma mark - DVFoursquareNearbyViewController Delegate

- (void)controller:(DVFoursquareNearbyViewController *)controller didSelectCategory:(NSDictionary *)category
{
    [self.navigationController popToViewController:self animated:YES];
    self.category = category;
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
    NSMutableDictionary *parameters = [[self populateData] mutableCopy];
    parameters[@"ll"] = [NSValue valueWithCGPoint:self.location];
    
    [self.foursquareClient addPlaceWithParameters:parameters onCompletion:[self createVenueCompletionBlock]];
}

- (void)controller:(DVFoursquareAuthViewController *)controller didLoginUser:(NSDictionary *)user
{
    [self createVenue];
}

@end
