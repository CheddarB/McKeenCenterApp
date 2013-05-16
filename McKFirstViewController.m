//
//  McKFirstViewController.m
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 5/5/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//
/*
 *  This is the View Controller for the first tab page: Events. It is a UITableViewController
 *  and reads from the "events" file on the server, making a cell for each event. It segues
 *  to McKEventInfoViewController when a cell is pressed.
 */

#import "McKFirstViewController.h"
#import "McKFileRetriever.h"

//constants to set cell colors, alternating shades of blue
#define Red1 180
#define Green1 200
#define Blue1 220

#define Red2 150
#define Blue2 200
#define Green2 180

@interface McKFirstViewController ()

@end

@implementation McKFirstViewController

@synthesize arrayOfEvents;
@synthesize eventInfoVC;

// called when the page loads, reads the events file from server and calls the array maker
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //contruct file location on server
	NSString * serverDirectory = @"http://mobileapps.bowdoin.edu/hoyt_daniels_2013";
	NSString * fileName = @"events.txt";
	NSString * fileOnServer = [serverDirectory stringByAppendingPathComponent:fileName];
	
	//retrieve the file and get its path
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	NSString * path = [McKFileRetriever getDataFrom:fileOnServer forFile:fileName];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
	// calls model method to set array that is used to make table view
    arrayOfEvents = [McKArrayMakerModel getArrayFromString:path];
}

// always set to one section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// number of cells is the number of objects in array of events
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayOfEvents count];
}

// format the cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // set title and subtitle
    cell.textLabel.text = [[arrayOfEvents objectAtIndex: indexPath.row]objectAtIndex:0];
    cell.detailTextLabel.text = [[arrayOfEvents objectAtIndex: indexPath.row]objectAtIndex:1];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.textColor = [UIColor blackColor];

    //set alternating grey backgrounds for asthetics
    UIView* backgroundView = [[UIView alloc]initWithFrame:CGRectZero ];
    if (indexPath.row %2){
        backgroundView.backgroundColor = [UIColor colorWithRed: Red1/255.0 green: Green1/255.0 blue:Blue1/255.0 alpha: 1.0];
    } else
        backgroundView.backgroundColor = [UIColor colorWithRed: Red2/255.0 green: Green2/255.0 blue:Blue2/255.0 alpha: 1.0];
    cell.backgroundView = backgroundView;
    for ( UIView* view in cell.contentView.subviews )
    {
        view.backgroundColor = [ UIColor clearColor ];
    }
   
    return cell;
}
// called when a cell is selected, segway declared in storyboard
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"eventInfo"]){
        //pass the new VC the array and what row is currently selected
        eventInfoVC = (McKEventInfoViewController *)segue.destinationViewController;
        eventInfoVC.eventInfo = arrayOfEvents;
        eventInfoVC.cellSelected = self.tableView.indexPathForSelectedRow.row;
    }
}

@end
