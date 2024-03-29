//
//  JSONConnection.m
//  ARIS
//
//  Created by David J Gagnon on 8/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "JSONConnection.h"
#import "AppModel.h"
#import "ARISAppDelegate.h"
#import "ARISURLConnection.h"

@implementation JSONConnection

@synthesize jsonServerBaseURL;
@synthesize serviceName;
@synthesize methodName;
@synthesize arguments;

- (JSONConnection*)initWithArisJSONServer:(NSString *)server
			   andServiceName:(NSString *)service 
				andMethodName:(NSString *)method
				 andArguments:(NSArray *)args{
	
	self.jsonServerBaseURL = server;
	self.serviceName = service;
	self.methodName = method;	
	self.arguments = args;	

	return self;
}

- (JSONResult*) performSynchronousRequest{
	//Build the base URL string
	NSMutableString *requestString = [NSMutableString stringWithFormat:@"%@.%@.%@", 
							   self.jsonServerBaseURL, self.serviceName, self.methodName];
	
	//Add the Arguments
	NSEnumerator *argumentsEnumerator = [self.arguments objectEnumerator];
	NSString *argument;
	while (argument = [argumentsEnumerator nextObject]) {
		[requestString appendString:@"/"];
		[requestString appendString:argument];
	}

	NSLog(@"JSONConnection: JSON URL for sync request is : %@", requestString);
	
	//Convert into a NSURLRequest
	NSURL *requestURL = [NSURL URLWithString:requestString];
	NSURLRequest *requestURLRequest = [NSURLRequest requestWithURL:requestURL
													   cachePolicy:NSURLRequestReturnCacheDataElseLoad
												   timeoutInterval:60];
	
	// Make synchronous request
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[(ARISAppDelegate *)[[UIApplication sharedApplication] delegate] showWaitingIndicator: @"Loading" displayProgressBar:NO];
	
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]]; //Let the activity indicator show before doing the sync request
	
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSData *resultData = [NSURLConnection sendSynchronousRequest:requestURLRequest
											   returningResponse:&response
														   error:&error];	

	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[(ARISAppDelegate *)[[UIApplication sharedApplication] delegate] removeWaitingIndicator];

	if (error != nil) {
		NSLog(@"JSONConnection: Error communicating with server.");
		[(ARISAppDelegate *)[[UIApplication sharedApplication] delegate] showNetworkAlert];	
	}	
	
	NSString *jsonString = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
	
	//Get the JSONResult here
	JSONResult *jsonResult = [[[JSONResult alloc] initWithJSONString:jsonString] autorelease];
	[jsonString release];
	
	return jsonResult;
}

- (void) performAsynchronousRequestWithParser: (SEL)parser{
	//Build the base URL string
	NSMutableString *requestString = [[NSMutableString alloc] initWithFormat:@"%@.%@.%@", 
									  self.jsonServerBaseURL, self.serviceName, self.methodName];
	
	//Add the Arguments
	NSEnumerator *argumentsEnumerator = [self.arguments objectEnumerator];
	NSString *argument;
	while (argument = [argumentsEnumerator nextObject]) {
		[requestString appendString:@"/"];
		[requestString appendString:argument];
	}
	
	//Convert into a NSURLRequest
	NSURL *requestURL = [[NSURL alloc]initWithString:requestString];
	NSURLRequest *request = [NSURLRequest requestWithURL:requestURL
													   cachePolicy:NSURLRequestReturnCacheDataElseLoad
												   timeoutInterval:60];
	[requestURL release];
	
	//set up indicators
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	//[(ARISAppDelegate *)[[UIApplication sharedApplication] delegate] showWaitingIndicator: @"Loading"];
	
	//do it
	ARISURLConnection *urlConnection = [[ARISURLConnection alloc] initWithRequest:request delegate:self parser:parser];
	asyncData = [NSMutableData dataWithCapacity:1000];
	[asyncData retain];
	[urlConnection start];
	[urlConnection release];
	
	NSLog(@"JSONConnection: Begining Async request.  %@", requestString);
	[requestString release];

}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response
{
	NSLog(@"JSONConnection: didRevieveResponse");
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSString* tempData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"JSONConnection: Recieved Data: %@", tempData);
	[tempData release];
	
	[asyncData appendData:data];

	//NSString* tempAsyncData = [[NSString alloc] initWithData:asyncData encoding:NSUTF8StringEncoding];

	//NSLog(@"JSONConnection: Async Data is now: %@", tempAsyncData);

	

}




- (void)connectionDidFinishLoading:(ARISURLConnection *)connection {
	NSLog(@"JSONConnection: Finished Loading Data");
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	//end the loading and spinner UI indicators
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	//[(ARISAppDelegate *)[[UIApplication sharedApplication] delegate] removeWaitingIndicator];

	
	//Create a reference to the delegate using the application singleton.
	ARISAppDelegate *appDelegate = (ARISAppDelegate *) [[UIApplication sharedApplication] delegate];
	AppModel *appModel = appDelegate.appModel;
	
	NSString *jsonString = [[NSString alloc] initWithData:asyncData encoding:NSUTF8StringEncoding];
	
	//Get the JSONResult here
	JSONResult *jsonResult = [[JSONResult alloc] initWithJSONString:jsonString];
	[jsonString release];
	
	if (connection.parser) [appModel performSelector:connection.parser withObject:jsonResult];
	
	[jsonResult release];
	
	[asyncData release];
	
	[pool release];
}

- (void)connection:(ARISURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"JSONConnection: Error communicating with server.");
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	//[(ARISAppDelegate *)[[UIApplication sharedApplication] delegate] removeWaitingIndicator];
	[(ARISAppDelegate *)[[UIApplication sharedApplication] delegate] showNetworkAlert];	
	
	[asyncData release];
}


- (void)dealloc {
	[jsonServerBaseURL release];
	[serviceName release];
	[methodName release];
	[arguments release];
	
    [super dealloc];
}


@end
