//
//  McKUtilities.m
//  McKeenCenterApp
//
//  Created by Andrew Daniels on 5/12/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//
/*
 *  This utilities model includes methods for making phone calls and sending emails
 */
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
											  cancelButtonTitle:@"Cancel"
											  otherButtonTitles:nil];
		[alert show];
	}
	
}
+ (void)sendEmailWithDelegate:(UIViewController<MFMailComposeViewControllerDelegate>*)delegateController toEmailAddress:(NSString *) address withContent:(NSString *)content andSubject:(NSString *)subject{
	if ([MFMailComposeViewController canSendMail]) {
		//setup mailViewController
		MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
		mailViewController.mailComposeDelegate = delegateController;
		
		//set fields of message
		NSArray *toRecipients = [[NSArray alloc]initWithObjects:address, nil];
		[mailViewController setToRecipients:toRecipients];
		[mailViewController setSubject:subject];
        [mailViewController setMessageBody:content isHTML:NO];
		//present mail interface
		[delegateController presentViewController:mailViewController animated:YES completion:nil];
	}else {
		NSLog(@"Device is unable to send email in its current state.");
	}
}


@end
