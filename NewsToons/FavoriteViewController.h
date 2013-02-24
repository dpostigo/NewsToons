//
//  FavoriteViewController.h
//  NewsToons
//
//  Created by Daniela Postigo on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BasicViewController.h"
#import "Toon.h"

@interface FavoriteViewController : BasicViewController <UIAlertViewDelegate> {
	UIButton *favoriteButton;
	Toon *toonObject;

	UIAlertView *faveAlert;

    NSString *plusImage;
    NSString *heartImage;
}

@property ( nonatomic, retain ) Toon * toonObject;
@property ( nonatomic, retain ) UIButton *favoriteButton;
@property ( nonatomic, retain ) NSString *plusImage;
@property ( nonatomic, retain ) NSString *heartImage;


- (void) setToonObject: (Toon *) toon;
- (void) updateFavoriteIcon;
- (void) setFavoriteButton: (UIButton *) button;

- (NSString *) buttonImage;





@end
