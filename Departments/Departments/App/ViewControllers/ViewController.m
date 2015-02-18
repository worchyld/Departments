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

    _objects = [NSMutableArray array];

    NSDictionary *sales = @{ @"name" : @"sales",
                             @"employees" : @[ @"Mike", @"Tom", @"Alex"] };

    NSDictionary *marketing = @{ @"name" : @"marketing",
                             @"employees" : @[ @"Heather", @"Richard", @"Simon"] };

    [_objects addObject:sales];
    [_objects addObject:marketing];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

@end
