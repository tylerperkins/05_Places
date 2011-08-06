//
//  RecentsModel.h
//  Places
//
//  Created by Tyler Perkins on 2011-07-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SavesAndRestoresDefaults.h"
#import "Picticulars.h"

/*  This class' single instance is assigned in Interface Builder. It is
    responsible for managing an ordered set of Picticulars of viewed pictures,
    each containing the title, description, url, and the date/time its picture
    was last viewed via the MostViewedTableViewController. They are ordered
    from most-recently to least-recently viewed, and at most only the most
    recent 25 Picticulars objects are stored. This class allows the user to
    delete Picticulars from the set, and it automatically saves and restores
    the state of the set when the user quits and restarts the program.

    Note that since each Picticulars object is identified solely by its url
    property, and since it is stored in a set, a picture viewed twice only
    appears once in the set, and will move to the head of the list if it isn't
    there already. (The RecentsTableViewController does not call
    didViewPicticulars:, so the act of viewing a recent picture there does not
    change its position in the list.)
*/
@interface RecentsModel : NSObject<SavesAndRestoresDefaults> {}

- (void) didViewPicticulars:(Picticulars*)pic;
- (void) didDeletePicticulars:(Picticulars*)pic;
- (NSInteger) count;
- (Picticulars*) picticularsAtIndexpath:(NSIndexPath*)indexPath;

@end
