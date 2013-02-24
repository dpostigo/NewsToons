//
//  Cocoafish.m
//  Cocoafish-ios-sdk
//
//  Created by Wei Kong on 1/3/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "Cocoafish.h"
#import "CCDownloadManager.h"

static Cocoafish *theDefaultCocoafish = nil;

// Encode a string to embed in an URL.
NSString* encodeToPercentEscapeString(NSString *string) {
    return [(NSString *)
    CFURLCreateStringByAddingPercentEscapes(NULL,
                                            (CFStringRef) string,
                                            NULL,
                                            (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8) autorelease];
}

void CCLog(NSString *format, ...) {
    if (theDefaultCocoafish.loggingEnabled) {
        va_list arglist;
        va_start(arglist, format);
        NSLogv(format, arglist);
        va_end(arglist);
    }
}

@interface Cocoafish (PrivateMethods)
-(NSString *)getCookiePath;
-(void)saveUserSession;
-(void)restoreUserSession;
-(void) printCookieStorage;
//-(void)cleanupCacheDir;
-(id)initWithAppKey:(NSString *)appKey customAppIds:(NSDictionary *)customAppIds;
-(id)initWithOauthConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret customAppIds:(NSDictionary *)customAppIds;
-(void)initCommon:(NSDictionary *)customAppIds;
@end

@implementation Cocoafish
@synthesize _fbSessionDelegate;
@synthesize downloadManager = _downloadManager;
@synthesize cocoafishDir = _cocoafishDir;
@synthesize deviceToken = _deviceToken;
@synthesize loggingEnabled = _loggingEnabled;
@synthesize jsonDateFormatter = _jsonDateFormatter;
@synthesize exifDateFormatter = _exifDateFormatter;
@synthesize apiURL = _apiURL;
//@synthesize downloadManagerEnabled = _downloadManagerEnabled;

-(id)initWithAppKey:(NSString *)appKey customAppIds:(NSDictionary *)customAppIds
{
	if (appKey == nil || [appKey length] == 0) {
		[NSException raise:@"Missing Cocoafish App Key" format:@"App Key is missing"];
	}
	if ((self = [super init])) {
		_appKey = [appKey copy];
		[self initCommon:customAppIds];
	}
	return self;
}


-(id)initWithOauthConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret customAppIds:(NSDictionary *)customAppIds
{
	if ([consumerKey length] == 0 || [consumerSecret length] == 0) {
		[NSException raise:@"Missing Cocoafish Oauth Consumer Key and/or Consumer Secret" format:@"Oauth info is missing"];
	}
	if ((self = [super init])) {
		_consumerKey = [consumerKey copy];
		_consumerSecret = [consumerSecret copy];
		[self initCommon:customAppIds];
	}
	return self;
}
	

-(void)initCommon:(NSDictionary *)customAppIds
{
    self.loggingEnabled = true;
    theDefaultCocoafish = self;
    self.apiURL = CC_BACKEND_URL;

	// create Cocoafish dir if there is none
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
	_cocoafishDir = [[NSString alloc] initWithFormat:@"%@/CocoafishCache", documentsDirectory];
	//[self cleanupCacheDir];

	if (![[NSFileManager defaultManager] createDirectoryAtPath:_cocoafishDir withIntermediateDirectories:NO attributes:nil error:nil]) {
		NSLog(@"Failed to create %@, photo download will not work", _cocoafishDir);
	}
    
    _downloadManager = [[CCDownloadManager alloc] init];
	
	// initialize all the custom app Ids such as facebook
	if (customAppIds != nil) {
		NSString *customAppId = [customAppIds objectForKey:@"Facebook"];
		if (customAppId != nil) {
			_facebook = [[Facebook alloc] initWithAppId:customAppId andDelegate:self];
			_facebookAppId = [customAppId copy];
			NSLog(@"Cocoafish: initialized facebook with app Id %@", customAppId);
		}
	}
	
	// restore currentUser info if there is any
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *json = [prefs objectForKey:@"cc_current_user_json"];
    if (json) {
        _currentUser = [[CCUser alloc] initWithJsonResponse:json];
    }

	if (_currentUser) {
		[self restoreUserSession];
	}
	
    // set up date formatter
    self.jsonDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    self.jsonDateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    self.exifDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
}

-(NSString *)getAppKey
{
	return _appKey;
}

-(NSString *)getOauthConsumerKey
{
	return _consumerKey;
}

-(NSString *)getOauthConsumerSecret
{
	return _consumerSecret;
}

-(CCUser *)getCurrentUser
{
	return _currentUser;
}

-(Facebook *)getFacebook
{
	return _facebook;
}

-(void)setCurrentUser:(NSDictionary *)json
{
	[_currentUser release];
    _currentUser = nil;
    if (json) {
        _currentUser = [[CCUser alloc] initWithJsonResponse:json];
    }
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	if (_currentUser) {
        [prefs setObject:json forKey:@"cc_current_user_json"];
    } else {
        [prefs removeObjectForKey:@"cc_current_user_json"];
		// logout from facebook too if applicable
		[_facebook logout:self];
	}
	[self saveUserSession];
	[prefs synchronize];

}

#pragma mark -
#pragma mark facebook related

-(void)facebookAuth:(NSArray *)permissions delegate:(id<CCFBSessionDelegate>)delegate
{

	_fbSessionDelegate = delegate;
	// we will always ask for offline access permissions
	/*NSMutableArray *ccPermissions = [NSMutableArray arrayWithArray:permissions];
	BOOL found = NO;
	for (NSString *permission in ccPermissions) {
		if ([permission caseInsensitiveCompare:@"offline_access"] == NSOrderedSame) {
			found = YES;
			break;
		}
	}
	if (!found) {
		[ccPermissions insertObject:@"offline_access" atIndex:0];
	}*/
	[_facebook authorize:permissions];
}

-(void)unlinkFromFacebook:(NSError **)error
{
    CCRequest *request = [[[CCRequest alloc] initWithDelegate:self httpMethod:@"DELETE" baseUrl:@"users/external_accounts_unlink.json" paramDict:nil] autorelease];

    [request startSynchronous];

}

/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin {
    // login with cocoafish
	NSError *error = nil;
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:_facebook.accessToken, @"facebook", nil] forKeys:[NSArray arrayWithObjects:@"token", @"type", nil]];
    CCRequest *ccrequest = nil;
	if ([[Cocoafish defaultCocoafish] getCurrentUser] != nil) {
		// This is for linking facebook with the existing user
        ccrequest = [[[CCRequest alloc] initWithDelegate:self httpMethod:@"POST" baseUrl:@"users/external_account_link.json" paramDict:paramDict] autorelease];
        
    } else {
        ccrequest = [[[CCRequest alloc] initWithDelegate:self httpMethod:@"POST" baseUrl:@"users/external_account_login.json" paramDict:paramDict] autorelease];
        
    }
    
    [ccrequest startSynchronousRequest];
    
	if (_currentUser == nil) {
		// Failed to register with the cocoafish server
        //	[_facebook logout:self];
		if (_fbSessionDelegate && [_fbSessionDelegate respondsToSelector:@selector(fbDidNotLogin:error:)]) {
			[_fbSessionDelegate fbDidNotLogin:NO error:error];
		}
	} else {
		if (_fbSessionDelegate && [_fbSessionDelegate respondsToSelector:@selector(fbDidLogin)]) {
			[_fbSessionDelegate fbDidLogin];
		}
	}
	_fbSessionDelegate = nil;
	
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
	if (_fbSessionDelegate && [_fbSessionDelegate respondsToSelector:@selector(fbDidNotLogin:error:)]) {
		[_fbSessionDelegate fbDidNotLogin:cancelled error:nil];
	}
	_fbSessionDelegate = nil;
}

