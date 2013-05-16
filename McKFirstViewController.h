//
//  McKFirstViewController.h
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 5/5/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McKEventInfoViewController.h"
#import "McKArrayMakerModel.h"

@interface McKFirstViewController : UITableViewController

@property (nonatomic) NSMutableArray *arrayOfEvents;
@property (strong, nonatomic) McKEventInfoViewController *eventInfoVC;

@end
