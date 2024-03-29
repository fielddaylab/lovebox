//
//  ARISAppDelegate.h
//  ARIS
//
//  Created by Ben Longoria on 2/11/09.
//  Copyright University of Wisconsin 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "model/AppModel.h";

#import "LoginViewController.h";
#import "GenericWebViewController.h";
#import "MyCLController.h"

#import "model/Game.h"
#import "NearbyBar.h"
#import "Item.h"
#import "ItemDetailsViewController.h"

#import "QuestsViewController.h"
#import "GPSViewController.h"
#import "InventoryListViewController.h"
#import "CameraViewController.h"
#import "AudioRecorderViewController.h"
#import "ARViewViewControler.h"
#import "QRScannerViewController.h"
#import "GamePickerViewController.h"
#import "LogoutViewController.h"
#import "StartOverViewController.h"
#import "DeveloperViewController.h"
#import "WaitingIndicatorViewController.h"
#import "AudioToolbox/AudioToolbox.h"

#import "Reachability.h"



@interface ARISAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, UINavigationControllerDelegate> {
	AppModel *appModel;
	UIWindow *window;
    UITabBarController *tabBarController;
	NearbyBar *nearbyBar;
	MyCLController *myCLController;
	LoginViewController *loginViewController;
	UINavigationController *nearbyObjectNavigationController;
	WaitingIndicatorViewController *waitingIndicator;
	UIAlertView *networkAlert;
}

@property (nonatomic, retain) AppModel *appModel;
@property (nonatomic, retain) MyCLController *myCLController;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet LoginViewController *loginViewController;
@property (nonatomic, retain) IBOutlet NearbyBar *nearbyBar;
@property (nonatomic, retain) IBOutlet UINavigationController *nearbyObjectNavigationController;
@property (nonatomic, retain) WaitingIndicatorViewController *waitingIndicator;
@property (nonatomic, retain) UIAlertView *networkAlert;


- (void) displayNearbyObjectView:(UIViewController *)nearbyObjectViewController;
- (void) showWaitingIndicator:(NSString *)message displayProgressBar:(BOOL)yesOrNo;
- (void) removeWaitingIndicator;
- (void) showNetworkAlert;
- (void) removeNetworkAlert;
- (BOOL) checkInternet;
- (void) playAudioAlert:(NSString*)wavFileName shouldVibrate:(BOOL)shouldVibrate;
- (void)displayClosestObjectView;

@end
