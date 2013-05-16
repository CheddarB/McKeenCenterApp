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


//grabs html from url with id, and sets info fields if possible
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
	NSMutableArray * data = [NSMutableArray arrayWithCapacity:6];
	
	if([section children] && [[section children] count] >= 1){
		HTMLNode * siteNode = [section children][0];
		
		//add to data array if not nil
		if ([siteNode allContents]) {
			[data addObject:[siteNode allContents]];
		}
				
		if([[section children] count] >= 2){
			HTMLNode * addressNode = [section children][1];
			
			if([addressNode children] && [[addressNode children] count] >= 1){
				//name
				HTMLNode * nameNode = [addressNode children][0];
				
				if ([nameNode contents]) {
					[data addObject:[nameNode contents]];
				}
				
				if([nameNode children] && [[nameNode children] count] >= 2){
					//street
					HTMLNode * streetNode = [nameNode children][1];
					if ([streetNode contents]) {
						[data addObject:[streetNode contents]];
					}
					
					
					
					if([streetNode children] && [[streetNode children] count] >= 3){
						//town
						HTMLNode * townNode = [streetNode children][2];
						
						if ([townNode allContents]) {
							[data addObject:[townNode allContents]];
						}
						
						if ([[streetNode children] count] >= 5) {
							//phone
							HTMLNode * emailNode = [streetNode children][4];
							
							if ([emailNode allContents]) {
								[data addObject:[emailNode allContents]];
							}
							
							if ([[streetNode children] count] >= 7) {
								//phone
								HTMLNode * phoneNode = [streetNode children][6];
								
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

//check if something is a phone number
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