-(void)fbDidLogout {
	// Logout has to go through cocoafish server
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
    NSString* uid = [result objectForKey:@"id"];
    NSString *first_name = [result objectForKey:@"first_name"];
    NSString *last_name = [result objectForKey:@"last_name"];

    // login with cocoafish
	NSError *error = nil;
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:uid, _facebook.accessToken, @"facebook", nil] forKeys:[NSArray arrayWithObjects:@"id", @"token", @"type", nil]];
    CCRequest *ccrequest = nil;
	if ([[Cocoafish defaultCocoafish] getCurrentUser] != nil) {
		// This is for linking facebook with the existing user
        ccrequest = [[[CCRequest alloc] initWithDelegate:self httpMethod:@"POST" baseUrl:@"users/external_account_link.json" paramDict:paramDict] autorelease];
        
    } else {
        // add first name and last name
        [paramDict setObject:first_name forKey:@"first_name"];
        [paramDict setObject:last_name forKey:@"last_name"];

        ccrequest = [[[CCRequest alloc] initWithDelegate:self httpMethod:@"POST" baseUrl:@"users/external_account_login.json" paramDict:paramDict] autorelease];
        
    }
    
    [ccrequest startSynchronousRequest];
    
	if (_currentUser == nil) {
		// Failed to register with the cocoafish server
	//	[_facebook logout:self];
		if (_fbSessionDelegate && [_fbSessionDelegate respondsToSelector:@selector(fbDidNotLogin:error:)]) {
			[_fbSessionDelegate fbDidNotLogin:NO error:error];
		}
	} else {
		if (_fbSessionDelegate && [_fbSessionDelegate respondsToSelector:@selector(fbDidLogin)]) {
			[_fbSessionDelegate fbDidLogin];
		}
	}
	_fbSessionDelegate = nil;
}
#pragma mark -
#pragma mark user Cookie
-(NSString *)getCookiePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *cookieDataPath = [documentsDirectory stringByAppendingPathComponent:@"cookieData.txt"];
	return cookieDataPath;
}

