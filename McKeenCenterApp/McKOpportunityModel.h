//
//  McKOpportunityModel.h
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 5/16/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface McKOpportunityModel : NSObject

+  (NSMutableArray *)buildArraysOfJobsAndConferencesWithMode:(BOOL) conferenceMode withJobsPath:(NSString *)jobsPath andConferencesPath:(NSString *) conferencesPath;

@end

