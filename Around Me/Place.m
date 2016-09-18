//
//  Place.m
//  Around Me
//
//  Created by Rahul Sundararaman on September 16, 2016
//  Copyright (c) 2016 Sundararaman. All rights reserved.
//

#import "Place.h"

@implementation Place

- (id)initWithLocation:(CLLocation *)location name:(NSString *)name key:(NSString *)key url:(NSString *)url{
	if((self = [super init])) {
		_location = location;
		_placeName = [name copy];
        _category = [key copy];
        _URL = [url copy];
	}
	
	return self;
}

- (NSString *)infoText {
	return [NSString stringWithFormat:@"Name:%@\n", _placeName];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"Name:%@, location:%@", _placeName, _location];
}

@end
