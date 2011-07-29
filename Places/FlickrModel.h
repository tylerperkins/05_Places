//
//  FlickrModel.h
//  Places
//
//  Created by Tyler Perkins on 2011-06-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Picticulars.h"

@interface PlaceInfo : NSObject {}
@property (retain,nonatomic) NSString *placeId, *country, *city, *fullState;
@end


@interface FlickrModel : NSObject {}

@property (retain,nonatomic) NSArray* countriesSorted;

- (void) refresh;
- (NSUInteger) numberOfPlacesForCountry:(NSString*)cntry;
- (PlaceInfo*) placeInfoAtIndexPath:(NSIndexPath*)indexPath;
- (NSUInteger) numberOfImagesForPlaceId:(NSString*)placeId;
- (Picticulars*) newPicticularsForPlaceId:(NSString*)placeId
                              atIndexPath:(NSIndexPath*)indexPath;
- (UIImage*) imageFromURL:(NSURL*)url;

@end
