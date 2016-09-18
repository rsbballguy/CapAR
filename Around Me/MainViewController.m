//
//  MainViewController.m
//  Around Me
//
//  Created by Rahul Sundararaman on September 16, 2016
//  Copyright (c) 2016 Sundararaman. All rights reserved.
//

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "PlacesLoader.h"
#import "Place.h"
#import "PlaceAnnotation.h"

NSString * const kNameKey = @"place";
NSString * const kReferenceKey = @"reference";
NSString * kAddressKey = @"vicinity";
NSString * const kLatiudeKeypath = @"latitude";
NSString * const kLongitudeKeypath = @"longitude";

@interface MainViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *locations;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    	_locationManager = [[CLLocationManager alloc] init];
	[_locationManager setDelegate:self];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
	[_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
	[_locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManager Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *lastLocation = [[CLLocation alloc] initWithLatitude:38.9283 longitude:-77.1753];
    CLLocationAccuracy accuracy = [lastLocation horizontalAccuracy];
	
	NSLog(@"Received location %@ with accuracy %f", lastLocation, accuracy);
	
	if([kAddressKey  isEqual: @"vicinity"]) {
        kAddressKey = @"";
		MKCoordinateSpan span = MKCoordinateSpanMake(0.14, 0.14);
		MKCoordinateRegion region = MKCoordinateRegionMake([lastLocation coordinate], span);
		
		[_mapView setRegion:region animated:YES];
        
		[[PlacesLoader sharedInstance:@"https://p2a-rsbballguy.c9users.io/api/atm"] loadPOIsForLocation:[locations lastObject] radius:5 successHanlder:^(NSDictionary *response) {
            
			if(response!=nil) {

				id places = [response objectForKey:@"arr"];
				NSMutableArray *temp = [NSMutableArray array];
                for(NSDictionary *resultsDict in places) {
                    CLLocation *location = [[CLLocation alloc] initWithLatitude:[[resultsDict valueForKeyPath:kLatiudeKeypath] floatValue] longitude:[[resultsDict valueForKeyPath:kLongitudeKeypath] floatValue]];
                    CLLocation *curr = [[CLLocation alloc] initWithLatitude:38.887690 longitude:-77.128975];
                    if([curr distanceFromLocation:location] < 5000)
                    {
                        Place *currentPlace = [[Place alloc] initWithLocation:location name:[resultsDict objectForKey:kNameKey] key: @"ATM" url:[resultsDict objectForKey:@"url"]];
                        [temp addObject:currentPlace];
                        
                        PlaceAnnotation *annotation = [[PlaceAnnotation alloc] initWithPlace:currentPlace];
                        [_mapView addAnnotation:annotation];
                    }
                    
                }
                
                CLLocation *targetLocation = [[CLLocation alloc] initWithLatitude:38.887690 longitude:-77.128975];
                _locations = [temp copy];
				NSLog(@"Locations: %@", _locations);
            }
            
        } errorHandler:^(NSError *error) {
			NSLog(@"Error: %@", error);
		}];
	}
}
static const double kDegToRad = 0.017453292519943295769236907684886;
static const double kEarthRadiusM = 6372797.560856;

- (double)distanceInMetersFromLoc:(CLLocation *)from toLoc:(CLLocation *)to
{
    return kEarthRadiusM * [self radianArcFrom:from.coordinate to:to.coordinate];
}

- (double)radianArcFrom:(CLLocationCoordinate2D)from to:(CLLocationCoordinate2D)to
{
    double latitudeArc  = (from.latitude - to.latitude) * kDegToRad;
    double longitudeArc = (from.longitude - to.longitude) * kDegToRad;
    double latitudeHS = sin(latitudeArc * 0.5);
    latitudeHS *= latitudeHS;
    double lontitudeHS = sin(longitudeArc * 0.5);
    lontitudeHS *= lontitudeHS;
    double factor = cos(from.latitude * kDegToRad) * cos(to.latitude * kDegToRad);
    return 2.0 * asin(sqrt(latitudeHS + factor * lontitudeHS));
}
#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
		[[segue destinationViewController] setLocations:_locations];
		[[segue destinationViewController] setUserLocation:[_mapView userLocation]];
    }
}

@end
