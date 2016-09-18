//
//  MainViewController.h
//  Around Me
//
//  Created by Rahul Sundararaman on September 16, 2016
//  Copyright (c) 2016 Sundararaman. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>
- (double)distanceInMetersFromLoc:(CLLocation *)from toLoc:(CLLocation *)to;
- (double)radianArcFrom:(CLLocationCoordinate2D)from to:(CLLocationCoordinate2D)to;

@end
