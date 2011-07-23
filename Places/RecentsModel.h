//
//  RecentsModel.h
//  Places
//
//  Created by Tyler Perkins on 2011-07-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SavesAndRestoresDefaults.h"
#import "Picticulars.h"

@interface RecentsModel : NSObject<SavesAndRestoresDefaults> {}

- (void) didViewPicticulars:(Picticulars*)pic;
- (void) didDeletePicticulars:(Picticulars*)pic;
- (NSInteger) countOfRecents;
- (Picticulars*) recentPicticularsAtIndexpath:(NSIndexPath*)indexPath;

@end
