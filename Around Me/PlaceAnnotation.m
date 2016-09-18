//
//  PlaceAnnotation.m
//  Around Me
//
//  Created by Rahul Sundararaman on September 16, 2016
//  Copyright (c) 2016 Sundararaman. All rights reserved.
//

#import "PlaceAnnotation.h"

#import "Place.h"

@interface PlaceAnnotation ()

@property (nonatomic, strong) Place *place;

@end


@implementation PlaceAnnotation

- (id)initWithPlace:(Place *)place {
	if((self = [super init])) {
		_place = place;
	}
	return self;
}

- (CLLocationCoordinate2D)coordinate {
	return [_place location].coordinate;
}

- (NSString *)title {
	return [_place placeName];
}

@end
