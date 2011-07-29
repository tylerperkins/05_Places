//
//  MostViewedTableViewController.h
//  Places
//
//  Created by Tyler Perkins on 2011-06-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrModel.h"
#import "RecentsModel.h"
#import "PhotoViewController.h"

/*  This class has a single instance assigned in Interface Builder. It manages
    a UITableView of picture names/descriptions, all at the place selected in
    the PlacesTableViewController which pushed it. When the user touches a row,
    a PhotoViewController is pushed onscreen, which downloads the corresponding
    image from Flickr and displays it.
*/
@interface MostViewedTableViewController : UITableViewController {}

@property (retain,nonatomic) IBOutlet FlickrModel*         flickrModel;
@property (retain,nonatomic) IBOutlet RecentsModel*        recentsModel;
@property (retain,nonatomic) IBOutlet PhotoViewController* photoViewController;
@property (retain,nonatomic)          PlaceInfo*           placeInfo;
@property (assign,nonatomic)          BOOL                 placeInfoDidChange;

@end
