//
//  McKLocationSelector.h
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 4/15/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "McKPartnershipsTableView.h"
@interface McKLocationSelector : UIViewController{
    @public
    NSString *socialIssue;
    
}
@property (strong, nonatomic) IBOutlet UIPickerView *locationPicker;
@property (nonatomic) NSMutableArray* locationsArray;
@property (nonatomic) NSString * location;

@end
