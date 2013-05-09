//
//  McKFileRetriever.h
//  McKeenCenterApp
//
//  Created by Andrew Daniels on 5/8/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface McKFileRetriever : NSObject

//Gets data from the given URL and saves it with the specified file name
//HTTP request code borrowed from Jason Whitehorn via stackoverflow
+ (NSString *) getDataFrom:(NSString *)url forFile:name;
@end
