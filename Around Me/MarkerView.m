//
//  MarkerView.m
//  Around Me
//
//  Created by Rahul Sundararaman on September 16, 2016
//  Copyright (c) 2016 Sundararaman. All rights reserved.
//

#import "MarkerView.h"
#import "QuartzCore/QuartzCore.h"
#import "ARGeoCoordinate.h"

float kWidth = 300;
float kHeight = 300;
float alpha = 1.0f;

@interface MarkerView ()

@property (nonatomic, strong) UILabel *lblDistance;

@end


@implementation MarkerView
UILabel *title;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.backgroundColor = [UIColor blueColor];
    }
    return self;
}
-(void)changeDistance:(double)dist{
    _distance = dist;
    kHeight*=dist;
    kWidth*=dist;
    alpha*=dist;
}
- (id)initWithCoordinate:(ARGeoCoordinate *)coordinate delegate:(id<MarkerViewDelegate>)delegate dist:(double) dist myURL:(NSString *)myURL{
    _url = myURL;
    
    _distance = dist;
    float x = _distance-1000;
    float y = _distance-1000;
    if(x<100){
        x = 100;
    }
    if(y<100){
        y=100;
    }
    if(x>200){
        x = 400;
    }
    if(y>200){
        y = 400;
    }
	if((self = [super initWithFrame:CGRectMake(0.0f, 0.0f, x, y)])) {
		_coordinate = coordinate;
		_delegate = delegate;
		
		[self setUserInteractionEnabled:YES];

		title = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, x, y)];
        if([_url isEqualToString:@"http://i.imgur.com/3ktlggn.png"]){//Branches are black
            [title setBackgroundColor:[UIColor colorWithRed:96.0/255.0 green:125.0/255.0 blue:139.0/255.0 alpha:1.0]];
            [title setTextColor:[UIColor whiteColor]];
        }
        else{//ATM is grey
            [title setBackgroundColor:[UIColor colorWithRed:220.0/255.0 green:187.0/255.0 blue:148.0/255.0 alpha:1.0]];
            [title setTextColor:[UIColor blackColor]];
        }
		[title.layer setCornerRadius:x/4];
        title.layer.masksToBounds = YES;
		[title setTextAlignment:NSTextAlignmentCenter];
        [title setText:[coordinate title]];
        
		[self addSubview:title];
	}
    self.layer.borderColor = [UIColor blackColor].CGColor;
    return self;
}
- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
    [[self lblDistance] setText:[NSString stringWithFormat:@"%.2f km", [[self coordinate] distanceFromOrigin] / 1000.0f]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if(_delegate && [_delegate conformsToProtocol:@protocol(MarkerViewDelegate)]) {
		[_delegate didTouchMarkerView:self];
	}
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    if([_url isEqualToString:@"http://i.imgur.com/3ktlggn.png"]){
//        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"atm.jpg"]];
//        title.backgroundColor = [UIColor blueColor];
//    }
//    else{
//        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"branch.png"]];
//        title.backgroundColor = background;
//    }
    CGRect theFrame = CGRectMake(0, 0, kWidth, kHeight);
    
	return CGRectContainsPoint(theFrame, point);
}

@end
