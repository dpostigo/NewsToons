//
//  FavoriteViewController.m
//  NewsToons
//
//  Created by Daniela Postigo on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FavoriteViewController.h"
#import "UIImage+Addons.h"
#import "Model.h"

@interface FavoriteViewController ()

- (void) handleFavoriteClicked: (id) sender;
//- (void) handleBubbleImage;
//- (void) handleAlert: (BOOL) toBool;
//- (void) handleBooleans;
//- (void) handleNotifications;


@end

@implementation FavoriteViewController

@synthesize favoriteButton;
@synthesize plusImage;
@synthesize heartImage;
@synthesize toonObject;


#define toonAddTitle @"Toon Added!"
#define toonAddText @"This toon has been added to your favorites."

#define toonRemoveTitle @"Your saved toons"
#define toonRemoveText @"Remove this toon from your favorites?"

#define inFavorites @"heart-tray-icon.png"
#define notInFavorites @"heart-icon.png"




- (void) dealloc {
    [toonObject release];
    [favoriteButton release];
    [plusImage release];
    [heartImage release];
    [super dealloc];
}



- (void) viewDidLoad {
    [super viewDidLoad];
}


- (Toon *) toonObject {
    return toonObject;

}

- (void) setToonObject: (Toon *) toon {

    if ( toon != toonObject ) {
        [toon retain];
        [toonObject release];
        toonObject = toon;
    }

    [self updateFavoriteIcon];

}


- (void) updateFavoriteIcon {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSString * string = toonObject.isFavorite ? inFavorites : notInFavorites;
    UIImage * btnImage = [[UIImage newImageFromResource: string] autorelease];
    [favoriteButton setImage: btnImage forState: UIControlStateNormal];

}

- (void) setFavoriteButton: (UIButton *) button {

    if ( favoriteButton != button ) {
        [favoriteButton removeTarget: self action: @selector(handleFavoriteClicked:) forControlEvents: UIControlEventTouchUpInside];

        [button retain], [favoriteButton release], favoriteButton = button;
        [favoriteButton addTarget: self action: @selector(handleFavoriteClicked:) forControlEvents: UIControlEventTouchUpInside];
    }
}


- (void) handleFavoriteClicked: (id) sender {

    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);

    faveAlert = [[[UIAlertView alloc] init] autorelease];
    faveAlert.delegate = self;

    //NSLog(@"toonObject.isFavorite = %@", toonObject.isFavorite ? @"YES" : @"NO");

    //NSLog(@"toonObject = %@", toonObject);

    //NSLog(@"toonObject.title = %@", toonObject.title);

    if ( toonObject.isFavorite ) {

        faveAlert.title = toonRemoveTitle;
        faveAlert.message = toonRemoveText;
        [faveAlert addButtonWithTitle: @"Cancel"];
        [faveAlert addButtonWithTitle: @"OK"];
        faveAlert.cancelButtonIndex = 0;


    }

    else {
        toonObject.isFavorite = YES;

        UIImage * btnImage = [[UIImage newImageFromResource: inFavorites] autorelease];
        [favoriteButton setImage: btnImage forState: UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] postNotificationName: MAKE_FAVORITE object: toonObject];

        faveAlert.title = toonAddTitle;
        faveAlert.message = toonAddText;
        [faveAlert addButtonWithTitle: @"OK"];

        [_model notifyDelegates: @selector(toonDidUpdate:) object: toonObject];
    }


    [faveAlert show];
}


- (void) alertView: (UIAlertView *) actionSheet clickedButtonAtIndex: (NSInteger) buttonIndex {


}

- (void) alertView: (UIAlertView *) alertView didDismissWithButtonIndex: (NSInteger) buttonIndex {

    if ( [alertView.title isEqualToString: toonAddTitle] ) {

    }

    else if ( [alertView.title isEqualToString: toonRemoveTitle]) {
        if ( buttonIndex != alertView.cancelButtonIndex ) {
            toonObject.isFavorite = NO;

            UIImage * image = [[UIImage newImageFromResource: notInFavorites] autorelease];
            [favoriteButton setImage: image forState: UIControlStateNormal];
            [[NSNotificationCenter defaultCenter] postNotificationName: MAKE_UNFAVORITE object: toonObject];

            [_model notifyDelegates: @selector(toonDidUpdate:) object: toonObject];
        }
    }
}



/*

- (void) handleBooleans {
    toonObject.isFavorite = !toonObject.isFavorite;
    [self handleBubbleImage];
    [self handleNotifications];

}

- (void) handleBubbleImage {
    UIImage * btnImage = [UIImage imageNamed: self.buttonImage];
    [favoriteButton setImage: btnImage forState: UIControlStateNormal];

}


- (void) handleAlert: (BOOL) toBool {
    faveAlert = [[UIAlertView alloc]
            initWithTitle: @"Your saved toons"
                  message: @"Remove this toon from your favorites?"
                 delegate: self
        cancelButtonTitle: @"OK"
        otherButtonTitles: nil];


    if ( toBool ) {
        faveAlert.title = @"Toon added!";
        faveAlert.message = @"This toon has been added to your favorites.";
        faveAlert.delegate = nil;
    }

    else {
        [faveAlert addButtonWithTitle: @"Cancel"];
    }

    [faveAlert show];
    [faveAlert release];
}



- (void) handleNotifications {
    NSString * string = MAKE_UNFAVORITE;

    if ( toonObject.isFavorite ) {
        [self handleAlert: YES];
        string = MAKE_FAVORITE;
    }


    [[NSNotificationCenter defaultCenter] postNotificationName: string object: toonObject];
}

*/

- (NSString *) buttonImage {
    if ( toonObject.isFavorite ) return heartImage;
    else return plusImage;
}


@end