// Save all of our cookies including the user and
-(void)saveUserSession
{
	NSString *cookieDataPath = [self getCookiePath];
	
	// debug
    if ([[Cocoafish defaultCocoafish] loggingEnabled]) {
        NSLog(@"Storing cookies into file %@", cookieDataPath);
    }
	
	NSHTTPCookieStorage* sharedCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray* cookies = [sharedCookieStorage cookies];
	
	// Create an array of dictionary objects
	NSMutableArray *cookieList = [[NSMutableArray alloc] init];
	for (NSHTTPCookie *cookie in cookies) {
		NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
									cookie.domain, NSHTTPCookieDomain,
									cookie.path, NSHTTPCookiePath,  // IMPORTANT!
									cookie.name, NSHTTPCookieName,
									cookie.value, NSHTTPCookieValue,
									nil];
		
		// Add the resulting dictionary to the array
		[cookieList addObject:properties];
	}
	
	// archive the cookies
	[NSKeyedArchiver archiveRootObject:cookieList toFile:cookieDataPath];
	
	// release memory
	[cookieList release];
}

// Restore the user's session
-(void)restoreUserSession {
	NSString *cookieDataPath = [self getCookiePath];	
	NSMutableArray *cookieDictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:cookieDataPath];
	NSHTTPCookieStorage* sharedCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	
	for (NSDictionary *dict in cookieDictionary) {
		NSHTTPCookie *newCookie = [NSHTTPCookie cookieWithProperties:dict];
		[sharedCookieStorage setCookie:newCookie];
		
		// Debug
		CCLog(@"Restored cookie %@", newCookie);
	}
}

-(void) printCookieStorage {
	NSHTTPCookieStorage* sharedCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray* cookies = [sharedCookieStorage cookies] ;
	CCLog(@"cookies: %@", cookies);
}


/*-(void)cleanupCacheDir
{
	[[NSFileManager defaultManager] removeItemAtPath:_cocoafishDir error:nil];
}*/

-(void)dealloc
{
	//[self cleanupCacheDir];
	[_currentUser release];
	[_appKey release];
	[_consumerKey release];
	[_consumerSecret release];
	[_downloadManager release];
	[_cocoafishDir release];
    [_jsonDateFormatter release];
    [_exifDateFormatter release];
	[super dealloc];
}

/*#pragma CCRequest delegate methods

-(void)ccrequest:(CCRequest *)request didSucceed:(CCResponse *)response
{
    NSArray *users = [response getObjectsOfType:[CCUser class]];
    if ([users count] == 1) {
        CCUser *user = [users objectAtIndex:0];
        [[Cocoafish defaultCocoafish] setCurrentUser:user];
    }
}

// This can be invoked if getme fails
-(void)ccrequest:(CCRequest *)request didFailWithError:(NSError *)error
{
    // set current user to nil
    [[Cocoafish defaultCocoafish] setCurrentUser:nil];
}*/

+(void)initializeWithAppKey:(NSString *)appKey customAppIds:(NSDictionary *)customAppIds
{
    @synchronized(theDefaultCocoafish) {
        if (theDefaultCocoafish != nil) {
            return;
        }
        theDefaultCocoafish = [[Cocoafish alloc] initWithAppKey:appKey customAppIds:customAppIds];
    }
}

+(void)initializeWithOauthConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret customAppIds:(NSDictionary *)customAppIds
{
    @synchronized(theDefaultCocoafish) {
        if (theDefaultCocoafish != nil) {
            return;
        }
        theDefaultCocoafish = [[Cocoafish alloc] initWithOauthConsumerKey:consumerKey consumerSecret:consumerSecret customAppIds:customAppIds];
    }
}

+(Cocoafish *)defaultCocoafish
{
    @synchronized(theDefaultCocoafish) {
        if (theDefaultCocoafish == nil) {
            [NSException raise:@"Uninitialized" format:@"Use [Cocoafish initializeWithAppId:customAppIds:] to initialize Cocoafish"];
        }
        return theDefaultCocoafish;
    }
}

@end
