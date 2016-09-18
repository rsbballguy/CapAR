//
//  PlacesLoader.m
//  Around Me
//
//  Created by Rahul Sundararaman on September 16, 2016
//  Copyright (c) 2016 Sundararaman. All rights reserved.
//

#import "PlacesLoader.h"

#import <CoreLocation/CoreLocation.h>
#import <Foundation/NSJSONSerialization.h>

#import "Place.h"

NSString *apiURL = @"https://p2a-rsbballguy.c9users.io/";

@interface PlacesLoader ()

@property (nonatomic, strong) SuccessHandler successHandler;
@property (nonatomic, strong) ErrorHandler errorHandler;
@property (nonatomic, strong) NSMutableData *responseData;

@end


@implementation PlacesLoader

+ (PlacesLoader *)sharedInstance:(NSString *)url {
    
	static PlacesLoader *instance = nil;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		instance = [[PlacesLoader alloc] init];
	});
	
	return instance;
}

- (void)loadPOIsForLocation:(CLLocation *)location radius:(int)radius successHanlder:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler {
	_responseData = nil;
	_successHandler = handler;
	_errorHandler = errorHandler;
	//CLLocationDegrees latitude = [location coordinate].latitude;
	//CLLocationDegrees longitude = [location coordinate].longitude;
	
	NSMutableString *uri = [NSMutableString stringWithString:apiURL];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[uri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
	
	[request setHTTPShouldHandleCookies:YES];
	[request setHTTPMethod:@"GET"];
	
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	NSLog(@"Starting connection: %@ for request: %@", connection, request);
}

- (void)loadDetailInformation:(Place *)location successHanlder:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler {
	_responseData = nil;
	_successHandler = handler;
	_errorHandler = errorHandler;
	
	NSMutableString *uri = [NSMutableString stringWithString:apiURL];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[uri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
	
	[request setHTTPShouldHandleCookies:YES];
	[request setHTTPMethod:@"GET"];
	
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

	NSLog(@"Starting connection: %@ for request: %@", connection, request);
}

#pragma mark - NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	if(!_responseData) {
		_responseData = [NSMutableData dataWithData:data];
	} else {
		[_responseData appendData:data];
	}
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	id object = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingAllowFragments error:nil];
	
	if(_successHandler) {
		_successHandler(object);
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	if(_errorHandler) {
		_errorHandler(error);
	}
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
