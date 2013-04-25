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
	
	NSString * content = [section allContents];
	NSLog(@"%@", content);
	
	//grab data
	//site
	
	if([section children] && [[section children] count] >= 1){
		HTMLNode * siteNode = [section children][0];
		self.site = [siteNode allContents];
		NSLog(@"%@",self.site);
		
		if([[section children] count] >= 2){
			HTMLNode * addressNode = [section children][1];
			
			if([addressNode children] && [[addressNode children] count] >= 1){
				//name
				HTMLNode * nameNode = [addressNode children][0];
				self.name = [nameNode contents];
				NSLog(@"%@", self.name);
				
				if([nameNode children] && [[nameNode children] count] >= 2){
					//street
					HTMLNode * streetNode = [nameNode children][1];
					self.street = [streetNode contents];
					NSLog(@"%@", self.street);
					
					if([streetNode children] && [[streetNode children] count] >= 3){
						//town
						HTMLNode * townNode = [streetNode children][2];
						self.town = [PartnerInfoFetcher fixTown:[townNode allContents]];
						NSLog(@"%@",self.town);
						
						if ([[streetNode children] count] >= 5) {
							//phone
							HTMLNode * phoneNode = [streetNode children][4];
							self.phone = [phoneNode allContents];
							NSLog(@"%@", self.phone);
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
					
					if(self.phone){
						infoString = [infoString stringByAppendingString:self.phone];
					}
				}
			}
		}
	}
	
	return infoString;
}

- (NSString *)getSite{
	if(self.site){
		return self.site;
	}else{
		return @"";
	}
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
