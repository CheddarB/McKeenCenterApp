//
//  McKUtilities.h
//  McKeenCenterApp
//
//  Created by Andrew Daniels on 5/12/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface McKUtilities : NSObject

+ (void)callPhoneNumber:(NSString *)number;
+ (void)sendEmailWithDelegate:(UIViewController<MFMailComposeViewControllerDelegate>*)delegateController toEmailAddress:(NSString *) address withContent:(NSString *)content andSubject:(NSString *)subject;
@end
