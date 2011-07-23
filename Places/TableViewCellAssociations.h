//
//  TableViewCellAssociations.h
//  Places
//
//  Created by Tyler Perkins on 2011-07-01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


/*  This class collaborates with a TableView managed by a TableViewController
    subclass. It keeps track of a list of arbitrary objects, each associated
    with a TableViewCell currently being displayed. In the TableViewController
    subclass' tableView:cellForRowAtIndexPath: method, you obtain a cell by
    calling this class' cellToAssociateWithObject: method, providing the
    object you would like to associate with that cell.
 
    This cell may be new or recycled, since method cellToAssociateWithObject:
    first makes use of TableView's dequeueReusableCellWithIdentifier: method to
    try to reuse a cached cell. If it can't, a new cell is returned. In either
    case, the cell's tag property is used to hold the index of the associated
    object in an array that caches the objects associated with the displayed
    cells.
 
    Since all displayed cells are obtained this way, when the user selects one
    of them, you can obtain its associated object. In the TableViewController's
    subclass' tableView:didSelectRowAtIndexPath:, just call this class'
    associateForSelectedCell method.
*/
@interface TableViewCellAssociations : NSObject {}

- (id) initWithTableView:(UITableView*)tableView;
- (UITableViewCell*) cellToAssociateWithObject:(id)obj;
- (id) associateForIndexPath:(NSIndexPath*)indexPath;
- (id) associateForSelectedCell;

@end
