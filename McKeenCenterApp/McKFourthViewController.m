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
    [feedbackTextView setReturnKeyType: UIReturnKeyDone];
    if ([feedbackTextView isFirstResponder]){
        CGRect frame = feedbackTextView.frame;
        frame.origin.y = frame.origin.y+300;
        feedbackTextView.frame = frame;
    }
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textView: (UITextView*)textView shouldChangeTextInRange: (NSRange*)range
{
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [feedbackTextView endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

@end
