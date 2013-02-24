//
//  InfoViewController.m
//  NewsToons
//
//  Created by Daniela Postigo on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InfoViewController.h"

@implementation InfoViewController



#pragma mark - View lifecycle

- (void) dealloc {
	webView.delegate = nil;
	[super dealloc];
}

- (void) viewDidLoad {
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor clearColor];
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    webView.delegate = self;
    
	[self handleSetup];
	[self loadHTMLFile];
    

    
}
- (void) loadHTMLFile {
	NSURL *baseURL = [NSURL fileURLWithPath: [[NSBundle mainBundle] bundlePath]];
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bio" ofType:@"html"];
	NSString *htmlString = [NSString stringWithContentsOfFile: filePath encoding:NSUTF8StringEncoding error:nil];
    
	if (htmlString) {
		[webView loadHTMLString:htmlString baseURL:baseURL];
	}


	
}


- (void) handleSetup {
    
		bioName = @"bio";
		NSLog(@"iphone");
	/*
    else if(IPAD){
		bioName = @"bio-iPad";
        bgImage.image = [UIImage imageNamed:@"ipad-desktop.png"];
		
        CGFloat infoWidth = 650;
        webView.frame = CGRectMake((768 - infoWidth)/2, 
								   webView.frame.origin.y + 60, 
								   infoWidth, 
								   (1024 - webView.frame.size.height) + 40);
		
		
		
		UIImageView *logo = [self._model getLogoView];
        [self.view addSubview:logo];
    }
     */
	
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
