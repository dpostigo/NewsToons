
//
//  Constants.h
//  NewsToons
//
//  Created by Daniela Postigo on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface Constants : NSObject



/* store keys */

#define playlistStoreKey @"nt_playlists_store_key"
#define toonLibraryStoreKey @"nt_toonlibrary_store_key"
#define bestLibraryStoreKey @"nt_bestlibrary_store_key"
#define pageStoreKey @"nt_page_store_key"
#define lastDateKey @"nt_last_date_key"
#define feedDateKey @"nt_feed_date_key"
#define youtubeResultsKey @"nt_ytoube_results_key"


/* init prefs */

#define initialPageAmount 1
#define LOAD_YOUTUBE_ON_LAUNCH 1


/* notifications */

#define newToonsLoadedKey @"new_toons_loaded"
#define initialLoadReadyKey @"initial_load_ready_key"
#define toonsReadyKey @"toons_ready_key"
#define singlePlaylistUpdated @"single_playlist_updated"
#define playlistsReadyKey @"PlaylistsReadyKey"
#define feedUpdatedKey @"feed_updated_key"
#define bestToonsUpdated @"best_updated_key"
#define emailedToonsUpdatedKey @"emailed_update_key"
#define playlistFeedParsed @"playlist_feed_parsed_key"


/* URLs */

#define YOUTUBE_URL_PLAYLISTS @"https://gdata.youtube.com/feeds/api/users/markfiore/playlists?v=2"
#define singlePlaylistURL @"https://gdata.youtube.com/feeds/api/playlists/"
#define TOON_FEED_URL @"http://www.markfiore.com/recent-animations/feed"
#define bestFeedURL @"http://www.markfiore.com/best-of/feed"
#define ITUNES_APP_URL @"itms-apps://itunes.apple.com/us/app/newstoons/id347104529?mt=8&uo=4"
#define WEB_APP_URL @"http://itunes.apple.com/us/app/newstoons/id347104529?mt=8&uo=4"
#define videoFeedURL @"https://gdata.youtube.com/feeds/api/videos/"
#define kThumbnailURL @"http://img.youtube.com/vi/%@/0.jpg"

#define YOUTUBE_VIDEO_URL @"http://www.youtube.com/watch?v=%@"



/* ids */

#define kFacebookAppId @"182312958515864"

#define MAX_PARSE_AMOUNT 100 
#define PARSE_BATCH_SIZE 5 
#define CELL_HEIGHT 85 
#define SAGA_PRELOAD_NUM 2 
#define PAD_FEATURED_COUNT 5 

#define TOONS_PARSED @"toons_parsed" 
#define PARSE_ERROR @"parsing_error" 
#define PARSED_DATA @"parsed_data" 
#define PARSING_COMPLETE @"parsing_complete" 


#define REMOVE_SPLASH_VIEW @"remove_splash_view" 
#define HOME_VIEW_READY @"home_view_ready" 


#define MAKE_FAVORITE @"make_favorite" 
#define MAKE_UNFAVORITE @"make_unfavorite" 


#define CATEGORY_STORE_KEY @"newstoons_category_storekey" 






#define desktopCellHeight 85
#define favoritesUpdatedKey @"Favorites_updated"
#define toonsUpdatedKey @"Toons_updated"

#define linkRowHeight 30

@end
