//
//  RecentsTableViewController.h
//  Places
//
//  Created by Tyler Perkins on 2011-06-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecentsModel.h"
#import "PhotoViewController.h"

/*  This class manages the pictures recently viewed by the user. It presents
    them in a UITableView, listed with the most recent at the top. Tapping
    the Edit button taking the cells into edit mode, allowing the user to
    delete any cell. The user can also swipe a cell to the left to put it into
    edit mode.
*/
@interface RecentsTableViewController : UITableViewController {}

@property (nonatomic,retain) IBOutlet RecentsModel*        recentsModel;
@property (nonatomic,retain) IBOutlet PhotoViewController* photoViewController;

- (IBAction) editButtonTouched:(id)sender;

@end
