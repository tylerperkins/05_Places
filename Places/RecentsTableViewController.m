//
//  RecentsTableViewController.m
//  Places
//
//  Created by Tyler Perkins on 2011-06-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RecentsTableViewController.h"
#import "TableViewCellAssociations.h"

@interface RecentsTableViewController ()
@property (readonly) TableViewCellAssociations* cellAssociations;
@end


@implementation RecentsTableViewController


@synthesize recentsModel = _recentsModel;
@synthesize photoViewController = _photoViewController;
@synthesize cellAssociations = _cellAssociations;


- (void) awakeFromNib {
    [super awakeFromNib];
    _cellAssociations = [[TableViewCellAssociations alloc]
        initWithTableView:self.tableView
    ];
}


- (void) dealloc {
    [_recentsModel release];
    [_photoViewController release];
    [_cellAssociations release];
    [super dealloc];
}


- (void) didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (IBAction) editButtonTouched:(UIBarButtonItem*)sender {
    BOOL goIntoEditMode = [sender.title isEqual:@"Edit"];
    [self.tableView setEditing:goIntoEditMode animated:YES];
    sender.title = goIntoEditMode ? @"Done" : @"Edit";
    sender.style = goIntoEditMode
    ?   UIBarButtonItemStyleDone
    :   UIBarButtonItemStylePlain;
}


#pragma mark - View lifecycle


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (BOOL) shouldAutorotateToInterfaceOrientation:
  (UIInterfaceOrientation)interfaceOrientation
{
    return  YES;
}


#pragma mark - Table view data source


- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView {
    return  1;
}


- (NSInteger) tableView:(UITableView*)tableView
  numberOfRowsInSection:(NSInteger)section
{
    return  [self.recentsModel count];
}


- (UITableViewCell*) tableView:(UITableView*)tableView
         cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    //  Retrieve the data for the current place and specified index, wrapped
    //  in a Picticulars data object.
    Picticulars* pic = [self.recentsModel picticularsAtIndexpath:indexPath];
    
    //  Get a new or reused cell and associate it with the Picticulars.
    UITableViewCell* cell = [self.cellAssociations
        cellToAssociateWithObject:pic
    ];
    
    //  Decorate the cell.
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = pic.title;
    cell.detailTextLabel.text = pic.subtitle;
    
    return cell;
}


/*  Called when the user changes something in editing mode. Currently, the only
    editing style presented is UITableViewCellEditingStyleDelete. Just tell the
    recentsModel to delete the associated Particulars object and re-construct
    the table.
*/
- (void)   tableView:(UITableView *)tableView
  commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
   forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  No need to check editingStyle, since all the user can do is delete.
    [self.recentsModel
        didDeletePicticulars:[self.cellAssociations
            associateForIndexPath:indexPath
        ]
    ];
    [tableView reloadData];
}


#pragma mark - Table view delegate


- (void)        tableView:(UITableView*)tableView
  didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    //  Since the user selected it, the cell is visible, and so has a
    //  Picticulars instance associated with the cell's tag.
    Picticulars* pic = [self.cellAssociations associateForSelectedCell];
    self.photoViewController.picticulars = pic;
    
    //  Put the title of the selected cell into the nav controller's
    //  navigation item (near the top of the screen).
    self.photoViewController.navigationItem.title = [tableView
        cellForRowAtIndexPath:indexPath
    ].textLabel.text;

    //  Navigate to the PhotoViewController and view the image.
    [self.navigationController
        pushViewController:self.photoViewController
                  animated:YES
    ];
}


@end
