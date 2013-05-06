//
//  McKEventInfoViewController.m
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 5/5/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

#import "McKEventInfoViewController.h"

@interface McKEventInfoViewController ()

@end

@implementation McKEventInfoViewController

@synthesize cellSelected;
@synthesize eventInfo;

@synthesize eventTitle;
@synthesize eventSubtitle;
@synthesize eventDetails;

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

    [eventTitle setText: [[eventInfo objectAtIndex:cellSelected]objectAtIndex:0 ]];
    [eventSubtitle setText: [[eventInfo objectAtIndex:cellSelected]objectAtIndex:1 ]];
    if ([[eventInfo objectAtIndex:cellSelected]count] > 2){
        [eventDetails setText: [[eventInfo objectAtIndex:cellSelected]objectAtIndex:2]];
    } else [eventDetails setText:@"There is no additional information about this event. Please contact the McKeenCenter for more information."];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
