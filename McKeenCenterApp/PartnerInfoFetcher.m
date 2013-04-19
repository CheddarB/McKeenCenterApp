//
//  PartnerInfoFetcher.m
//  McKeenCenterApp
//
//  Created by Andrew Daniels on 4/17/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

#import "PartnerInfoFetcher.h"
#import "HTMLParser.h"
@implementation PartnerInfoFetcher

- (NSString *)infoForPartnerWithID:(int) id{
	//create path from id
	NSString * path = @"http://flattop.bowdoin.edu/mckeen-bridges/partners/Agency.aspx?id=";
	path = [path stringByAppendingString:[[NSNumber numberWithInt:id] stringValue]];
	
	//setup parser
	NSURL * url = [NSURL URLWithString:path];
	NSError * error = nil;
	HTMLParser * parser = [[HTMLParser alloc] initWithContentsOfURL:url error:&error];
	HTMLNode * body = [parser body];
	
	//navigate to correct spot
	HTMLNode * section = [body findChildWithAttribute:@"id" matchingName:@"two" allowPartial:NO];
	section = [section findChildWithAttribute:@"id" matchingName:@"two" allowPartial:NO];
	section = [section children][7];
	section = [section children][1];
	section = [section children][1];
	
	
	//grab data
	//site
	HTMLNode * site = [section children][0];
	NSString * siteString = [site allContents];
	
	HTMLNode * address = [section children][1];
	
	//name
	HTMLNode * name = [address children][0];
	NSString * nameString = [name contents];
	
	//street
	HTMLNode * street = [name children][1];
	NSString * streetString = [street contents];
	
	
	//town
	HTMLNode * town = [street children][2];
	NSString * townString = [PartnerInfoFetcher fixTown:[town allContents]];
	
	//phone
	HTMLNode * phone = [street children][4];
	NSString * phoneString = [phone allContents];
	
	//compose final string
	NSString * infoString = siteString;
	infoString = [infoString stringByAppendingString:@"\n"];
	infoString = [infoString stringByAppendingString:nameString];
	infoString = [infoString stringByAppendingString:@"\n"];
	infoString = [infoString stringByAppendingString:streetString];
	infoString = [infoString stringByAppendingString:@"\n"];
	infoString = [infoString stringByAppendingString:townString];
	infoString = [infoString stringByAppendingString:@"\n"];
	infoString = [infoString stringByAppendingString:phoneString];
	
	return infoString;
}

+ (NSString *)fixTown:(NSString *)town{
	NSArray * townParts = [town componentsSeparatedByString:@"\r\n"];
	town = townParts[0];
	NSString * zip = [townParts[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	town = [town stringByAppendingString:@" "];
	return [town stringByAppendingString:zip];
}

@end
