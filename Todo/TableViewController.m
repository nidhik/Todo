//
//  TableViewController.m
//  Todo
//
//  Created by Nidhi Kulkarni on 10/12/13.
//  Copyright (c) 2013 Nidhi Kulkarni. All rights reserved.
//

#import "TableViewController.h"
#import "CustomCell.h"
#import <objc/runtime.h>

static const char * indexPathForCustomCell = "something";

@interface TableViewController ()

@property (nonatomic, strong) NSMutableArray *tasks;
@property (nonatomic, strong) UIBarButtonItem *addButton;
@property (nonatomic, assign) int num;

@end

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.tasks = [[NSMutableArray alloc] init];
        self.num = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *customNib = [UINib nibWithNibName:@"CustomCell" bundle:nil];
    [self.tableView registerNib:customNib forCellReuseIdentifier:@"CustomCell"];
    self.title = @"ToDo";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTask)];
    
    self.navigationItem.rightBarButtonItem = self.addButton;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    [self.tableView reloadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

-(IBAction) addTask {
    self.num++;
    [self.tasks addObject:[NSString stringWithFormat:@"NEW %d", self.num]];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCell";
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textField.text = [self.tasks objectAtIndex:indexPath.row];
    
    cell.textField.delegate = self;
    
    
    objc_setAssociatedObject(cell.textField, indexPathForCustomCell, indexPath , OBJC_ASSOCIATION_RETAIN);
    NSLog(@"%@",indexPath);
    return cell;
}

#pragma mark - UITextFieldDelegate methods


- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target:self action:@selector(onDoneButton)];
    
    return YES;
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField {
    NSIndexPath *indexPath = objc_getAssociatedObject(textField, indexPathForCustomCell);
    self.tasks[indexPath.row] = textField.text;
    return YES;
}

- (void) onDoneButton {
    self.navigationItem.rightBarButtonItem = self.addButton;
    [self.view endEditing:YES];
}

#pragma mark - UITableViewDelegate methods

//
//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSArray *paths = [[NSArray alloc] initWithObjects: indexPath, nil];
//    [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone ];
//    [self.tableView reloadData];
//    return indexPath;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.tasks removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSObject *task = self.tasks[fromIndexPath.row];
    [self.tasks removeObjectAtIndex:fromIndexPath.row];
    [self.tasks insertObject:task atIndex:toIndexPath.row];
    
    [tableView reloadData];
}


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
