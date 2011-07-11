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


@interface PlacesTableViewController : UITableViewController {}

@property (retain,nonatomic) IBOutlet FlickrModel* flickrModel;
@property (retain,nonatomic)
    IBOutlet MostViewedTableViewController* mostViewedTableViewController;
@end
