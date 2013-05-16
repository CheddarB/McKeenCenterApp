//
//  McKLocationSelector.m
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 4/15/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

#import "McKLocationSelectorViewController.h"
#import "McKFileRetriever.h"

@interface McKLocationSelectorViewController ()

@end

@implementation McKLocationSelectorViewController
@synthesize locationsArray;
@synthesize location;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    locationsArray = [[NSMutableArray alloc]init];
	
	//contruct file location on server
	NSString * serverDirectory = @"http://mobileapps.bowdoin.edu/hoyt_daniels_2013";
	NSString * fileName = @"locations.txt";
	NSString * fileOnServer = [serverDirectory stringByAppendingPathComponent:fileName];
	
	//retrieve the file and get its path
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	NSString * path = [McKFileRetriever getDataFrom:fileOnServer forFile:fileName];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
    //grab the contents of the file
	NSString *content = [NSString stringWithContentsOfFile:path
												  encoding:NSUTF8StringEncoding
                                                     error:NULL];
	
	//parse locations from the file
	NSArray *forDictionary = [content componentsSeparatedByString:@"\n"];
    
	//add option for all locations to locations list 
	[locationsArray addObject:@"all locations"];
	
	//add all locations to locations list
    for (int i = 0; i < forDictionary.count; i++){
        [locationsArray addObject:[forDictionary objectAtIndex:i]];
    }
    location = NULL;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [locationsArray count];
}
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [locationsArray objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    //  NSLog(@"Selected service: %@.", [serviceIssuesArray objectAtIndex:row]);
    location = [locationsArray objectAtIndex:row];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    McKPartnershipsTableView *tableDelegate;
    if ([segue.identifier isEqualToString:@"browse2"]){
        tableDelegate = (McKPartnershipsTableView*)segue.destinationViewController;
        tableDelegate->specificLocation = location;
        tableDelegate->specificSocialIssue = socialIssue;
    } else if ([segue.identifier isEqualToString:@"browseAll2"]){
        tableDelegate = (McKPartnershipsTableView*)segue.destinationViewController;
        tableDelegate->specificLocation = @" ";
        tableDelegate->specificSocialIssue = @" ";
    }
}


@end