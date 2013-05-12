//
//  McKPartnershipsTableView.h
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 4/14/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McKThirdViewController.h"
#import "PartnerInfoFetcher.h"

@interface McKPartnershipsTableView : UITableViewController<UIActionSheetDelegate>{
@public
    NSString *specificSocialIssue;
    NSString *specificLocation;
}

@property (strong, nonatomic) NSMutableDictionary * selectPrograms;
@property (strong, nonatomic) NSDictionary * allPrograms;

@property (nonatomic) int actionSheetMode;

@property (nonatomic) NSArray * socialIssues;
@property (nonatomic) NSArray *locations;
@property (nonatomic) NSArray *programTitles;

@property (nonatomic) NSString * programEmail;
@property (nonatomic) NSString * programWebsite;
@property (nonatomic) NSString * programPhoneNumber;

@end
