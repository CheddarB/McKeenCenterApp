//
//  McKThirdViewController.m
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 4/11/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//
// <a href="http://thenounproject.com/noun/handshake/#icon-No767" target="_blank">Handshake</a> designed by <a href="http://thenounproject.com/Jake_Nelsen" target="_blank">Jake Nelsen</a> from The Noun Project
#import "McKThirdViewController.h"

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
    serviceIssuesArray = [[NSMutableArray alloc]init];

    NSString* path = [[NSBundle mainBundle] pathForResource:@"social_issues"
                                                     ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    NSArray *forDictionary = [content componentsSeparatedByString:@"\n"];
    [serviceIssuesArray addObject:@"all social issues"];
    for (int i = 0; i < forDictionary.count; i++){
        [serviceIssuesArray addObject:[forDictionary objectAtIndex:i]];
    }
    serviceType = @"any";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [serviceIssuesArray count];
}
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [serviceIssuesArray objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
  //  NSLog(@"Selected service: %@.", [serviceIssuesArray objectAtIndex:row]);
    serviceType = [serviceIssuesArray objectAtIndex:row];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    McKPartnershipsTableView *programTableVC;
    McKLocationSelector *locationSelectorVC;
    if ([segue.identifier isEqualToString:@"browseAll"]){
        programTableVC = (McKPartnershipsTableView*)segue.destinationViewController;
        programTableVC->specificSocialIssue = NULL;
    } else if ([segue.identifier isEqualToString:@"next"]){
        locationSelectorVC = (McKLocationSelector*)segue.destinationViewController;
        locationSelectorVC->socialIssue = serviceType;
    }

}

@end
