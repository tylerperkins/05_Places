//
//  RecentsModel.m
//  Places
//
//  Created by Tyler Perkins on 2011-07-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RecentsModel.h"

static NSInteger const MaxRecents = 25;

@interface RecentsModel ()
@property (readonly)         NSMutableSet*     recents;
@property (retain,nonatomic) NSMutableArray*   recentsSorted;
@property (readonly)         NSArray*          byLastViewed;
@end


@implementation RecentsModel


@synthesize recents = _recents;
@synthesize recentsSorted = _recentsSorted;
@synthesize byLastViewed = _byLastViewed;


- (id)init {
    self = [super init];
    if (self) {
        _recents = [[NSMutableSet alloc] initWithCapacity:MaxRecents];
        self.recentsSorted = nil;    // Lazily built in recentsSorted.

        //  Make a singleton array wrapping an NSSortDescriptor for the
        //  sortedArrayUsingDescriptors: call below.
        NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
            initWithKey:@"lastViewed"
              ascending:NO
        ];
        _byLastViewed = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [sortDescriptor release];
    }
    return self;
}


- (void) dealloc {
    [_recents release];
    [_recentsSorted release];
    [_byLastViewed release];
    [super dealloc];
}


- (void) didViewPicticulars:(Picticulars*)pic {
    pic.lastViewed = [NSDate date];
    
    //  If a different Picticulars object representing the same image (URL)
    //  already exists, replace it with pic, which has its lastViewed updated.
    //  (Picticulars are distinguished only by their url properties. Without
    //  removing the old Picticulars, the recents mutable set would hang on to
    //  it and ignore the new pic.)
    [self.recents removeObject:pic];
    [self.recents addObject:pic];
    
    //  We added a new pic, even if only its lastViewed property has changed.
    //  The array of sorted Picticulars is likely to be invalid.
    self.recentsSorted = nil;
}


- (void) didDeletePicticulars:(Picticulars*)pic {
    [self.recents removeObject:pic];
    
    //  The array of sorted Picticulars is invalid.
    self.recentsSorted = nil;
}


- (NSInteger) count {
    //  We need to count the elements in self.recentsSorted, not self.recents
    //  because the latter may have elements that will be trimmed off when the
    //  recentsSorted getter is called.
    return  [self.recentsSorted count];
}


- (Picticulars*) picticularsAtIndexpath:(NSIndexPath*)indexPath {
    return  [self.recentsSorted objectAtIndex:indexPath.row];
}


#pragma mark - Explicit accessors


/*  Returns an array of Picticulars objects sorted in decreasing order by
 their lastViewed dates (newest first). If the recentsSorted property
 is currently nil, a new array is created from the objects in self.recents.
 If there are more than MaxRecents such objects, the oldest (in terms of
 property lastViewed) are removed from the array and from self.recents,
 leaving exactly MaxRecents elements in each of these collections.
 */
- (NSArray*) recentsSorted {
    if ( ! _recentsSorted ) {

        //  Create a new mutable array of Picticulars sorted by their
        //  dateLastViewed properties.
        self.recentsSorted = [[self.recents
            sortedArrayUsingDescriptors:self.byLastViewed
        ] mutableCopy];            // mutableCopy returns a retained object.
        [_recentsSorted release];  // <-- Since setRecentsSorted: does retain.
        
        //  If the new _recentsSorted has more than MaxRecents elements, then
        //  remove the extras. This is the only reason _recentsSorted must be
        //  mutable.
        while ( [_recentsSorted count] > MaxRecents ) {
            [self.recents removeObject:[_recentsSorted lastObject]];
            [_recentsSorted removeLastObject];
        }
    }
    return  _recentsSorted;
}


#pragma mark - Implementation of protocol SavesAndRestoresDefaults


- (void) saveToUserDefaults:(NSUserDefaults*)defaults {
    NSMutableArray* arr = [NSMutableArray
                           arrayWithCapacity:[self.recentsSorted count]
                           ];
    
    for ( Picticulars* pic in self.recentsSorted ) {
        NSDictionary* dict = [pic newDictionary];
        [arr addObject:dict];
        [dict release];
    }
    
    [defaults setObject:arr forKey:defaultKey(Recents)];
}


- (void) restoreFromUserDefaults:(NSUserDefaults*)defaults {
    [self.recents removeAllObjects];
    self.recentsSorted = nil;
    
    //  Create new Picticulars to save in self.recents. Note that if there
    //  are no Recents defaults, [defaults objectForKey:...] will be nil, and
    //  there will be no iterations, as desired.
    for ( NSDictionary* d in [defaults objectForKey:defaultKey(Recents)] ) {
        Picticulars* pic = [[Picticulars alloc] initFromDictionary:d];
        [self.recents addObject:pic];
        [pic release];
    }
}


@end
