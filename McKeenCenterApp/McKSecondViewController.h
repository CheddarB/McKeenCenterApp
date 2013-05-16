//
//  McKSecondViewController.h
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 5/6/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "McKOpportunityInfo.h"
#include "McKArrayMakerModel.h"

@interface McKSecondViewController : UITableViewController

@property (nonatomic) NSMutableArray * arrayOfObjects;
@property (nonatomic) NSString * jobsPath;
@property (nonatomic) NSString * conferencesPath;

@property (strong, nonatomic) McKOpportunityInfo * oppInfoVC;


- (IBAction)toggleModeButton:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *toggleButtonOutlet;

@end
