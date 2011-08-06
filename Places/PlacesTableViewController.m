//
//  PlacesTableViewController.m
//  Places
//
//  Created by Tyler Perkins on 2011-06-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlacesTableViewController.h"
#import "FlickrModel.h"
#import "TableViewCellAssociations.h"


@interface PlacesTableViewController ()
@property (readonly) TableViewCellAssociations* cellAssociations;
- (void) populate;
- (void) pushMostViewedTableViewController;
@end


@implementation PlacesTableViewController


@synthesize flickrModel = _flickrModel;
@synthesize mostViewedTableViewController = _mostViewedTableViewController;
@synthesize cellAssociations = _cellAssociations;


- (void) awakeFromNib {
    [super awakeFromNib];
    _cellAssociations = [[TableViewCellAssociations alloc]
        initWithTableView:self.tableView
    ];
}


- (void)dealloc {
    [_cellAssociations release];
    [super dealloc];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //  Load new places data, but only after we allow time for the network
    //  activity indicator to show. Meanwhile, old table rows are displayed.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self performSelector:@selector(populate)
               withObject:nil
               afterDelay:0.05    // Wait at least 50 msec.
    ];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:
    (UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return  [self.flickrModel.countriesSorted count];
}


/*  Provides the title for each section. If this method is not implemented,
    no sections will appear.
*/
- (NSString*)   tableView:(UITableView *)tableView
  titleForHeaderInSection:(NSInteger)sectionIndex
{
    return  [self.flickrModel.countriesSorted objectAtIndex:sectionIndex];
}


/*  Provides the list of titles to appear in the section index on the right
    side of the screen. If this method is not implemented, no section index
    will be shown.
*/
- (NSArray*) sectionIndexTitlesForTableView:(UITableView *)tableView {
    return  self.flickrModel.countriesSorted;
}


- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)sectionIndex
{
    //  Return the number of rows in the section.
    return [self.flickrModel
        numberOfPlacesForCountry:[self.flickrModel.countriesSorted
            objectAtIndex:sectionIndex
        ]
    ];
}


- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    PlaceInfo* info = [self.flickrModel placeInfoAtIndexPath:indexPath];

    //  Obtain a new or reused cell and associate it with the PlaceInfo at
    //  indexPath.
    UITableViewCell* cell = [self.cellAssociations
        cellToAssociateWithObject:info
    ];

    //  Decorate the cell.
    cell.textLabel.text = info.city;
    cell.detailTextLabel.text = info.fullState;
    
    return cell;
}


#pragma mark - Implementation of protocol UITableViewDelegate


- (void)          tableView:(UITableView*)tableView
    didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    //  Since the user selected it, the cell is on screen, and so has a
    //  PlaceInfo object associated with the cell's tag.
    self.mostViewedTableViewController.placeInfo = [self.cellAssociations
        associateForSelectedCell
    ];

    self.mostViewedTableViewController.navigationItem.title = [tableView
        cellForRowAtIndexPath:indexPath
    ].textLabel.text;

    if ( self.mostViewedTableViewController.placeInfoDidChange ) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    [self performSelector:@selector(pushMostViewedTableViewController)
               withObject:nil
               afterDelay:0.05       // Wait at least 50 msec.
    ];
}


#pragma mark - Private methods and functions


/*  Method used to postpone downloading places data and repopulating this
    tableView until after the network activity indicator has had a chance to
    display.
*/
- (void) populate {
    [self.flickrModel refresh];
    [self.tableView reloadData];

    //  All done. Turn off the indicator.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


/*  Method used to postpone pushing the MostViewedViewController until after
    the network activity indicator has had a chance to display.
 */
- (void) pushMostViewedTableViewController {
    
    [self.navigationController
        pushViewController:self.mostViewedTableViewController
                  animated:YES
    ];

    //  All done. Turn off the indicator.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

     
@end
