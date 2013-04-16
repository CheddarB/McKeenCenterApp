//
//  McKFourthViewController.m
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 4/11/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
// <a href="http://thenounproject.com/noun/mail/#icon-No1605" target="_blank">Mail</a> designed by <a href="http://thenounproject.com/ahamzawy" target="_blank">Ahmed Hamzawy</a> from The Noun Project

#import "McKFourthViewController.h"

@interface McKFourthViewController ()

@end

@implementation McKFourthViewController

@synthesize nameTextField;
@synthesize dateTextField;
@synthesize programTextField;
@synthesize feedbackTextView;

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
    feedbackTextView.delegate = (id)self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (BOOL)textFieldShouldReturn:(UITextView *)textField
{
    NSLog(@"Getting Called...");
    [feedbackTextView setUserInteractionEnabled:YES];
    [feedbackTextView resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"Called");
}


@end
