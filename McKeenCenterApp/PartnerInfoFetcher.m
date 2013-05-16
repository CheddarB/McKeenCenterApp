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
	
	NSMutableArray * data = [NSMutableArray arrayWithCapacity:6];
	
	if([section children] && [[section children] count] >= 1){
		HTMLNode * siteNode = [section children][0];
		//self.site = [siteNode allContents];
		
		//add to data array if not nil
		if ([siteNode allContents]) {
			[data addObject:[siteNode allContents]];
		}
				
		if([[section children] count] >= 2){
			HTMLNode * addressNode = [section children][1];
			
			if([addressNode children] && [[addressNode children] count] >= 1){
				//name
				HTMLNode * nameNode = [addressNode children][0];
				//self.name = [nameNode contents];
				
				if ([nameNode contents]) {
					[data addObject:[nameNode contents]];
				}
				
				if([nameNode children] && [[nameNode children] count] >= 2){
					//street
					HTMLNode * streetNode = [nameNode children][1];
					//self.street = [streetNode contents];
					if ([streetNode contents]) {
						[data addObject:[streetNode contents]];
					}
					
					
					
					if([streetNode children] && [[streetNode children] count] >= 3){
						//town
						HTMLNode * townNode = [streetNode children][2];
						//self.town = [PartnerInfoFetcher fixTown:[townNode allContents]];
						
						if ([townNode allContents]) {
							[data addObject:[townNode allContents]];
						}
						
						if ([[streetNode children] count] >= 5) {
							//phone
							HTMLNode * emailNode = [streetNode children][4];
							//self.email = [emailNode allContents];
							
							if ([emailNode allContents]) {
								[data addObject:[emailNode allContents]];
							}
							
							if ([[streetNode children] count] >= 7) {
								//phone
								HTMLNode * phoneNode = [streetNode children][6];
								//self.phone = [phoneNode allContents];
								
								if ([phoneNode allContents]) {
									[data addObject:[phoneNode allContents]];
								}
							}
						}
					}
				}
			}
		}
	}
	
	//set site
	for (NSString * path in data) {
		if([path rangeOfString:@"www"].length > 0 || [path rangeOfString:@"http"].length > 0){
			self.site = path;
			
			//add http if missing
			if([self.site rangeOfString:@"http"].length <= 0){
				self.site = [@"http://" stringByAppendingString:self.site];
			}
		}
	}
	
	//set email
	for (NSString * address in data) {
		if([address rangeOfString:@"@"].length > 0){
			self.email = address;
		}
	}
		
	//set phone
	for(NSString * number in data){
		if([[PartnerInfoFetcher isPhoneNumber:number] length] > 0){
			self.phone = [PartnerInfoFetcher isPhoneNumber:number];
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
	
	
	if (self.site) {
		site = self.site;
	}
	
	return site;
}

- (NSString *)getEmail{
	NSString * email = nil;
	
	if (self.email) {
		email = self.email;
	}

	return email;
}

- (NSString *)getPhone{
	
	NSString * phone = nil;
	
	if (self.phone) {
		phone = self.phone;
	}
	
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

+ (NSString *)isPhoneNumber:(NSString *)number{
	NSCharacterSet * nums = [NSCharacterSet decimalDigitCharacterSet];
	NSString * numberFinal = @"";
	NSString * numberSection = @"";
	
	NSArray * components = [number componentsSeparatedByString:@"-"];
	for(NSString * component in components){
				
		for (int i = 0; i < [component length]; i++){
			if([nums characterIsMember:[component characterAtIndex:i]]){
				unichar c= [component characterAtIndex:i];
				numberSection = [numberSection stringByAppendingString:[NSString stringWithCharacters:&c length:1]];
			}
		}
				
		if([numberSection length] >= 3)
			numberFinal = [numberFinal stringByAppendingString:numberSection];
		
		numberSection = @"";
			
	}
	
	
	if ([numberFinal length] >= 10) {
		//if num is more than 10 digits, it includes an extension
		if ([numberFinal length] > 10) {
			numberFinal = [numberFinal substringToIndex:10];
		}
		return numberFinal;
	} else {
		return @"";
	}
}

//checks for email address based on @ containment
+ (NSString *)isEmail:(NSString *)email{
	for(int i=0; i < [email length]; i++){
		if([email characterAtIndex:i]=='@')
			return email;
	}
	
	return @"";
}

@end
