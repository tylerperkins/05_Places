//
//  SavesAndRestoresDefaults.h
//  Calculator
//
//  Created by Tyler Perkins on 2011-06-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


/*  Designates that the implementor knows how to save some state to an
    NSUserDefaults object, and how to restore that state later, such as when
    the application starts up the next time.
*/
@protocol SavesAndRestoresDefaults <NSObject>
- (void) saveToUserDefaults:(NSUserDefaults*)defaults;
- (void) restoreFromUserDefaults:(NSUserDefaults*)defaults;
@end


/*  These names correspond to the various keys that may be used to persist
    application "user defaults" data across invocations of the app. For
    example, to obtain the BOOL corresponding to HaveSavedValues, call

        [[NSUserDefaults standardUserDefaults]
            boolForKey:defaultKey( HaveSavedValues )
        ];

    Using an enum this way is typesafe and will serve to catch typos.
*/
enum DefaultId {
    Recents
};

/*  Generates the string key corresponding to the given enum value.
*/
NSString* defaultKey( enum DefaultId n );

/*  Looks up the "bundle identifier" for this app.
*/
NSString* appBundleIdentifier();

/*  Removes all the persisted keys and values in the application domain of
    the given user defaults object.
*/
void clearAppDefaults( NSUserDefaults* defaults );
