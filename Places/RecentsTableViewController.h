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

/*  This class' single instance is assigned in Interface Builder. It manages
    the pictures recently viewed by the user, listing them in a UITableView
    with the most recently viewed at the top. Tapping the button puts all
    cells into edit mode, allowing the user to delete cells. The user can also
    swipe a single cell to the left or right to put it into edit mode.
*/
@interface RecentsTableViewController : UITableViewController
<UITableViewDataSource,UITableViewDelegate>
{}

@property (nonatomic,retain) IBOutlet RecentsModel*        recentsModel;
@property (nonatomic,retain) IBOutlet PhotoViewController* photoViewController;

/*  The Edit button toggles its title between "Edit" and "Done". When "Edit"
    is touched, we go into edit mode. When "Done" is touched, we go back into
    non-editing mode.
*/
- (IBAction) editButtonTouched:(id)sender;

@end
