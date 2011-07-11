//
//  MostViewedTableViewController.m
//  Places
//
//  Created by Tyler Perkins on 2011-06-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MostViewedTableViewController.h"
#import "TableViewCellAssociations.h"


@interface MostViewedTableViewController ()
@property (assign,nonatomic) BOOL                       hasNoRowsYet;
@property (retain,nonatomic) TableViewCellAssociations* cellAssociations;
- (void) populate;
@end


@implementation MostViewedTableViewController


@synthesize flickrModel=_flickrModel;
@synthesize photoViewController=_photoViewController;
@synthesize placeId=_placeId;
@synthesize placeIdDidChange=_placeIdDidChange;
@synthesize hasNoRowsYet=_hasNoRowsYet;
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
    [_placeId release];
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

    if ( self.placeIdDidChange ) {
        //  We're not just going back to the same list, so get photo data.

        self.hasNoRowsYet = YES;
        [self.tableView reloadData];
        self.hasNoRowsYet = NO;

        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
        [self performSelector:@selector(populate)
                   withObject:nil
                   afterDelay:0.05
        ];

        //  Next time, don't reloadData, etc.
        self.placeIdDidChange = NO;
    }
}


- (BOOL) shouldAutorotateToInterfaceOrientation:
    (UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark - Explicit accessors


- (void) setPlaceId:(NSString*)placeId {
    self.placeIdDidChange =  placeId != _placeId;
    if ( self.placeIdDidChange ) {
        [_placeId release];
        _placeId = [placeId retain];
    }
}


#pragma mark - Table view data source


- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView {
    //  Return the number of sections.
    return 1;
}


- (NSInteger) tableView:(UITableView*)tableView
  numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.hasNoRowsYet
    ?    0
    :    [self.flickrModel numberOfImagesForPlaceId:self.placeId];
}


- (UITableViewCell *) tableView:(UITableView*)tableView
          cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    //  Retrieve the data for the current place and specified index, wrapped
    //  in a Picticulars data object.
    Picticulars* pic = [self.flickrModel
        newPicticularsForPlaceId:self.placeId
                     atIndexPath:indexPath
    ];

    //  Get a new or reused cell and associate it with the Picticulars.
    UITableViewCell* cell = [self.cellAssociations
        cellToAssociateWithObject:pic
    ];

    //  Decorate the cell.
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = pic.title;
    cell.detailTextLabel.text = pic.subtitle;

    [pic release];
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

    //  Tell the model that this pic was viewed so it can save it in recents.
    [self.flickrModel didViewPicticulars:pic];
    
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


#pragma mark - Private methods and functions


- (void) populate {
    [self.tableView reloadData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    //  We have a new list, so make sure we're scrolled up to the top.
    NSUInteger indexes[] = {0, 0};    // For IndexPath of top cell.
    [self.tableView
        scrollToRowAtIndexPath:[NSIndexPath
            indexPathWithIndexes:indexes
                          length:2
        ]
              atScrollPosition:UITableViewScrollPositionTop
                      animated:NO
    ];
}


@end
