//
//  InformationView.h
//  NewsToons
//
//  Created by Daniela Postigo on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicNibView.h"

@interface InformationView : BasicNibView {
	
	IBOutlet UILabel *titleLabel;
	IBOutlet UITextView *refView;
	
	
	BOOL titleVisible;
	NSInteger fontSize;
	NSInteger lineHeight;
	UIWebView *webView;
}

@property (nonatomic) NSInteger fontSize;
@property (nonatomic, retain) UIWebView *webView;


- (void) handleString: (NSString *)string;
- (void) handleLinksArray: (NSMutableArray *)array;

- (void) handleTags: (NSMutableArray *) array;

- (NSString *) handleURLString: (NSString *) string index: (int) idx;

- (NSString *) title;
- (void) setTitle:(NSString *) text;


- (BOOL) titleVisible;
- (void) setTitleVisible:(BOOL) val;

- (NSString *) beginDiv;
- (NSString *) endDiv;
- (NSString *) htmlHeader;
- (NSString *) htmlFooter;
- (NSString *) fontString;


@end
