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
@property (retain,nonatomic) TableViewCellAssociations* cellAssociations;
- (void) populate;
@end


@implementation PlacesTableViewController


@synthesize flickrModel=_flickrModel;
@synthesize mostViewedTableViewController=_mostViewedTableViewController;
@synthesize cellAssociations=_cellAssociations;


- (void) awakeFromNib {
    [super awakeFromNib];
    self.cellAssociations = [[TableViewCellAssociations alloc]
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

    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    [self performSelector:@selector(populate)
               withObject:nil
               afterDelay:0.05
    ];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:
    (UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section
{
    //  Return the number of rows in the section.
    return [self.flickrModel numberOfPlaces];
}


- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    //  Get a new or reused cell and associate it with the place_id for the
    //  selected cell.
    UITableViewCell* cell = [self.cellAssociations
        cellToAssociateWithObject:[
            self.flickrModel placeDataForKey:@"place_id"
                                 atIndexPath:indexPath
        ]
    ];

    cell.textLabel.text = [self.flickrModel cityAtIndexPath:indexPath];
    cell.detailTextLabel.text = [self.flickrModel
        fullStateAtIndexPath:indexPath
    ];
    
    return cell;
}


#pragma mark - Implementation of protocol UITableViewDelegate


- (void)          tableView:(UITableView*)tableView
    didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    //  Since the user selected it, the cell is visible, and so has an
    //  placeId value associated with the cell's tag.
    self.mostViewedTableViewController.placeId = [self.cellAssociations
        associateForSelectedCell
    ];

    self.mostViewedTableViewController.navigationItem.title = [tableView
        cellForRowAtIndexPath:indexPath
    ].textLabel.text;

    [self.navigationController
        pushViewController:self.mostViewedTableViewController
                  animated:YES
    ];
}


#pragma mark - Private methods and functions


- (void) populate {
    [self.flickrModel refresh];
    [self.tableView reloadData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

     
@end
