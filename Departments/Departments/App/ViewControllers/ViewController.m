//
//  ViewController.m
//  Departments
//
//  Created by Amarjit on 18/02/2015.
//  Copyright (c) 2015 Amarjit. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *objects;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Departments";

    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.allowsSelectionDuringEditing = YES;


    _objects = [NSMutableArray array];

    NSDictionary *sales = @{ @"name" : @"sales",
                             @"employees" : @[ @"Mike", @"Tom", @"Alex"] };

    NSDictionary *marketing = @{ @"name" : @"marketing",
                             @"employees" : @[ @"Heather", @"Richard", @"Simon"] };

    [_objects addObject:sales];
    [_objects addObject:marketing];

    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButton:)];
    [self.navigationItem setRightBarButtonItem:editButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
}

#pragma mark - IBActions

-(IBAction) editButton:(id)sender
{
    self.editing=!self.editing;
}

#pragma mark - UITableView delegate

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_objects count];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *department = [_objects objectAtIndex:section];
    NSArray *employees = department[@"employees"];
    return [employees count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];

    // Configure the cell...
    NSDictionary *department = [_objects objectAtIndex:indexPath.section];
    NSArray *employees = department[@"employees"];
    NSString *employeeName = [employees objectAtIndex:indexPath.row];
    cell.textLabel.text = employeeName;

    return cell;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *department = [_objects objectAtIndex:section];
    return department[@"name"];
}

- (BOOL) tableView: (UITableView *) tableView canEditRowAtIndexPath: (NSIndexPath *) indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if( fromIndexPath == toIndexPath ) return;

    NSDictionary *department = [_objects objectAtIndex:fromIndexPath.section];
    NSArray *employees = department[@"employees"];
    NSString *employeeName = [employees objectAtIndex:fromIndexPath.row];

    [self.tableView beginUpdates];
    [_objects removeObjectAtIndex:fromIndexPath.row];
    [_objects insertObject:employeeName atIndex:toIndexPath.row];
    [self.tableView endUpdates];

    [tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    if (indexPath.section == 1 && [_objects count] > 1)
    {
        return YES;
    }
    return NO;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [_objects removeObjectAtIndex:indexPath.row];
        NSArray *rows = [NSArray arrayWithObject:indexPath];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];

    }
}



@end
