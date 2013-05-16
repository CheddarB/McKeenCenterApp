//
//  McKThirdViewController.m
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 4/11/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//
// <a href="http://thenounproject.com/noun/handshake/#icon-No767" target="_blank">Handshake</a> designed by <a href="http://thenounproject.com/Jake_Nelsen" target="_blank">Jake Nelsen</a> from The Noun Project
#import "McKThirdViewController.h"
#import "McKFileRetriever.h"

@interface McKThirdViewController ()

@end

@implementation McKThirdViewController

@synthesize serviceIssuesArray;
@synthesize serviceType;

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
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    serviceIssuesArray = [[NSMutableArray alloc]init];
	
	//contruct file location on server
	NSString * serverDirectory = @"http://mobileapps.bowdoin.edu/hoyt_daniels_2013";
	NSString * fileName = @"social_issues.txt";
	NSString * fileOnServer = [serverDirectory stringByAppendingPathComponent:fileName];
	
	//retrieve the file and get its path
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	NSString * path = [McKFileRetriever getDataFrom:fileOnServer forFile:fileName];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
    //grab the contents of the file
	NSString *content = [NSString stringWithContentsOfFile:path
												  encoding:NSUTF8StringEncoding
                                                     error:NULL];

	//parse service issues
	NSArray *forDictionary = [content componentsSeparatedByString:@"\n"];
    [serviceIssuesArray addObject:@"all social issues"];
    for (int i = 0; i < forDictionary.count; i++){
        [serviceIssuesArray addObject:[forDictionary objectAtIndex:i]];
    }
	
	//set default service type to any
    serviceType = @"any";
}

//single component in picker view
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

//set number of options in picker view
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return [serviceIssuesArray count];
}

//get the service issue for a certain row
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [serviceIssuesArray objectAtIndex:row];
}

//set service type to the issue that is selected
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    serviceType = [serviceIssuesArray objectAtIndex:row];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
	McKPartnershipsTableView *programTableVC;
    McKLocationSelectorViewController *locationSelectorVC;
	
	//set options depending on what will be presented
    if ([segue.identifier isEqualToString:@"browseAll"]){
        programTableVC = (McKPartnershipsTableView*)segue.destinationViewController;
        programTableVC->specificSocialIssue = NULL;
    } else if ([segue.identifier isEqualToString:@"next"]){
        locationSelectorVC = (McKLocationSelectorViewController*)segue.destinationViewController;
        locationSelectorVC->socialIssue = serviceType;
    }
}

@end
