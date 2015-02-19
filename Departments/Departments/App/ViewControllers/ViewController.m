//
//  ViewController.m
//  Departments
//
//  Created by Amarjit on 18/02/2015.
//  Copyright (c) 2015 Amarjit. All rights reserved.
//

#import "ViewController.h"
#import "Employee.h"
#import "Department.h"

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *objects;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Departments";

    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.allowsSelectionDuringEditing = YES;

    _objects = [NSMutableArray array];

    Employee *mike = [[Employee alloc] initWithName:@"Mike"];
    Employee *sarah = [[Employee alloc] initWithName:@"Sarah"];
    Employee *harold = [[Employee alloc] initWithName:@"Helen"];
    Employee *simmons = [[Employee alloc] initWithName:@"Simmons"];
    Employee *nathan = [[Employee alloc] initWithName:@"Nathan"];

    Department *sales = [[Department alloc] init];
    sales.name = @"Sales";
    sales.employees = [NSMutableArray arrayWithObjects:mike,sarah,harold, nil];
    [_objects addObject:sales];

    Department *marketing = [[Department alloc] init];
    marketing.name = @"Marketing";
    marketing.employees = [NSMutableArray arrayWithObjects:simmons, nathan, nil];
    [_objects addObject:marketing];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    [self.tableView setEditing:!self.editing animated:YES];
}

#pragma mark - UITableView delegate

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_objects count];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Department *department = [_objects objectAtIndex:section];
    return [department.employees count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId" forIndexPath:indexPath];

    // Configure the cell...
    Department *department = [_objects objectAtIndex:indexPath.section];
    Employee *employee = [department.employees objectAtIndex:indexPath.row];
    cell.textLabel.text = employee.name;

    return cell;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    Department *department = [_objects objectAtIndex:section];
    return department.name;
}

- (BOOL) tableView: (UITableView *) tableView canEditRowAtIndexPath: (NSIndexPath *) indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if (fromIndexPath == toIndexPath ) return;

    Department *department = [_objects objectAtIndex:fromIndexPath.section];
    Employee *employee = [department.employees objectAtIndex:fromIndexPath.row];

    [self.tableView beginUpdates];

    [_objects removeObjectAtIndex:fromIndexPath.row];
    [_objects insertObject:employee atIndex:toIndexPath.row];
    [self.tableView endUpdates];

    [tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [[_objects objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
        NSArray *rows = [NSArray arrayWithObject:indexPath];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}



@end
