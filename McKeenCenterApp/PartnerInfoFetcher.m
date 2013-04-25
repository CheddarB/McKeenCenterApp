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



/*
-(id)initWithURL:(NSURL *)url{
	self = [super init];
	self.path = url;
	return self;
}
 */

-(id)initWithURLPath:(NSString *)url andID:(int)orgID{
	self = [super init];
	
	//construct URL
	url = [url stringByAppendingString:[[NSNumber numberWithInt:orgID] stringValue]];
	NSURL * urlWithID = [NSURL URLWithString:url];
	
	//NSLog([urlWithID absoluteString]);
		
	//parser setup
	NSError * error = nil;
	HTMLParser * parser = [[HTMLParser alloc] initWithContentsOfURL:urlWithID error:&error];
	HTMLNode * body = [parser body];
	
	//navigate to correct spot
	HTMLNode * section = [body findChildWithAttribute:@"id" matchingName:@"two" allowPartial:NO];
	section = [section findChildWithAttribute:@"id" matchingName:@"two" allowPartial:NO];
	section = [section children][7];
	section = [section children][1];
	section = [section children][1];
		
	//grab data
	//site
	
	if([section children] && [[section children] count] >= 1){
		HTMLNode * siteNode = [section children][0];
		self.site = [siteNode allContents];
		
		if([[section children] count] >= 2){
			HTMLNode * addressNode = [section children][1];
			
			if([addressNode children] && [[addressNode children] count] >= 1){
				//name
				HTMLNode * nameNode = [addressNode children][0];
				self.name = [nameNode contents];
				
				if([nameNode children] && [[nameNode children] count] >= 2){
					//street
					HTMLNode * streetNode = [nameNode children][1];
					self.street = [streetNode contents];
					
					
					
					if([streetNode children] && [[streetNode children] count] >= 3){
						//town
						HTMLNode * townNode = [streetNode children][2];
						self.town = [PartnerInfoFetcher fixTown:[townNode allContents]];
						
						if ([[streetNode children] count] >= 5) {
							//phone
							HTMLNode * emailNode = [streetNode children][4];
							self.email = [emailNode allContents];
							
							if ([[streetNode children] count] >= 7) {
								//phone
								HTMLNode * phoneNode = [streetNode children][6];
								self.phone = [phoneNode allContents];
							}
						}
					}
				}
			}
		}
	}
	 
	return self;
}

-(NSString *)getAllInfo{
	
	NSString * infoString = @"";
	
	//compose final string
	if(self.site){
		infoString = self.site;
		infoString = [infoString stringByAppendingString:@"\n"];
		
		if(self.name){
			infoString = [infoString stringByAppendingString:self.name];
			infoString = [infoString stringByAppendingString:@"\n"];
			
			if(self.street){
				infoString = [infoString stringByAppendingString:self.street];
				infoString = [infoString stringByAppendingString:@"\n"];
				
				if(self.town){
					infoString = [infoString stringByAppendingString:self.town];
					infoString = [infoString stringByAppendingString:@"\n"];
					
					if(self.email){
						infoString = [infoString stringByAppendingString:self.email];
						infoString = [infoString stringByAppendingString:@"\n"];

						if (self.phone) {
							infoString = [infoString stringByAppendingString:self.phone];
						}
					}
				}
			}
		}
	}
	
	return infoString;
}

- (NSString *)getSite{
	NSString * site = nil;
	
	if(self.site){
		site = self.site;
	}
	
	return site;
}

- (NSString *)getEmail{
	NSString * email = nil;
	return email;
}

- (NSString *)getPhone{
	NSString * phone = nil;
	return phone;
}


+ (NSString *)fixTown:(NSString *)town{
	NSArray * townParts = [town componentsSeparatedByString:@"\r\n"];
	if ([townParts count] >= 2) {
		town = townParts[0];
		NSString * zip = [townParts[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		town = [town stringByAppendingString:@" "];
		town = [town stringByAppendingString:zip];
	}
	return town;
}

@end
