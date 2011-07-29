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
@property (assign,nonatomic) TableViewCellAssociations* cellAssociations;
- (void) pushPhotoViewController;
@end


@implementation MostViewedTableViewController


@synthesize flickrModel = _flickrModel;
@synthesize recentsModel = _recentsModel;
@synthesize photoViewController = _photoViewController;
@synthesize placeInfo = _placeInfo;
@synthesize placeInfoDidChange = _placeInfoDidChange;
@synthesize cellAssociations = _cellAssociations;


- (void) awakeFromNib {
    [super awakeFromNib];
    self.cellAssociations = [[TableViewCellAssociations alloc]
        initWithTableView:self.tableView
    ];
}


- (void) dealloc {
    [_flickrModel release];
    [_recentsModel release];
    [_photoViewController release];
    [_placeInfo release];
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

    if ( self.placeInfoDidChange ) {
        //  We're not just going back to the same list, so get new photo data.
        [self.tableView reloadData];

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

        //  Next time, don't reloadData, etc.
        self.placeInfoDidChange = NO;
    }
}


- (BOOL) shouldAutorotateToInterfaceOrientation:
    (UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark - Explicit accessors


- (void) setPlaceInfo:(PlaceInfo*)placeInfo {
    self.placeInfoDidChange = placeInfo.placeId != _placeInfo.placeId;
    if ( self.placeInfoDidChange ) {
        [_placeInfo release];
        _placeInfo = [placeInfo retain];
    }
}


#pragma mark - Table view data source


- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView {
    return 1;
}


- (NSInteger) tableView:(UITableView*)tableView
  numberOfRowsInSection:(NSInteger)section
{
    return [self.flickrModel numberOfImagesForPlaceId:self.placeInfo.placeId];
}


- (UITableViewCell *) tableView:(UITableView*)tableView
          cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    //  Retrieve the data for the current place and given indexPath,
    //  wrapped in a Picticulars data object.
    Picticulars* pic = [self.flickrModel
        newPicticularsForPlaceId:self.placeInfo.placeId
                     atIndexPath:indexPath
    ];

    //  Obtain a new or reused cell and associate it with the Picticulars at
    //  indexPath.
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
    //  Since the user selected it, the cell is on screen, and so has a
    //  Picticulars instance associated with the cell's tag.
    Picticulars* pic = [self.cellAssociations associateForSelectedCell];
    self.photoViewController.picticulars = pic;

    //  Tell the model that this pic was viewed so it can save it in recents.
    [self.recentsModel didViewPicticulars:pic];
    
    //  Put the title of the selected cell into the nav controller's
    //  navigation item (near the top of the screen).
    self.photoViewController.navigationItem.title = [tableView
        cellForRowAtIndexPath:indexPath
    ].textLabel.text;

    //  Navigate to the PhotoViewController and show the image, but only after
    //  we allow time to turn on the network activity indicator.
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
