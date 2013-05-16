//
//  McKEventInfoViewController.h
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 5/5/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//
/*
 *  This is the header file for the event information controller.
 *  It includes relevent properties and outlets.
 */
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface McKEventInfoViewController : UIViewController<MFMailComposeViewControllerDelegate>

@property (nonatomic) int cellSelected;
@property (nonatomic) NSMutableArray * eventInfo;
@property (nonatomic) NSString *emailAddress;


@property (strong, nonatomic) IBOutlet UITextView *eventTitle;
@property (strong, nonatomic) IBOutlet UITextView *eventSubtitle;
@property (strong, nonatomic) IBOutlet UITextView *eventDetails;
@property (strong, nonatomic) IBOutlet UIButton *signupButton;
- (IBAction)signUp:(UIButton *)sender;

@end
