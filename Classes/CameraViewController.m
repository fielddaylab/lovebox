//
//  CameraViewController.m
//  ARIS
//
//  Created by David Gagnon on 3/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CameraViewController.h"
#import "ARISAppDelegate.h"
#import "AppModel.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "TitleAndDecriptionFormViewController.h"

@implementation CameraViewController

@synthesize imagePickerController;
@synthesize cameraButton;
@synthesize libraryButton;
@synthesize mediaData;
@synthesize mediaFilename;

//Override init for passing title and icon to tab bar
- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
    if (self = [super initWithNibName:nibName bundle:nibBundle]) {
        self.title = @"Camera";
        self.tabBarItem.image = [UIImage imageNamed:@"camera.png"];
		
		appModel = [(ARISAppDelegate *)[[UIApplication sharedApplication] delegate] appModel];

    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.imagePickerController = [[UIImagePickerController alloc] init];
	
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		self.cameraButton.enabled = YES;
		self.cameraButton.alpha = 1.0;
	}
	else {
		self.cameraButton.enabled = NO;
		self.cameraButton.alpha = 0.6;
	}
	
	self.imagePickerController.delegate = self;
	
	NSLog(@"Camera Loaded");
}


- (IBAction)cameraButtonTouchAction {
	NSLog(@"Camera Button Pressed");
	
	ARISAppDelegate* appDelegate = (ARISAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.nearbyBar.hidden = YES;
	
	self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
	self.imagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePickerController.sourceType];
	self.imagePickerController.allowsEditing = YES;
	self.imagePickerController.showsCameraControls = YES;
	[self presentModalViewController:self.imagePickerController animated:YES];
}


- (IBAction)libraryButtonTouchAction {
	NSLog(@"Library Button Pressed");
	ARISAppDelegate* appDelegate = (ARISAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.nearbyBar.hidden = YES;
	
	self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self presentModalViewController:self.imagePickerController animated:YES];
}


#pragma mark UIImagePickerControllerDelegate Protocol Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary  *)info

{
	NSLog(@"CameraViewController: User Selected an Image or Video");
		
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];

	//Get the data for the selected image or video
	NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	
	if ([mediaType isEqualToString:@"public.image"]){
		UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
        if (!image) image = [info objectForKey:UIImagePickerControllerOriginalImage];             
		
		NSLog(@"CameraViewController: Found an Image");
		self.mediaData = UIImageJPEGRepresentation(image, .8);
		self.mediaFilename = @"image.jpg";
	}	
	else if ([mediaType isEqualToString:@"public.movie"]){
		NSLog(@"CameraViewController: Found a Movie");
		NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
		self.mediaData = [NSData dataWithContentsOfURL:videoURL];
		self.mediaFilename = @"video.mp4";
	}	
	
	TitleAndDecriptionFormViewController *titleAndDescForm = [[TitleAndDecriptionFormViewController alloc] 
													   initWithNibName:@"TitleAndDecriptionFormViewController" bundle:nil];
	
	titleAndDescForm.delegate = self;
	//[self presentModalViewController:titleAndDescForm animated:NO];
	[self.view addSubview:titleAndDescForm.view];
}


- (void)titleAndDescriptionFormDidFinish:(TitleAndDecriptionFormViewController*)titleAndDescForm{
	NSLog(@"CameraVC: Back from form");
	[titleAndDescForm.view removeFromSuperview];
	
	ARISAppDelegate* appDelegate = (ARISAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.nearbyBar.hidden = NO;
	
	[appModel createItemAndGiveToPlayerFromFileData:self.mediaData 
										   fileName:self.mediaFilename 
											  title:titleAndDescForm.titleField.text 
										description:titleAndDescForm.descriptionField.text];

	
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
	
	ARISAppDelegate* appDelegate = (ARISAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.nearbyBar.hidden = NO;
}

#pragma mark UINavigationControllerDelegate Protocol Methods
- (void)navigationController:(UINavigationController *)navigationController 
	   didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	//nada
}

- (void)navigationController:(UINavigationController *)navigationController 
	  willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	//nada
}

#pragma mark Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[imagePickerController release];
    [super dealloc];
}


@end
