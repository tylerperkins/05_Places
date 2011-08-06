//
//  PlacesTableViewController.h
//  Places
//
//  Created by Tyler Perkins on 2011-06-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrModel.h"
#import "MostViewedTableViewController.h"


/*  This class' single instance is assigned in Interface Builder. It manages
    a UITableView of "places", supplied by Flickr, of most-viewed pictures. It
    is the user's starting point in the application. The list is sectioned
    alphabetically by country, then by city within each section. A section
    index also appears on the right side of the screen listing all the
    countries. Selecting a place by touching a row takes the user to the
    MostViewedTableViewController, where pictures are listed for that place.
*/
@interface PlacesTableViewController : UITableViewController
<UITableViewDataSource,UITableViewDelegate>
{}

@property (retain,nonatomic) IBOutlet FlickrModel* flickrModel;
@property (retain,nonatomic)
    IBOutlet MostViewedTableViewController* mostViewedTableViewController;
@end
