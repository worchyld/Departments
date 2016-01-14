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

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    if (!_objects) _objects = [self objects];

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableView addGestureRecognizer:longPress];
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

-(NSMutableArray *) objects
{
    if (!_objects) {
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
    }

    return _objects;
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
    if (fromIndexPath != toIndexPath )
    {
        Department *departmentFrom = [_objects objectAtIndex:fromIndexPath.section];
        Department *departmentTo = [_objects objectAtIndex:toIndexPath.section];

        [tableView beginUpdates];
        Employee *employee = [departmentFrom.employees objectAtIndex:fromIndexPath.row];
        [departmentFrom.employees removeObjectAtIndex:fromIndexPath.row];
        [departmentTo.employees insertObject:employee atIndex:toIndexPath.row];
        [tableView endUpdates];
        [tableView reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}


- (IBAction)longPressGestureRecognized:(id)sender
{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;

    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];

    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.

    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;

                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];

                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{

                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;

                } completion:^(BOOL finished) {

                    cell.hidden = YES;

                }];
            }
            break;
        }

        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            center.x = location.x;
            snapshot.center = center;

            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath])
            {
                Department *departmentFrom = [_objects objectAtIndex:sourceIndexPath.section];
                Department *departmentTo = [_objects objectAtIndex:indexPath.section];

                [self.tableView beginUpdates];

                Employee *employee = [departmentFrom.employees objectAtIndex:sourceIndexPath.row];
                [departmentFrom.employees removeObjectAtIndex:sourceIndexPath.row];
                [departmentTo.employees insertObject:employee atIndex:indexPath.row];

                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];

                [self.tableView endUpdates];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }

        default: {
            // Clean up.
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;

            [UIView animateWithDuration:0.25 animations:^{

                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;

            } completion:^(BOOL finished) {

                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;

            }];

            break;
        }
    }
}

#pragma mark - Helper methods

/** @brief Returns a customized snapshot of a given view. */
- (UIView *)customSnapshoFromView:(UIView *)inputView {

    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}


@end
