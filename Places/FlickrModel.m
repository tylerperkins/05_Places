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

@interface FlickrModel ()
@property (retain,nonatomic) NSArray*       imageInfos;
@property (retain,nonatomic) NSString*      latestPlaceId;
@property (retain,nonatomic) NSDictionary*  placeInfosForCountries;
- (NSArray*) imageInfosForplaceId:(NSString*)placeId;
@end

@interface PlaceInfo ()            // (Implementation is at end of this file.)
- (id) initWithPlaceDictionary:(NSDictionary*)dict;
@end

NSArray* placeNamesInDict( NSDictionary* dict );
NSString* fullStateDesignationFromNames( NSArray* names );


@implementation FlickrModel


@synthesize imageInfos = _imageInfos;
@synthesize latestPlaceId = _latestPlaceId;
@synthesize countriesSorted = _countriesSorted;
@synthesize placeInfosForCountries = _placeInfosForCountries;


- (void) dealloc {
    [_imageInfos release];
    [_latestPlaceId release];
    [_countriesSorted release];
    [_placeInfosForCountries release];
    [super dealloc];
}


/*  Downloads new data from Flickr to populate self.countriesSorted and
    self.placeInfosForCountries.
*/
- (void) refresh {
    self.placeInfosForCountries = [[NSMutableDictionary alloc]
        initWithCapacity:50
    ];
    [self.placeInfosForCountries release];    // Because retained in setter.

    //  Store a new PlaceInfo object in self.placeInfosForCountries for each
    //  place dictionary returned by FlickrFetcher.
    //
    for ( NSDictionary* dict in [FlickrFetcher topPlaces] ) {
        PlaceInfo* place = [[PlaceInfo alloc] initWithPlaceDictionary:dict];

        //  Add place to the array at key place.country, or if this is the
        //  first place with that country, create a new array containing
        //  only place and associate the new array with that key.
        NSMutableArray* places = [self.placeInfosForCountries
            objectForKey:place.country
        ];
        if ( places ) {
            
            //  Find the lowest index of PlaceInfo* p in places such that
            //  place.city is earlier alphabetically than p.city.
            NSInteger insertHere = [places
                indexOfObjectPassingTest:
                    ^( id p, NSUInteger idx, BOOL* stop ){
                        return (BOOL)( NSOrderedAscending ==
                            [place.city localizedCompare:((PlaceInfo*)p).city]
                        );
                    }
            ];

            //  If no city in places is alphabetically greater than p.city,
            //  then put p at the end of the array.
            if ( insertHere == NSNotFound )  insertHere = [places count];

            [places insertObject:place atIndex:insertHere];

        } else {
            NSMutableArray* arr = [[NSMutableArray alloc]
                initWithObjects:place, nil
            ];
            [self.placeInfosForCountries setValue:arr forKey:place.country];
            [arr release];
        }

        [place release];
    }

    //  Save the sorted list of countries. These will be shown as sections in
    //  the table view.
    self.countriesSorted = [[self.placeInfosForCountries allKeys]
        sortedArrayUsingSelector:@selector(localizedCompare:)
    ];
}


- (NSUInteger) numberOfPlacesForCountry:(NSString*)cntry {
    return  [[self.placeInfosForCountries objectForKey:cntry] count];
}


- (PlaceInfo*) placeInfoAtIndexPath:(NSIndexPath*)indexPath {
    return  [
        [self.placeInfosForCountries valueForKey:[
            self.countriesSorted objectAtIndex:indexPath.section
        ]] objectAtIndex:indexPath.row
    ];
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


- (UIImage*) imageFromURL:(NSURL*)url {
    return  [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
}


#pragma mark - Private methods and functions


/*  Digs out the parsed array of [city, state, country] from the given
    dictionary. The dictionary is an element of an array returned by
    [FlickrFetcher topPlaces].
*/
NSArray* placeNamesInDict( NSDictionary* dict ) {
    NSString* placeStr = [dict objectForKey:@"_content"];
    return [placeStr componentsSeparatedByString:@", "];
}


/*  From the given parsed array of [city, state, country], constructs a string
    showing the full state name, including country, such as
    @"Colorado, United States".
*/
NSString* fullStateDesignationFromNames( NSArray* names ) {
    NSString* fullStateName = [names objectAtIndex:1];
    NSArray*  rest          = [names
        subarrayWithRange:NSMakeRange(2, [names count] - 2)
    ];
    
    for ( NSString* name in rest) {
        fullStateName = [fullStateName stringByAppendingFormat:@", %@", name];
    }
    return  fullStateName;
}


/*  Obtains and caches the array of photo information for the given place ID.
    If placeId is the same as it was in the last call, the cached array is
    returned without consulting FlickrFetcher.
*/
- (NSArray*) imageInfosForplaceId:(NSString*)placeId {
    if ( ! [placeId isEqualToString:self.latestPlaceId] ) {
        self.imageInfos = [FlickrFetcher photosAtPlace:placeId];
        self.latestPlaceId = placeId;
    }
    return self.imageInfos;
}


@end


@implementation PlaceInfo

@synthesize placeId = _placeId;
@synthesize country = _country;
@synthesize city = _city;
@synthesize fullState = _fullState;


- (id) initWithPlaceDictionary:(NSDictionary*)dict {
    self = [super init];
    if ( self ) {
        self.placeId = [dict objectForKey:@"place_id"];
        NSArray* placeNames = placeNamesInDict(dict);
        self.country = [placeNames lastObject];
        self.city = [placeNames objectAtIndex:0];
        self.fullState = fullStateDesignationFromNames(placeNames);
    }
    return  self;
}


- (void) dealloc {
    [_placeId release];
    [_country release];
    [_city release];
    [_fullState release];
    [super dealloc];
}


@end
