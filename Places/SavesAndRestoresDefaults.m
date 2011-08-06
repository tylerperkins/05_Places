#import <Foundation/Foundation.h>
#import "SavesAndRestoresDefaults.h"


NSString* defaultKey( enum DefaultId n ) {
    return [NSString stringWithFormat:@"%@_%02d", appBundleIdentifier(), n];
}


NSString* appBundleIdentifier() {
    return  [[NSBundle mainBundle] bundleIdentifier];
}


void clearAppDefaults( NSUserDefaults* defaults ) {
    [defaults setPersistentDomain:[NSDictionary dictionary]
                          forName:appBundleIdentifier()
    ];
}
