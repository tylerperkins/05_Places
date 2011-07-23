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

@interface RecentsTableViewController : UITableViewController {}

@property (nonatomic,retain) IBOutlet RecentsModel*        recentsModel;
@property (nonatomic,retain) IBOutlet PhotoViewController* photoViewController;

- (IBAction) editButtonTouched:(id)sender;

@end
