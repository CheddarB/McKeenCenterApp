//
//  McKFileRetriever.m
//  McKeenCenterApp
//
//  Created by Andrew Daniels on 5/8/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

#import "McKFileRetriever.h"

@implementation McKFileRetriever

+ (NSString *) getDataFrom:(NSString *)url forFile:(NSString *)name{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
	NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
	
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
	
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
        return nil;
    }
	
    //retreive response data
	NSString * response =  [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
		
	//compose path for file
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *dir = [paths objectAtIndex: 0];
	NSString *path = [dir stringByAppendingPathComponent:name];
	
	
	//write to file
	[response writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:&error];
	
	//return the file path
	return path;
}

@end
