//
//  RecentsTableViewController.h
//  Places
//
//  Created by Tyler Perkins on 2011-06-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrModel.h"
#import "PhotoViewController.h"

@interface RecentsTableViewController : UITableViewController {}

@property (nonatomic,retain) IBOutlet FlickrModel*         flickrModel;
@property (nonatomic,retain) IBOutlet PhotoViewController* photoViewController;

@end
