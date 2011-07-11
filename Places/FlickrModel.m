//
//  FlickrModel.m
//  Places
//
//  Created by Tyler Perkins on 2011-06-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlickrModel.h"
#import "FlickrFetcher.h"
#import "NSString+Utils.h"

static NSInteger const MaxRecents = 25;

@interface FlickrModel ()
@property (retain,nonatomic) NSArray*         placePlist;
@property (retain,nonatomic) NSArray*         imageInfos;
@property (retain,nonatomic) NSString*        latestPlaceId;
@property (retain,nonatomic) NSMutableSet*    recents;
@property (retain,nonatomic) NSMutableArray*  recentsSorted;
- (NSArray*) placeAtIndexPath:(NSIndexPath*)idxPath;
- (NSArray*) imageInfosForplaceId:(NSString*)placeId;
@end


@implementation FlickrModel


@synthesize placePlist=_placePlist;
@synthesize imageInfos=_imageInfos;
@synthesize latestPlaceId=_latestPlaceId;
@synthesize recents=_recents;
@synthesize recentsSorted=_recentsSorted;


- (id) init {
    self = [super init];
    if ( self ) {
        self.recents = [[NSMutableSet alloc] initWithCapacity:MaxRecents];
        [self.recents release];
        self.recentsSorted = nil;
    }
    return self;
}


- (void) dealloc {
    [_placePlist release];
    [_imageInfos release];
    [_latestPlaceId release];
    [_recents release];
    [_recentsSorted release];
    [super dealloc];
}


- (void) refresh {
    self.placePlist = [FlickrFetcher topPlaces];
}


- (NSUInteger) numberOfPlaces {
    return  [self.placePlist count];
}


- (NSString*) placeDataForKey:(NSString*)key
                  atIndexPath:(NSIndexPath*)idxPath
{
    return  [ (NSDictionary*)[self.placePlist objectAtIndex:idxPath.row]
        objectForKey:key
    ];
}


- (NSString*) cityAtIndexPath:(NSIndexPath*)idxPath {
    return  [[self placeAtIndexPath:idxPath] objectAtIndex:0];
}


- (NSString*) fullStateAtIndexPath:(NSIndexPath*)idxPath {
    NSArray*  names         = [self placeAtIndexPath:idxPath];
    NSString* fullStateName = [names objectAtIndex:1];
    NSArray*  rest          = [names
        subarrayWithRange:NSMakeRange(2, [names count] - 2)
    ];

    for ( NSString* name in rest) {
        fullStateName = [fullStateName stringByAppendingFormat:@", %@", name];
    }
    return  fullStateName;
}


- (NSUInteger) numberOfImagesForPlaceId:(NSString*)placeId {
    return  [[self imageInfosForplaceId:placeId] count];
}


- (Picticulars*) newPicticularsForPlaceId:(NSString*)placeId
                              atIndexPath:(NSIndexPath*)indexPath
{
    Picticulars* pic = [Picticulars new];
    NSDictionary* info = [[self imageInfosForplaceId:placeId]
        objectAtIndex:indexPath.row
    ];

    pic.url = [NSURL
        URLWithString:[FlickrFetcher
            urlStringForPhotoWithFlickrInfo:info
                                     format:FlickrFetcherPhotoFormatLarge
    ]];

    pic.subtitle = [[info objectForKey:@"description"]
        objectForKey:@"_content"
    ];

    pic.title = [info objectForKey:@"title"];
    if ( ! [pic.title isNotBlank] )  pic.title = pic.subtitle;
    if ( ! [pic.title isNotBlank] )  pic.title = @"Unknown";

    return pic;
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


- (NSInteger) countOfRecents {
    return  [self.recentsSorted count];
}


- (Picticulars*) recentPicticularsAtIndexpath:(NSIndexPath*)indexPath {
    return  [self.recentsSorted objectAtIndex:indexPath.row];
}


- (UIImage*) imageFromURL:(NSURL*)url {
    return  [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
}


- (void) spinNetworkActivityIndicatorWhileDoing:(void(^)())block {    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    block();
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
        //  Make a singleton array wrapping an NSSortDescriptor for the
        //  sortedArrayUsingDescriptors: call below.
        NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
            initWithKey:@"lastViewed" ascending:NO
        ];
        NSArray* byLastViewed = [[NSArray alloc]
            initWithObjects:sortDescriptor, nil
        ];
        [sortDescriptor release];

        //  Create a new mutable array of Picticulars sorted by their
        //  dateLastViewed properties.
        self.recentsSorted = [[self.recents
            sortedArrayUsingDescriptors:byLastViewed
        ] mutableCopy];
        [self.recentsSorted release];
        [byLastViewed release];

        //  If the new _recentsSorted has more than MaxRecents elements, then
        //  remove the extras.
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


#pragma mark - Private methods and functions


- (NSArray*) placeAtIndexPath:(NSIndexPath*)idxPath {
    NSString* placeStr = [self
        placeDataForKey:@"_content" atIndexPath:idxPath
    ];
    return [placeStr componentsSeparatedByString:@", "];
}


- (NSArray*) imageInfosForplaceId:(NSString*)placeId {
    if ( ! [placeId isEqualToString:self.latestPlaceId] ) {
        self.imageInfos = [FlickrFetcher photosAtPlace:placeId];
        self.latestPlaceId = placeId;
    }
    return self.imageInfos;
}


@end
