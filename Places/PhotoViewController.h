//
//  PhotoViewController.h
//  Places
//
//  Created by Tyler Perkins on 2011-06-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Picticulars.h"
#import "FlickrModel.h"

/*  This class has two instances assigned in Interface Builder: one used by the MostViewedTableViewController and one used by the
    RecentsTableViewController. It manages the downloading, display, scrolling,
    and zooming of a single Flickr picture. It also displays the spinning
    network activity indicator in the status bar at the top of the screen
    while a picture is being downloaded. Whenever this view controller's view
    is displayed, it checks to see if the requested URL has changed. If not, no
    downloading is done, and the existing picture is shown.
*/
@interface PhotoViewController : UIViewController<UIScrollViewDelegate> {}

@property (nonatomic,retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic,retain) IBOutlet FlickrModel*  flickrModel;
@property (nonatomic,retain)          Picticulars*  picticulars;

@end
