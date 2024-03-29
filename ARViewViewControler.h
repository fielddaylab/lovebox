//
//  ARViewViewControler.h
//  ARIS
//
//  Created by David J Gagnon on 12/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppModel.h"
#import "ARISAppDelegate.h"
#import "ARGeoViewController.h"
#import "NearbyObjectARCoordinate.h"


@interface ARViewViewControler : UIViewController <UIApplicationDelegate, ARViewDelegate>{
	AppModel *appModel;	
	NSMutableArray *locations;
	ARGeoViewController *ARviewController;
}

@property(nonatomic, retain) NSMutableArray *locations;

- (UIView *)viewForCoordinate:(NearbyObjectARCoordinate *)coordinate;
- (void) refresh;


@end
