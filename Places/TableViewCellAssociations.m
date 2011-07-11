//
//  TableViewCellAssociations.m
//  Places
//
//  Created by Tyler Perkins on 2011-07-01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableViewCellAssociations.h"


@interface TableViewCellAssociations ()
@property (retain,nonatomic) UITableView*    tableView;
@property (retain,nonatomic) NSMutableArray* associates;
@property (assign,nonatomic) NSInteger       cellTagCount;
@property (retain,nonatomic) NSString*       reuseIdentifier;
@end

@implementation TableViewCellAssociations


@synthesize tableView=_tableView;
@synthesize associates=_associates;
@synthesize cellTagCount=_cellTagCount;
@synthesize reuseIdentifier=_reuseIdentifier;


- (id) initWithTableView:(UITableView*)tableView {
    self = [super init];
    if ( self ) {
        self.tableView = tableView;
        self.associates = [NSMutableArray new];
        self.cellTagCount = 0;

        //  Object's description method, which we inherit, is unique for each
        //  instance, e.g. "<TableViewCellAssociations: 0x4e62f80>". We use it
        //  to help the table view manage its cells.
        self.reuseIdentifier = [self description];
    }
    return self;
}


- (void) dealloc {
    [_tableView release];
    [_associates release];
    [_reuseIdentifier release];
    [super dealloc];
}


- (UITableViewCell*) cellToAssociateWithObject:(id)obj {

    UITableViewCell* cell = [self.tableView
        dequeueReusableCellWithIdentifier:self.reuseIdentifier
    ];

    if ( ! cell ) {
        cell = [[[UITableViewCell alloc]
            initWithStyle:UITableViewCellStyleSubtitle
            reuseIdentifier:self.reuseIdentifier
        ] autorelease];
        
        //  Pair the cell with the associates index using its tag property.
        cell.tag = self.cellTagCount;
        self.cellTagCount += 1;

        //  Make room for an associate object. Actual object assigned below.
        [self.associates addObject:[NSNull null]];
    }

    //  Remember the object to be associated with the cell.
    [self.associates replaceObjectAtIndex:cell.tag withObject:obj];

    return cell;
}


- (id) associateForSelectedCell {
    return  [self.associates
        objectAtIndex:[self.tableView
            cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]
        ].tag
    ];
}


@end
