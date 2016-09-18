//
//  MarkerView.h
//  Around Me
//
//  Created by Rahul Sundararaman on September 16, 2016
//  Copyright (c) 2016 Sundararaman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARGeoCoordinate;
@protocol MarkerViewDelegate;

@interface MarkerView : UIView

@property (nonatomic) int distance;
@property (nonatomic, strong) ARGeoCoordinate *coordinate;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, weak) id <MarkerViewDelegate> delegate;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;
- (id)initWithCoordinate:(ARGeoCoordinate *)coordinate delegate:(id<MarkerViewDelegate>)delegate dist:(double) dist myURL:(NSString *)myURL;
-(void)changeDistance:(double)dist;
@end

@protocol MarkerViewDelegate <NSObject>

- (void)didTouchMarkerView:(MarkerView *)markerView;

@end
