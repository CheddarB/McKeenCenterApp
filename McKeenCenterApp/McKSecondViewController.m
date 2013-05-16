//
//  McKSecondViewController.m
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 5/6/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//
/*
 *  This is the View Controller for the second tab page: Opportunities. It is a UITableViewController
 *  and reads from the "conferences" and "jobs" files on the server, making a cell for each event.
 *  It segues to McKOpportunityInfo when a cell is pressed.
 */



#import "McKSecondViewController.h"
#import "McKFileRetriever.h"

//constants to set cell colors, alternating shades of blue
#define Red1 180
#define Green1 220
#define Blue1 200

#define Red2 150
#define Blue2 180
#define Green2 200

@interface McKSecondViewController ()

@end

@implementation McKSecondViewController

@synthesize arrayOfObjects;
@synthesize oppInfoVC;
@synthesize jobsPath;
@synthesize conferencesPath;

@synthesize toggleButtonOutlet;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setToolbarTitle];
    if ([toggleButtonOutlet.title isEqual:@"Conferences"]){
        self.navigationItem.title = @"Job Opportunities";
    } else self.navigationItem.title = @"Conferences";

    //toggleButtonOutlet.title isEqual:@"Conferences"
    //contruct file location on server
    NSString * serverDirectory = @"http://mobileapps.bowdoin.edu/hoyt_daniels_2013";
    NSString * fileName = @"jobs.txt";
    NSString * fileOnServer = [serverDirectory stringByAppendingPathComponent:fileName];
    
    //retrieve the file and get its path
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    jobsPath = [McKFileRetriever getDataFrom:fileOnServer forFile:fileName];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    //do the same for the conferencs file
    serverDirectory = @"http://mobileapps.bowdoin.edu/hoyt_daniels_2013";
    fileName = @"conferences.txt";
    fileOnServer = [serverDirectory stringByAppendingPathComponent:fileName];
    
    //retrieve the file and get its path
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    conferencesPath = [McKFileRetriever getDataFrom:fileOnServer forFile:fileName];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    arrayOfObjects = [McKOpportunityModel buildArraysOfJobsAndConferencesWithMode:[toggleButtonOutlet.title isEqual:@"Conferences"] withJobsPath:jobsPath andConferencesPath:conferencesPath];
    
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
}

- (void) setToolbarTitle
{
    if ([toggleButtonOutlet.title isEqual:@"Conferences"]){
        self.navigationItem.title = @"Job Opportunities";
    } else self.navigationItem.title = @"Conferences";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayOfObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OpportunityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[arrayOfObjects objectAtIndex: indexPath.row]objectAtIndex:0];
    if ([[[arrayOfObjects objectAtIndex: indexPath.row]objectAtIndex:1]characterAtIndex:0] != '('){
        cell.detailTextLabel.text = [[arrayOfObjects objectAtIndex: indexPath.row]objectAtIndex:1];
    } else cell.detailTextLabel.text = @"";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.textColor = [UIColor blackColor];
    
    //set alternating green backgrounds
    UIView* backgroundView = [[UIView alloc]initWithFrame:CGRectZero ];
    if (indexPath.row %2){
        backgroundView.backgroundColor = [UIColor colorWithRed: Red1/255.0 green: Green1/255.0 blue: Blue1/255.0 alpha: 1.0];
    } else
        backgroundView.backgroundColor = [UIColor colorWithRed: Red2/255.0 green: Green2/255.0 blue:Blue2/255.0 alpha: 1.0];
    cell.backgroundView = backgroundView;
    for ( UIView* view in cell.contentView.subviews )
    {
        
        view.backgroundColor = [ UIColor clearColor ];
    }
    
    
    return cell;
}

#pragma mark - Table view delegate


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"opportunityInfo"]){
        //pass the new VC the array and what row is currently selected
        oppInfoVC = (McKOpportunityInfo *)segue.destinationViewController;
        oppInfoVC.oppInfo = arrayOfObjects;
        oppInfoVC.cellSelected = self.tableView.indexPathForSelectedRow.row;
    }
}
//- (IBAction)toggleModeButton:(UIButton *)sender {
   // }
- (IBAction)toggleModeButton:(UIBarButtonItem *)sender {
    if ([toggleButtonOutlet.title isEqual:@"Conferences"]){
        toggleButtonOutlet.title = @"Job Opps";
        self.navigationItem.leftBarButtonItem = toggleButtonOutlet;
        self.navigationItem.rightBarButtonItem = nil;
    } else {
    toggleButtonOutlet.title = @"Conferences";
        self.navigationItem.rightBarButtonItem = toggleButtonOutlet;
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    arrayOfObjects = [McKOpportunityModel buildArraysOfJobsAndConferencesWithMode:[toggleButtonOutlet.title isEqual:@"Conferences"] withJobsPath:jobsPath andConferencesPath:conferencesPath];
    [self setToolbarTitle];
    [self.tableView reloadData];
}
@end
