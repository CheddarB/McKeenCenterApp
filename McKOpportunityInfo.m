//
//  McKOpportunityInfo.m
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 5/6/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

#import "McKOpportunityInfo.h"

@interface McKOpportunityInfo ()

@end

@implementation McKOpportunityInfo

@synthesize oppInfo;
@synthesize cellSelected;
@synthesize emailAddress;

@synthesize opportunityTitle;
@synthesize opportunitySubtitle;
@synthesize opportunityInformation;
@synthesize signupButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    signupButton.hidden = YES;
    [opportunityTitle setText: [[oppInfo objectAtIndex:cellSelected]objectAtIndex:0 ]];
    [opportunitySubtitle setText: [[oppInfo objectAtIndex:cellSelected]objectAtIndex:1 ]];    
    if ([[[oppInfo objectAtIndex:cellSelected]objectAtIndex:1 ]characterAtIndex:0] == '('){
        [opportunitySubtitle setText:@""];
    }

    if ([[oppInfo objectAtIndex:cellSelected]count] > 2){
        [opportunityInformation setText: [[oppInfo objectAtIndex:cellSelected]objectAtIndex:2]];
    } else [opportunityInformation setText:@"There is no additional information about this opportunity. Please contact the McKeenCenter for more information."];
    if ([[oppInfo objectAtIndex:cellSelected]objectAtIndex:2]){
        char buttonMode = [[[oppInfo objectAtIndex:cellSelected]objectAtIndex:3]characterAtIndex:0];
        if ((buttonMode == 'y') || (buttonMode == 'Y')){
            signupButton.hidden = NO;
        } else signupButton.hidden = YES;
    } else signupButton.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUpButton:(UIButton *)sender {
   
        NSString *fourthLine = [[NSString alloc]init];
        NSArray *arrayOfFourthLine = [[NSArray alloc]init];
        if ([oppInfo count] > 3){
            fourthLine = [[oppInfo objectAtIndex:cellSelected]objectAtIndex:3];
            arrayOfFourthLine = [fourthLine componentsSeparatedByString:@" "];
        } else fourthLine = @"";
        if ([arrayOfFourthLine count]>1){
            emailAddress = [arrayOfFourthLine objectAtIndex:1];
        } else emailAddress = @"";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"email to signup or for more information"
                                                       delegate:self cancelButtonTitle:@"cancel" otherButtonTitles: @"email", nil];
        [alert show];
    
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
		//send email
		NSString * subject = [@"Mobile App: " stringByAppendingString:[[oppInfo objectAtIndex:cellSelected]objectAtIndex:0]];
		[McKUtilities sendEmailWithDelegate:self
							 toEmailAddress:emailAddress
								withContent:nil
								 andSubject:subject];
		
    }
}
//MFMailComposeViewControllerDelegate method
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
	if (result==MFMailComposeResultSent) {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sent!"
                                                        message:@"Your message was sent successfully"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
		[alert show];
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}
@end
