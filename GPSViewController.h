//
//  GPSViewController.h
//  ARIS
//
//  Created by Ben Longoria on 2/11/09.
//  Copyright 2009 University of Wisconsin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppModel.h"
#import "Location.h"
#import <MapKit/MapKit.h>
#import "Annotation.h"
#import "ARISMoviePlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>




@interface GPSViewController : UIViewController <MKMapViewDelegate> {
	AppModel *appModel;
	NSArray *locations;
	BOOL autoCenter;
	BOOL somethingNearby;

	IBOutlet MKMapView *mapView;
	IBOutlet UIBarButtonItem *mainButton;
	BOOL silenceNextServerUpdate;
	
	MPMoviePlayerController *mMoviePlayer; //only used if item is a video


}

-(void) refresh;
-(void) zoomAndCenterMap;
- (IBAction)mainButtonTouchAction;


@property BOOL autoCenter;
@property (nonatomic, retain) NSArray *locations;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *mainButton;

@end
