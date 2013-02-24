//
//  GetEmailedToons.h
//  
//  Created by Dani Postigo on 6/8/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import "GetEmailedToons.h"
#import "CCRequest.h"
#import "CCUser.h"
#import "CCResponse.h"
#import "CCKeyValuePair.h"
#import "ToonCoder.h"
#import "NSMutableArray+Toon.h"


@implementation GetEmailedToons {
    CCRequest * request;
}


- (void) main {
    [super main];


    NSDictionary * paramDict = [NSDictionary dictionaryWithObjectsAndKeys: @"emailedToons", @"name", nil];
    request = [[CCRequest alloc] initWithDelegate: self httpMethod: @"GET" baseUrl: @"keyvalues/get.json" paramDict: paramDict];
    CCResponse * response = [request startSynchronousRequest];

    NSArray * allValues = [response getObjectsOfType: [CCKeyValuePair class]];



    
    for ( CCKeyValuePair * keyPair in allValues ) {
        if ( [keyPair.key isEqualToString: @"emailedToons"] ) {
            NSArray *toons = keyPair.valueArray;
            Toon * toon;
            ToonCoder * coder;

            for (NSDictionary * dictionary in toons) {

                coder = [[[ToonCoder alloc] initWithDictionary: dictionary] autorelease];
                toon = [[[Toon alloc] initWithCoder: coder] autorelease];


                Toon * toonToAdd;
                Toon * libraryToon = [_model.toonLibrary toonFromTitle: toon.title];


                if (libraryToon != nil) {
                    libraryToon.emailCount = toon.emailCount;
                    toonToAdd = libraryToon;


                    //NSLog(@"Grabbed an existing library toon (%@)", toon.title);
                    //NSLog(@"library Date %@ for %@", toonToAdd.date, toon.title);
                } else {

                    toonToAdd = toon;
                    toonToAdd.isFavorite = NO;
                    [_model.toonLibrary addToon: toonToAdd];
                    NSLog(@"Date %@ for %@", toonToAdd.date, toon.title);
                }

                toonToAdd.isBest = YES;
                [_model.emailedLibrary addToon: toonToAdd];

            }
        }
    }

    [request release];


}



- (void) dealloc {
    [super dealloc];
}


@end