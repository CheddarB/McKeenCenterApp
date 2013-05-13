//
//  McKUtilities.m
//  McKeenCenterApp
//
//  Created by Andrew Daniels on 5/12/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

#import "McKUtilities.h"

@implementation McKUtilities

+ (void)callPhoneNumber:(NSString *)number{
	NSString * device = [UIDevice  currentDevice].model;
	if ([device isEqualToString:@"iPhone"]) {
		NSString * phoneURLString = [@"tel://" stringByAppendingString:number];
		NSURL * phoneURL = [NSURL URLWithString:phoneURLString];
		[[UIApplication sharedApplication] openURL:phoneURL];
	} else{
		NSString * errorMessage = [NSString stringWithFormat:@"Not able to make call with %@",device];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Phone Not Available"
														message:errorMessage
													   delegate:self
											  cancelButtonTitle:@"okay"
											  otherButtonTitles:nil];
		[alert show];
	}
	
}

@end
