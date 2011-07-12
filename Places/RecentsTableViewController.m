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
@property (retain,nonatomic) TableViewCellAssociations* cellAssociations;
- (void) pushPhotoViewController;
@end


@implementation RecentsTableViewController


@synthesize flickrModel=_flickrModel;
@synthesize photoViewController=_photoViewController;
@synthesize cellAssociations=_cellAssociations;


- (void) awakeFromNib {
    [super awakeFromNib];
    self.cellAssociations = [[TableViewCellAssociations alloc]
        initWithTableView:self.tableView
    ];
}


- (void) dealloc {
    [_flickrModel release];
    [_photoViewController release];
    [_cellAssociations release];
    [super dealloc];
}


- (void) didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
    return  [self.flickrModel countOfRecents];
}


- (UITableViewCell*) tableView:(UITableView*)tableView
         cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    //  Retrieve the data for the current place and specified index, wrapped
    //  in a Picticulars data object.
    Picticulars* pic = [self.flickrModel
        recentPicticularsAtIndexpath:indexPath
    ];
    
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
    
    //  Navigate to the PhotoViewController and view the image, but only after
    //  we allow time for the network activity indicator to show.
    if ( self.photoViewController.picticularsDidChange ) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    [self performSelector:@selector(pushPhotoViewController)
               withObject:nil
               afterDelay:0.05
    ];
}


#pragma mark - Private methods and functions


/*  Method used to postpone pushing the PhotoViewController until after the
 network activity indicator has a chance to display.
 */
- (void) pushPhotoViewController {
    [self.navigationController
        pushViewController:self.photoViewController
                  animated:YES
    ];
    
    //  All done. Turn off the indicator.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


@end
