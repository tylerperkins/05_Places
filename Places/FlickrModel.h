//
//  FlickrModel.h
//  Places
//
//  Created by Tyler Perkins on 2011-06-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Picticulars.h"

/*  Inner class defining data objects that describe a Flicker "place".
*/
@interface PlaceInfo : NSObject {}
@property (readonly) NSString *placeId, *country, *city, *fullState;
@end

/*  This class' single instance is assigned in Interface Builder. It is
    responsible for communicating to the Flickr web service (via class
    FlickrFetcher) and for providing picture data in a form usable by the
    PlacesTableViewController and MostViewedTableViewController singletons.
*/
@interface FlickrModel : NSObject {}

@property (retain,nonatomic) NSArray* countriesSorted;

/*  Downloads new data from Flickr to populate self.countriesSorted and
    self.placeInfosForCountries.
*/
- (void) refresh;

- (NSUInteger) numberOfPlacesForCountry:(NSString*)cntry;
- (PlaceInfo*) placeInfoAtIndexPath:(NSIndexPath*)indexPath;
- (NSUInteger) numberOfImagesForPlaceId:(NSString*)placeId;

/*  Creates a new Picticulars object loaded with info about the
    (indexPath.row)th image given by Flicker for the indicated place. Note
    that the returned object already has a return count of 1, so it is the
    caller's responsibility to release it.
*/
- (Picticulars*) newPicticularsForPlaceId:(NSString*)placeId
                              atIndexPath:(NSIndexPath*)indexPath;

/*  Downloads the picture described by the given Picticulars object.
*/
- (UIImage*) imageFromPicticulars:(Picticulars*)pic;

@end
