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

@interface DVFoursquareCreatePlaceViewController () <UITextFieldDelegate>

@end

@implementation DVFoursquareCreatePlaceViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Create new venue";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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
            break;
        }
        case DVTagCategory:
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = @"Category";
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
            return cell;
        }
            break;
    }
    
    ((DVTextFieldCell*)cell).textField.returnKeyType = UIReturnKeyNext;
    ((DVTextFieldCell*)cell).textField.delegate = self;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case DVTagCategory:
        {
            DVFoursquareCategoriesViewController *categoriesViewController = [[DVFoursquareCategoriesViewController alloc] init];
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

@end
