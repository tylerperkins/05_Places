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


@interface MostViewedTableViewController : UITableViewController {}


@property (nonatomic,retain) IBOutlet FlickrModel*         flickrModel;
@property (nonatomic,retain) IBOutlet RecentsModel*        recentsModel;
@property (nonatomic,retain) IBOutlet PhotoViewController* photoViewController;
@property (nonatomic,retain)          NSString*            placeId;
@property (assign,nonatomic) BOOL                          placeIdDidChange;

@end
