//
//  McKFourthViewController.h
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 4/11/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface McKFourthViewController : UIViewController <UITextFieldDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *dateTextField;
@property (strong, nonatomic) IBOutlet UITextField *programTextField;
@property (strong, nonatomic) IBOutlet UITextView *feedbackTextView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *throughMkC;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) CGRect savedScrollFrame;

- (IBAction)cancelButton:(UIButton *)sender;
- (IBAction)submitButton:(UIButton*)sender;

@property (strong, nonatomic) IBOutlet UIView *fourthView;

@end
