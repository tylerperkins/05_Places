//
//  FlickrModel.h
//  Places
//
//  Created by Tyler Perkins on 2011-06-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Picticulars.h"
#import "SavesAndRestoresDefaults.h"

@interface FlickrModel : NSObject<SavesAndRestoresDefaults> {}

- (void) refresh;
- (NSUInteger) numberOfPlaces;
- (NSString*) placeDataForKey:(NSString*)key
                  atIndexPath:(NSIndexPath*)idxPath;
- (NSString*) cityAtIndexPath:(NSIndexPath*)idxPath;
- (NSString*) fullStateAtIndexPath:(NSIndexPath*)idxPath;
- (NSUInteger) numberOfImagesForPlaceId:(NSString*)placeId;
- (Picticulars*) newPicticularsForPlaceId:(NSString*)placeId
                              atIndexPath:(NSIndexPath*)indexPath;
- (void) didViewPicticulars:(Picticulars*)pic;
- (NSInteger) countOfRecents;
- (Picticulars*) recentPicticularsAtIndexpath:(NSIndexPath*)indexPath;
- (UIImage*) imageFromURL:(NSURL*)url;


@end
