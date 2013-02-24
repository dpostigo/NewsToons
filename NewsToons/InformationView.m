//
//  InformationView.m
//  NewsToons
//
//  Created by Daniela Postigo on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InformationView.h"

@implementation InformationView

@synthesize webView;
@synthesize fontSize;


- (void) setup {
	[super setup];
	
	fontSize = 13;
	lineHeight = 28;
	
	webView = [[UIWebView alloc] initWithFrame: self.frame];
	[self addSubview:webView];
	[refView removeFromSuperview];
    [refView release];

    self.backgroundColor = [UIColor clearColor];
	
	webView.backgroundColor = [UIColor clearColor];
	webView.opaque = NO;
	for (UIView* subview in webView.subviews) {
		subview.backgroundColor = UIColor.clearColor;
	}
}


- (void) handleString: (NSString *)string; {
	
	if([string length] == 0) string = @"";
	NSString *htmlString = [self htmlHeader];
	htmlString = [htmlString stringByAppendingString: self.beginDiv];
	htmlString = [htmlString stringByAppendingString: string];
	htmlString = [htmlString stringByAppendingString: self.endDiv];
	htmlString = [htmlString stringByAppendingString: [self.htmlFooter retain]];
	[webView loadHTMLString:htmlString baseURL:nil];
}

- (void) handleTags: (NSMutableArray *) array {
	
	NSString *htmlString = [self htmlHeader];
	htmlString = [htmlString stringByAppendingString: self.beginDiv];
	
	for (NSString *tag in array){
		htmlString = [htmlString stringByAppendingString:@"<div class=\"tag\">"];
		htmlString = [htmlString stringByAppendingString:tag];
		htmlString = [htmlString stringByAppendingString:@"</div>"];
	}
	htmlString = [htmlString stringByAppendingString: self.endDiv];
	htmlString = [htmlString stringByAppendingString: self.htmlFooter];
	[webView loadHTMLString:htmlString baseURL:nil];
}

- (void) handleLinksArray: (NSMutableArray *)array; {
	
	
	
	NSString *htmlString = [self htmlHeader];
	htmlString = [htmlString stringByAppendingString:self.beginDiv];
	
	
	//NSString *urls = [array componentsJoinedByString:@"</p><p>"];
	//htmlString = [htmlString stringByAppendingString:@"<p>"];
	
	int index = 0;
	for (NSString *url in array){
		htmlString = [htmlString stringByAppendingString: [self handleURLString:url index:index]];
		index++;
	}
	
	//htmlString = [htmlString stringByAppendingString:@"</p>"];
	htmlString = [htmlString stringByAppendingString: self.endDiv];
	htmlString = [htmlString stringByAppendingString: [self.htmlFooter retain]];
	
	NSLog(@"htmlString = %@", htmlString);
	[webView loadHTMLString:htmlString baseURL:nil];

	
}

- (NSString *) handleURLString: (NSString *) string index: (int) idx {
	
	NSString *siteTitle;
	NSString *returnString;
	
	NSScanner *scanner = [NSScanner scannerWithString:string];
	NSString *result = nil;
	if ( [scanner scanUpToString:@".com" intoString:&result]) {
		siteTitle = [result stringByAppendingString:@".com"];
		siteTitle = [siteTitle stringByReplacingOccurrencesOfString:@"http://" withString:@""];
		siteTitle = [siteTitle stringByReplacingOccurrencesOfString:@"www." withString:@""];
	}
	
	NSString *classStr = ( idx % 2 ) ? @"odd" : @"even" ;
	returnString = [NSString stringWithFormat:@"<p><a href=\"%@\" class=\"%@\">%@</a></p>", string, classStr, siteTitle];
	return returnString;
}


- (NSString *) beginDiv {
	NSString *string = [[[NSString alloc] initWithString: @"<div class=\"content\">"] autorelease];
	return string;
}

- (NSString *) endDiv {
	NSString *string = [[[NSString alloc] initWithString:@"</div>"] autorelease];
	return string;
}




- (NSString *) htmlHeader {
	
	NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"infoStyle" ofType:@"html"];
	
	NSString *string = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil];
	
	return string;
		
	
	/*
	
	NSString *string = [NSString stringWithString:@"
	
    NSString *string = [[NSString stringWithFormat:@"<html> \n <head> \n"]; <style> \n body {margin-top:10px; \n margin-bottom: 0px; \n background-color:#000000; \n font-family:Arial; \n color: #fff; \n } \n .tag {background-color:#a10415; \n color:#fff; text-transform:uppercase;font-family:Arial; font-weight:bold; float:left; font-size:11px; padding:4px 6px 1px 6px; margin-right:6px; margin-bottom:6px} \n .content{%@ margin-bottom:20px; margin-top:10px} \n </style> \n <body style=\" background-color:#transparent\"> \n", self.fontString];
	return string;
	 
	 */
}
	 


- (NSString *) htmlFooter {
	NSString *string = [[NSString alloc] initWithString: @"<div style=\"clear:both\"></div>"];
						
    string = [string stringByAppendingString:@"<div style=\"width:50px;height:10px\"></div>"];
    string = [string stringByAppendingString:@"</body></html>"];
	return string;
	
}

- (NSString *) fontString {
	NSString *string  = [NSString stringWithFormat:@"font-size: %ipx; line-height: %ipx", fontSize, lineHeight];
	return string;
	// if(IPAD) fontSize = @"font-size: 16px; line-height:26px; text-align:justify ";
}


- (NSString *) title {
	return titleLabel.text;
}

- (void) setTitle:(NSString *) text {
	titleLabel.text = text;
}

- (BOOL) titleVisible {
	return titleVisible;
}

- (void) setTitleVisible:(BOOL)val {
	if( val != titleVisible) {
		titleVisible = val;
	}
	
	if (!titleVisible) {
		[titleLabel removeFromSuperview];
		webView.frame = self.frame;
	}
	
	else {
		[self addSubview:titleLabel];
		
	}
}

- (void) setBackgroundColor:(UIColor *)backgroundColor {
	[super setBackgroundColor:backgroundColor];
	webView.backgroundColor = backgroundColor;
	
}

- (void) dealloc {
    [titleLabel release];
    [webView release];
    [super dealloc];
}


@end
