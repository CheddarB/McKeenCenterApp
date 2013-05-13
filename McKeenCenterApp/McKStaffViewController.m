//
//  McKStaffViewController.m
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 5/7/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

//half finished staff section


#import "McKStaffViewController.h"

@interface McKStaffViewController ()

@end

@implementation McKStaffViewController

@synthesize staffScrollView;
@synthesize staffEmail;
@synthesize staffName;


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
   
	// Do any additional setup after loading the view.
}


- (void)viewDidAppear:(BOOL)animated{
	[staffScrollView setScrollEnabled:YES];
    [staffScrollView setContentSize:CGSizeMake(320, 731)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)emailButton:(UIButton *)sender {
    printf("%s\n", [[sender currentTitle] UTF8String]);
    if ([sender.titleLabel isEqual:@"email sarah"]){
        staffName = @"Sarah";
        staffEmail = @"sseames@bowdoin.edu";
    } else if ([[sender currentTitle] isEqual:@"email caitlin"]){
        staffName = @"Caitlin";
        staffEmail = @"ccallaha@bowdoin.edu";
    } else if ([[sender currentTitle] isEqual:@"email shawn"]){
        staffName = @"Shawn";
        staffEmail = @"sgerwig@bowdoin.edu";
    } else if ([[sender currentTitle] isEqual:@"email janice"]){
        staffName = @"Janice";
        staffEmail = @"jjaffe@bowdoin.edu";
    } else if ([[sender currentTitle] isEqual:@"email nancy"]){
        staffName = @"Nancy";
        staffEmail = @"njenning@bowdoin.edu";
    } else if ([[sender currentTitle] isEqual:@"email luke"]){
        staffName = @"Luke";
        staffEmail = @"lmondell@bowdoin.edu";
    }
    if ([MFMailComposeViewController canSendMail]) {
        //setup mailViewController
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        
        //set fields of message
        NSArray *toRecipients = [[NSArray alloc]initWithObjects:staffEmail, nil];
        [mailViewController setToRecipients:toRecipients];
		
        //present mail interface
        [self presentViewController:mailViewController animated:YES completion:nil];
    } else{
        NSLog(@"Device is unable to send email in its current state.");
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
	
	//reset scroll position and hide email window
	[staffScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
	[self dismissViewControllerAnimated:YES completion:nil];
	
}

@end
