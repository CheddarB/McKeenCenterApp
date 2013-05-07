//
//  McKContactViewController.m
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 4/15/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

#import "McKContactViewController.h"
#define STARTING_DELTA .004
@interface McKContactViewController ()

@end

@implementation McKContactViewController

@synthesize mapView;

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
    mapView.mapType = MKMapTypeHybrid;

    CLLocationCoordinate2D myCoordinate = {43.908266, -69.961828};
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.title = @"McKeen Center for the Common Good";
    point.subtitle = @"South Side of the Chapel";
    point.coordinate = myCoordinate;
    [self.mapView addAnnotation:point];
    MKCoordinateRegion region;
    //Set Zoom level using Span
    MKCoordinateSpan span;
    region.center=myCoordinate;
    span.latitudeDelta=STARTING_DELTA;
    span.longitudeDelta=STARTING_DELTA;
    region.span=span;
    [mapView setRegion:region animated:TRUE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)phoneButton:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://2077894113"]];
}
@end
