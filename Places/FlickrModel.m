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
@property (retain,nonatomic) NSArray*  placePlist;
@property (retain,nonatomic) NSArray*  imageInfos;
@property (retain,nonatomic) NSString* latestPlaceId;
- (NSArray*) placeAtIndexPath:(NSIndexPath*)idxPath;
- (NSArray*) imageInfosForplaceId:(NSString*)placeId;
@end


@implementation FlickrModel


@synthesize placePlist =_placePlist;
@synthesize imageInfos = _imageInfos;
@synthesize latestPlaceId = _latestPlaceId;


- (void) dealloc {
    [_placePlist release];
    [_imageInfos release];
    [_latestPlaceId release];
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


- (UIImage*) imageFromURL:(NSURL*)url {
    return  [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
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
