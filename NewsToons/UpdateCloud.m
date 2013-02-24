//
//  UpdateCloud.h
//  
//  Created by Dani Postigo on 6/8/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import "UpdateCloud.h"
#import "CCKeyValuePair.h"
#import "CCRequest.h"
#import "CCResponse.h"


@implementation UpdateCloud {

}


- (id) initWithToon: (Toon *) aToon {
    self = [super init];
    if ( self ) {
        toon = [aToon retain];
    }

    return self;

}

- (void) main {
    [super main];

    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);
//    toon.emailCount++;

    NSDictionary *dictionary = [toon toDictionary];
    if (![_model.emailedLibrary containsObject: dictionary] ) {
        [_model.emailedLibrary addObject: dictionary];
    }


    NSMutableDictionary * paramDict = [[[NSMutableDictionary alloc] init] autorelease];
    [paramDict setObject: @"emailedToons" forKey: @"name"];
    [paramDict setObject: [NSArray arrayWithArray: _model.emailedLibrary] forKey: @"value"];

    CCRequest * newRequest = [[CCRequest alloc] initWithDelegate: self httpMethod: @"PUT" baseUrl: @"keyvalues/set.json" paramDict: paramDict];
    newRequest.allowCompressedResponse = YES;
    CCResponse * response = [newRequest startSynchronousRequest];


    NSArray * allValues = [response getObjectsOfType: [CCKeyValuePair class]];
    for ( CCKeyValuePair * keyPair in allValues ) {
        if ( [keyPair.key isEqualToString: @"emailedToons"] ) {
            NSArray *toons = keyPair.valueArray;
            NSLog(@"toons = %@", toons);

        }
    }


    [newRequest release];

    [_model notifyDelegates: @selector(emailedToonsDidUpdate) object: nil];
    [_model notifyDelegates: @selector(toonDidUpdate:) object: toon];
}




- (void) dealloc {
    [toon release];
    [super dealloc];
}


@end