//
//  McKFourthViewController.m
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 4/11/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
// <a href="http://thenounproject.com/noun/mail/#icon-No1605" target="_blank">Mail</a> designed by <a href="http://thenounproject.com/ahamzawy" target="_blank">Ahmed Hamzawy</a> from The Noun Project

#import "McKFourthViewController.h"

@interface McKFourthViewController ()

@end

@implementation McKFourthViewController

@synthesize nameTextField;
@synthesize dateTextField;
@synthesize programTextField;
@synthesize feedbackTextView;
@synthesize throughMkC;
@synthesize scrollView;
@synthesize savedScrollFrame;

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
    nameTextField.delegate = self;
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 600)];
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardDidShow)
												 name:UIKeyboardDidShowNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardDidHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated{
	savedScrollFrame = scrollView.frame;
}


- (void)keyboardDidShow{
	scrollView.frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height-165);
}

- (void)keyboardDidHide{
	scrollView.frame = savedScrollFrame;
	[scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (IBAction)cancelButton:(UIButton *)sender{
	if ([feedbackTextView isFirstResponder])
		[feedbackTextView resignFirstResponder];
	else if ([nameTextField isFirstResponder])
		[nameTextField resignFirstResponder];
	else if ([dateTextField isFirstResponder])
		[dateTextField resignFirstResponder];
	else if ([programTextField isFirstResponder])
		[programTextField resignFirstResponder];
}

- (IBAction)submitButton:(UIButton *)sender
{
    if ([MFMailComposeViewController canSendMail]) {
			//setup mailViewController
			MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
			mailViewController.mailComposeDelegate = self;
			
			//set fields of message
			NSArray *toRecipients = [[NSArray alloc]initWithObjects:@"andrew.daniels714@gmail.com", nil];
			[mailViewController setToRecipients:toRecipients]; //don't forget to change this
			[mailViewController setSubject:@"Service Report from Mobile App"];
			[mailViewController setMessageBody:[self composeEmailBody] isHTML:NO];
			
			//present mail interface
			[self presentViewController:mailViewController animated:YES completion:nil];
    }else {
        
        NSLog(@"Device is unable to send email in its current state.");
    }
       // [feedbackTextView setText:@"Thank You!"];
        feedbackTextView.text = @"Thank You!";
        nameTextField.text = @"";
        dateTextField.text = @"";
        programTextField.text = @"";
    [self cancelButton:sender];
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

- (NSString*)composeEmailBody
{
    NSString *emailMessageBody = [[NSString alloc]init];
    NSString *throughMcKCenter = [[NSString alloc]init];
    if (!throughMkC.selectedSegmentIndex)
        throughMcKCenter = @"through the McKeen Center.";
    else throughMcKCenter = @"service not affiliated with the McKeen Center.";
    emailMessageBody = [@"The following message has been submitted through the McKeen Center Mobile App;\n\nName: " stringByAppendingString:nameTextField.text];
    emailMessageBody = [[[[[[[emailMessageBody
                              stringByAppendingString:@"\nProgram date: "]
                             stringByAppendingString:dateTextField.text]
                            stringByAppendingString:@"\nProgram title: "]
                           stringByAppendingString:programTextField.text]
                          stringByAppendingString:@", "]
                         stringByAppendingString:throughMcKCenter]
                        stringByAppendingString:@"\n\n"];
    emailMessageBody = [emailMessageBody stringByAppendingString:feedbackTextView.text];
/*
    printf("%s\n", [emailMessageBody UTF8String]);
 */
    return emailMessageBody;
    
}
@end
