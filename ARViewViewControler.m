//
//  ARViewViewControler.m
//  ARIS
//
//  Created by David J Gagnon on 12/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ARViewViewControler.h"
#import "AsyncImageView.h"
#import "NearbyObjectARCoordinate.h"
#import "Location.h"


@implementation ARViewViewControler

@synthesize locations;

//Override init for passing title and icon to tab bar
- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
    self = [super initWithNibName:nibName bundle:nibBundle];
    if (self) {
        self.title = @"AR View - EXPERIMENTAL";
        self.tabBarItem.image = [UIImage imageNamed:@"camera.png"];
		appModel = [(ARISAppDelegate *)[[UIApplication sharedApplication] delegate] appModel];
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {	
	
	ARviewController = [[ARGeoViewController alloc] init];
	ARviewController.debugMode = NO;
	ARviewController.delegate = self;
	ARviewController.scaleViewsBasedOnDistance = NO;
	ARviewController.minimumScaleFactor = .5;
	ARviewController.rotateViewsBasedOnPerspective = NO;

	
	//Init with the nearby locations in the model
	NSMutableArray *tempLocationArray = [[NSMutableArray alloc] initWithCapacity:10];
	
	NearbyObjectARCoordinate *tempCoordinate;
	for ( Location *nearbyLocation in appModel.nearbyLocationsList ) {		
		tempCoordinate = [NearbyObjectARCoordinate coordinateWithNearbyLocation: nearbyLocation];
		[tempLocationArray addObject:tempCoordinate];
		NSLog(@"ARViewViewController: Added %@", tempCoordinate.title);
	}
	
	
	/* Example point being added
	CLLocation *tempLocation;
	ARGeoCoordinate *tempCoordinate;
	tempLocation = [[CLLocation alloc] initWithCoordinate:location altitude:1609.0 horizontalAccuracy:1.0 verticalAccuracy:1.0 timestamp:[NSDate date]];
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation];
	tempCoordinate.title = @"Denver";
	[tempLocationArray addObject:tempCoordinate];
	*/
	
	
	[ARviewController addCoordinates:tempLocationArray];
	
	ARviewController.centerLocation = appModel.playerLocation;
	[ARviewController startListening];
	
	[[(ARISAppDelegate *)[[UIApplication sharedApplication] delegate] window] addSubview:ARviewController.view];
	
	//Add a close button
	UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[closeButton setTitle:@"Close" forState:UIControlStateNormal];	
	[closeButton addTarget:self action:@selector(closeButtonTouched) forControlEvents:UIControlEventTouchUpInside];
	closeButton.frame = CGRectMake(50, 50, 50, 50);
	[ARviewController.view addSubview:closeButton];
	
	
    // Override point for customization after application launch
    [[(ARISAppDelegate *)[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];	
	
	
	
	[super viewDidLoad];
	NSLog(@"ARView Loaded");
}


- (void)closeButtonTouched {
	NSLog(@"ARViewViewController: close button pressed");
	//[self dismissModalViewControllerAnimated:NO];
	//[self.view removeFromSuperview];
	//[self.cameraController dismissModalViewControllerAnimated:NO];
	//[self release];
	[ARviewController dismissModalViewControllerAnimated:NO]; //bad code

}


#define BOX_WIDTH 300
#define BOX_HEIGHT 320

- (UIView *)viewForCoordinate:(NearbyObjectARCoordinate *)coordinate {
	
	CGRect theFrame = CGRectMake(0, 0, BOX_WIDTH, BOX_HEIGHT);
	UIView *tempView = [[UIView alloc] initWithFrame:theFrame];
		
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BOX_WIDTH, 20.0)];
	titleLabel.backgroundColor = [UIColor colorWithWhite:.3 alpha:.8];
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.text = coordinate.title;
	[titleLabel sizeToFit];
	titleLabel.frame = CGRectMake(BOX_WIDTH / 2.0 - titleLabel.frame.size.width / 2.0 - 4.0, 0, titleLabel.frame.size.width + 8.0, titleLabel.frame.size.height + 8.0);
	
	
	AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectZero];
	imageView.frame = CGRectMake((int)(BOX_WIDTH / 2.0 - 300 / 2.0), 20, 300, 300);
	if (coordinate.mediaId != 0) {
		Media *imageMedia = [appModel mediaForMediaId: coordinate.mediaId];
		[imageView loadImageFromMedia:imageMedia];
	}
	else imageView.image = [UIImage imageNamed:@"location.png"];

	//[imageView addTarget:self action:@selector(closeButtonTouched) forControlEvents:UIControlEventTouchUpInside];
	
	[tempView addSubview:titleLabel];
	[tempView addSubview:imageView];
	
	[titleLabel release];
	[imageView release];
	
	return [tempView autorelease];
}

- (void)refresh {
	
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
