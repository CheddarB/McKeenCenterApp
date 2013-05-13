//
//  McKSecondViewController.h
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 5/6/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "McKOpportunityInfo.h"

@interface McKSecondViewController : UITableViewController

@property (nonatomic) NSMutableArray * arrayOfObjects;
@property (strong, nonatomic) McKOpportunityInfo * oppInfoVC;

//- (IBAction)toggleModeButton:(UIButton *)sender;
//@property (strong, nonatomic) IBOutlet UIButton *toggleButtonOutlet;
- (IBAction)toggleModeButton:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *toggleButtonOutlet;

@end
