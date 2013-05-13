//
//  McKStaffViewController.h
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 5/7/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface McKStaffViewController : UIViewController<MFMailComposeViewControllerDelegate>

@property (nonatomic) NSString * staffName;
@property (nonatomic) NSString * staffEmail;

@property (strong, nonatomic) IBOutlet UIScrollView *staffScrollView;



- (IBAction)emailButton:(UIButton *)sender;


@end
