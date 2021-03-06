//
//  McKThirdViewController.h
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 4/11/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//
/*
 * Header file for Third View Controller, contains properties
 */
#import <UIKit/UIKit.h>
#include "McKLocationSelectorViewController.h"

@interface McKThirdViewController : UIViewController{
}
@property (strong, nonatomic) IBOutlet UIPickerView *servicePicker;

@property (nonatomic) NSMutableArray *serviceIssuesArray;
@property (nonatomic) NSString *serviceType;

@end
