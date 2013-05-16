//
//  McKEventsModel.m
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 5/16/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

#import "McKEventsModel.h"

@implementation McKEventsModel

+(NSMutableArray *)getArrayFromString:(NSString *) path
{
    NSMutableArray *arrayOfEvents = [[NSMutableArray alloc]init];
    //grab the contents of the file
	NSString *content = [NSString stringWithContentsOfFile:path
												  encoding:NSUTF8StringEncoding
                                                     error:NULL];
	//populate array of events
	NSArray *nonMutableArrayOfEvents = [content componentsSeparatedByString:@"~"];
    
    //make arrayOfEvents a 2D array
    arrayOfEvents = [nonMutableArrayOfEvents mutableCopy];
    for (int i = 0; i < [arrayOfEvents count]; i++){
        NSString *eventInfo = [arrayOfEvents objectAtIndex:i];
        NSArray *subArray = [eventInfo componentsSeparatedByString:@"\n"];
        [arrayOfEvents replaceObjectAtIndex:i withObject:subArray];
    }
    return arrayOfEvents;
}

@end
