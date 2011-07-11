//
//  Picticulars.h
//  Places
//
//  Created by Tyler Perkins on 2011-07-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*  This class defines data objects holding PICture parTICULARS.
*/
@interface Picticulars : NSObject {}

@property (retain,nonatomic) NSURL*    url;
@property (retain,nonatomic) NSString* title;
@property (retain,nonatomic) NSString* subtitle;
@property (retain,nonatomic) NSDate*   lastViewed;

- (id) initFromDictionary:(NSDictionary*)dict;
- (NSDictionary*) newDictionary;
- (NSComparisonResult) compare:(Picticulars*)pic;

@end
