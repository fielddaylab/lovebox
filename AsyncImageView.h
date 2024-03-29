//
//  AsyncImageView.h
//  ARIS
//
//  Created by David J Gagnon on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Media.h"

@interface AsyncImageView : UIImageView {
	NSURLConnection* connection; //keep a reference to the connection so we can cancel download in dealloc
	NSMutableData* data; //keep reference to the data so we can collect it as it downloads
	Media *media; //keep a refrence so we can update the media with the data after it is loaded
	
}

- (void) loadImageFromMedia:(Media *) aMedia;
- (UIImage*) getImage;
- (void) updateViewWithNewImage:(UIImage*)image;

@end


