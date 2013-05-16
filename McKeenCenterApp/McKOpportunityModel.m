//
//  McKOpportunityModel.m
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 5/16/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

#import "McKOpportunityModel.h"

@implementation McKOpportunityModel

+ (NSMutableArray *)buildArraysOfJobsAndConferencesWithMode:(BOOL) jobsMode withJobsPath:(NSString *)jobsPath andConferencesPath:(NSString *) conferencesPath
{
    NSMutableArray *arrayOfObjects = [[NSMutableArray alloc]init];
    if (jobsMode){
		//grab the contents of the file
		NSString *content = [NSString stringWithContentsOfFile:jobsPath
													  encoding:NSUTF8StringEncoding
														 error:NULL];
        
		NSArray *nonMutableArrayOfJobs = [content componentsSeparatedByString:@"~"];
        
		//make arrayOfEvents a 2D array
        arrayOfObjects = [nonMutableArrayOfJobs mutableCopy];
        for (int i = 0; i < [arrayOfObjects count]; i++){
            NSString *eventInfo = [arrayOfObjects objectAtIndex:i];
            NSArray *subArray = [eventInfo componentsSeparatedByString:@"\n"];
            [arrayOfObjects replaceObjectAtIndex:i withObject:subArray];
        }
    // if its in conferences mode
    } else {
        //grab the contents of the file
		NSString *content = [NSString stringWithContentsOfFile:conferencesPath
													  encoding:NSUTF8StringEncoding
														 error:NULL];
		//put conferences into array
        NSArray *nonMutableArrayOfJobs = [content componentsSeparatedByString:@"~"];
        //make arrayOfEvents a 2D array
        arrayOfObjects = [nonMutableArrayOfJobs mutableCopy];
        for (int i = 0; i < [arrayOfObjects count]; i++){
            NSString *eventInfo = [arrayOfObjects objectAtIndex:i];
            NSArray *subArray = [eventInfo componentsSeparatedByString:@"\n"];
            [arrayOfObjects replaceObjectAtIndex:i withObject:subArray];
        }
        
    }
    return arrayOfObjects;
}


@end
