//
//  CCConstants.m
//  Demo
//
//  Created by Wei Kong on 12/20/10.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CCConstants.h"

// backend url
NSString * const CC_BACKEND_URL = @"api.cocoafish.com/v1";

// server related
NSString * const CC_DOMAIN = @"Cocoafish";
const NSInteger CC_SERVER_ERROR = -1;
const NSInteger CC_TIMEOUT = 30;

// meta 
NSString * const CC_STATUS_OK = @"ok";
NSString * const CC_JSON_META = @"meta";
NSString * const CC_JSON_META_CODE = @"code";
NSString * const CC_JSON_META_STATUS = @"status";
NSString * const CC_JSON_META_MESSAGE = @"message";

// meta methods
NSString * const CC_JSON_META_METHOD = @"method_name";
NSString * const CC_JSON_META_METHOD_COMPOUND = @"compound";

// response
NSString * const CC_JSON_RESPONSE = @"response";
NSString * const CC_JSON_RESPONSES = @"responses";

// pagination
NSString * const CC_JSON_PAGINATION = @"pagination";
NSString * const CC_JSON_TOTAL_PAGE = @"total_pages";
NSString * const CC_JSON_TOTAL_COUNT = @"total_results";
NSString * const CC_JSON_PER_PAGE_COUNT = @"per_page";
NSString * const CC_JSON_CUR_PAGE = @"page";

// CCObject
NSString * const CC_JSON_OBJECT_ID = @"id";
NSString * const CC_JSON_CREATED_AT = @"created_at";
NSString * const CC_JSON_UPDATED_AT = @"updated_at";

// CCUser
NSString * const CC_JSON_USER = @"user";
NSString * const CC_JSON_USERS = @"users";
NSString * const CC_JSON_USER_EMAIL = @"email";
NSString * const CC_JSON_USERNAME = @"username";
NSString * const CC_JSON_USER_FIRST = @"first_name";
NSString * const CC_JSON_USER_LAST = @"last_name";
NSString * const CC_JSON_USER_FACEBOOK_AUTHORIZED = @"facebook_authorized";
NSString * const CC_JSON_USER_FACEBOOK_ACCESS_TOKEN = @"facebook_access_token";

// CCPlace
NSString * const CC_JSON_PLACE = @"place";
NSString * const CC_JSON_PLACES = @"places";
NSString * const CC_JSON_PLACE_NAME = @"name";
NSString * const CC_JSON_PLACE_ADDRESS = @"address";
NSString * const CC_JSON_PLACE_CROSS_STREET = @"cross_street";
NSString * const CC_JSON_PLACE_CITY = @"city";
NSString * const CC_JSON_PLACE_STATE = @"state";
NSString * const CC_JSON_PLACE_POSTAL_CODE = @"postal_code";
NSString * const CC_JSON_PLACE_COUNTRY = @"country";
NSString * const CC_JSON_PHONE = @"phone_number";
NSString * const CC_JSON_WEBSITE = @"website";
NSString * const CC_JSON_TWITTER = @"twitter";
NSString * const CC_JSON_LATITUDE = @"latitude";
NSString * const CC_JSON_LONGITUDE = @"longitude";

// CCCheckin
NSString * const CC_JSON_CHECKINS = @"checkins";
NSString * const CC_JSON_MESSAGE = @"message";

// CCStatus
NSString * const CC_JSON_STATUSES = @"statuses";

// CCPhoto
NSString * const CC_JSON_PHOTO = @"photo";
NSString * const CC_JSON_PHOTOS = @"photos";
NSString * const CC_JSON_FILENAME = @"filename";
NSString * const CC_JSON_SIZE = @"size";
NSString * const CC_JSON_COLLECTION_NAME = @"collection_name";
NSString * const CC_JSON_MD5 = @"md5";
NSString * const CC_JSON_TITLE = @"title";
NSString * const CC_JSON_PROCESSED = @"processed";
NSString * const CC_JSON_CONTENT_TYPE = @"content_type";
NSString * const CC_JSON_URLS = @"urls";
NSString * const CC_JSON_TAKEN_AT = @"taken_at";

// CCNameValuePair
NSString * const CC_JSON_KEY_VALUES = @"keyvalues";
NSString * const CC_JSON_KEY = @"name";
NSString * const CC_JSON_VALUE = @"value";

// CCEvent
NSString * const CC_JSON_EVENTS = @"events";
NSString * const CC_JSON_NAME = @"name";
NSString * const CC_JSON_DETAILS = @"details";
NSString * const CC_JSON_START_TIME = @"start_time";
NSString * const CC_JSON_END_TIME = @"end_time";

// CCMessage
NSString * const CC_JSON_MESSAGES = @"messages";
NSString * const CC_JSON_THREAD_ID = @"thread_id";
NSString * const CC_JSON_STATUS = @"status";
NSString * const CC_JSON_SUBJECT = @"subject";
NSString * const CC_JSON_BODY = @"body";
NSString * const CC_JSON_FROM = @"from";
NSString * const CC_JSON_TO = @"to";
