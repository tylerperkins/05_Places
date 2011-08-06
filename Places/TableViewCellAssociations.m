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
@property (assign,nonatomic) NSInteger       cellTagCount;
@property (readonly)         NSMutableArray* associates;
@property (readonly)         NSString*       reuseIdentifier;
@end

@implementation TableViewCellAssociations


@synthesize tableView = _tableView;
@synthesize cellTagCount = _cellTagCount;
@synthesize associates = _associates;
@synthesize reuseIdentifier = _reuseIdentifier;


- (id) initWithTableView:(UITableView*)tableView {
    self = [super init];
    if ( self ) {
        self.tableView = tableView;
        _associates = [NSMutableArray new];
        self.cellTagCount = 0;

        //  NSObject's description method, which we inherit, is unique for each
        //  instance, e.g. "<TableViewCellAssociations: 0x4e62f80>". We use it
        //  to reuse the cells.
        _reuseIdentifier = [[self description] retain];
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



- (id) associateForIndexPath:(NSIndexPath*)indexPath {
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    return  cell  ?  [self.associates objectAtIndex:cell.tag]  :  nil;
}


- (id) associateForSelectedCell {
    return  [self
        associateForIndexPath:[self.tableView indexPathForSelectedRow]
    ];
}


@end
