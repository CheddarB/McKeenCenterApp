//
//  McKOpportunityInfo.h
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 5/6/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface McKOpportunityInfo : UIViewController<MFMailComposeViewControllerDelegate>

@property (nonatomic) int cellSelected;
@property (nonatomic) NSMutableArray * oppInfo;
@property (nonatomic) NSString *emailAddress;

@property (strong, nonatomic) IBOutlet UITextView *opportunityTitle;
@property (strong, nonatomic) IBOutlet UITextView *opportunitySubtitle;
@property (strong, nonatomic) IBOutlet UITextView *opportunityInformation;
@property (strong, nonatomic) IBOutlet UIButton *signupButton;

- (IBAction)signUpButton:(UIButton *)sender;

@end
