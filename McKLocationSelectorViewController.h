//
//  McKLocationSelector.h
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 4/15/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//
/*
 *  This header file for the location selector view controller. It contains all relevent properties.
 */
#import <UIKit/UIKit.h>
#include "McKPartnershipsTableViewController.h"
@interface McKLocationSelectorViewController : UIViewController{
    @public
    NSString *socialIssue;
    
}

@property (strong, nonatomic) IBOutlet UIPickerView *locationPicker;
@property (nonatomic) NSMutableArray* locationsArray;
@property (nonatomic) NSString * location;

@end
