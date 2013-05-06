//
//  McKEventInfoViewController.h
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 5/5/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface McKEventInfoViewController : UIViewController

@property (nonatomic) int cellSelected;
@property (nonatomic) NSMutableArray * eventInfo;
@property (strong, nonatomic) IBOutlet UILabel *eventTitle;
@property (strong, nonatomic) IBOutlet UILabel *eventSubtitle;
@property (strong, nonatomic) IBOutlet UITextView *eventDetails;

@end
