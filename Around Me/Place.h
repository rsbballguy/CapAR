//
//  Place.h
//  Around Me
//
//  Created by Rahul Sundararaman on September 16, 2016
//  Copyright (c) 2016 Sundararaman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

@interface Place : NSObject

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, copy) NSString *placeName;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *URL;
extern int distance;
- (id)initWithLocation:(CLLocation *)location name:(NSString *)name key:(NSString *)key url:(NSString *)url;
- (NSString *)infoText;

@end
