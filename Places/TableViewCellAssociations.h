//
//  TableViewCellAssociations.h
//  Places
//
//  Created by Tyler Perkins on 2011-07-01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


/*  This class collaborates with the UITableView managed by your UITableViewController subclass. It keeps track of a list of arbitrary
    objects, each associated with a UITableViewCell currently being displayed.
    In your UITableViewDataSource implmentation's
    tableView:cellForRowAtIndexPath: method, obtain the cell you will return by
    calling this class' cellToAssociateWithObject: method, providing the object
    you would like to associate with that cell. Decorate the cell as usual by
    modifying its label or type properties, etc., then return it.

    This cell may be new or recycled, since method cellToAssociateWithObject:
    first makes use of TableView's dequeueReusableCellWithIdentifier: method to
    try to reuse a cached cell. If it can't, a new cell is returned. In either
    case, the cell's tag property is used to hold the index of the associated
    object in an array that caches the objects associated with the displayed
    cells.
 
    Note that a TableViewCellAssociations instance only stores as many
    associated objects as there are cells that are visible. This is because,
    like the various cell properties that must be assigned in every call to
    tableView:cellForRowAtIndexPath:, method cellToAssociateWithObject: must
    be called too. If the cell it returns was returned previously, the object
    previously associated with it is replaced by the argument.

    Since all displayed cells are obtained this way, when the user selects one
    of them, you can obtain its associated object. In the TableViewController's
    subclass' tableView:didSelectRowAtIndexPath:, just call this class'
    associateForSelectedCell method.
*/
@interface TableViewCellAssociations : NSObject {}

/*  Initializes the receiver for use by the given UITableView.
*/
- (id) initWithTableView:(UITableView*)tableView;

/*  Returns a UITableViewCell to which the given object is associated. The cell
    returned will have been used before if one is available, otherwise a
    newly instantiated cell will be returned. The connection between the cell
    and its object is maintained via the cell's tag property (in UIView), which
    is an NSInteger. Thus, you must not modify the tag property of your cells.
*/
- (UITableViewCell*) cellToAssociateWithObject:(id)obj;

/*  Looks up the object associated with the UITableViewCell in the receiver's
    UITableView at the given NSIndexPath. The cell at that index path must be
    visible or nil is returned.
*/
- (id) associateForIndexPath:(NSIndexPath*)indexPath;

/*  Looks up the object associated with the currently selected cell in the receiver's UITableView. (The cell is selected, so it is visible.) If no
    cell is currently selected, nil is returned.
*/
- (id) associateForSelectedCell;

@end
