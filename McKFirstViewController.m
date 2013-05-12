//
//  McKFirstViewController.m
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 5/5/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

#import "McKFirstViewController.h"
#import "McKFileRetriever.h"

@interface McKFirstViewController ()

@end

@implementation McKFirstViewController

@synthesize arrayOfEvents;
@synthesize eventInfoVC;

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
    
    //contruct file location on server
	NSString * serverDirectory = @"http://mobileapps.bowdoin.edu/hoyt_daniels_2013";
	NSString * fileName = @"events.txt";
	NSString * fileOnServer = [serverDirectory stringByAppendingPathComponent:fileName];
	
	//retrieve the file and get its path
	NSString * path = [McKFileRetriever getDataFrom:fileOnServer forFile:fileName];
	
    //grab the contents of the file
	NSString *content = [NSString stringWithContentsOfFile:path
												  encoding:NSUTF8StringEncoding
                                                     error:NULL];
	//populate array of events
	NSArray *nonMutableArrayOfEvents = [content componentsSeparatedByString:@"~"];
	 
    //make arrayOfEvents a 2D array
    arrayOfEvents = [nonMutableArrayOfEvents mutableCopy];
    for (int i = 0; i < [arrayOfEvents count]; i++){
        NSString *eventInfo = [arrayOfEvents objectAtIndex:i];
        NSArray *subArray = [eventInfo componentsSeparatedByString:@"\n"];
        [arrayOfEvents replaceObjectAtIndex:i withObject:subArray];
    }
/*
    for (int i = 0; i < [arrayOfEvents count]; i++){
        for (int j = 0; j < [[arrayOfEvents objectAtIndex:i] count]; j++){
            printf("(%d, %d) %s\n",i,j, [[[arrayOfEvents objectAtIndex:i] objectAtIndex:j ] UTF8String]);
        }
        printf("\n");
    }
*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayOfEvents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[arrayOfEvents objectAtIndex: indexPath.row]objectAtIndex:0];
    cell.detailTextLabel.text = [[arrayOfEvents objectAtIndex: indexPath.row]objectAtIndex:1];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.textColor = [UIColor blackColor];

    //set alternating grey backgrounds
    UIView* backgroundView = [[UIView alloc]initWithFrame:CGRectZero ];
    if (indexPath.row %2){
        backgroundView.backgroundColor = [UIColor colorWithRed: 180.0/255.0 green: 200.0/255.0 blue:220.0/255.0 alpha: 1.0];
    } else
        backgroundView.backgroundColor = [UIColor colorWithRed: 152.0/255.0 green: 187.0/255.0 blue:228.0/255.0 alpha: 1.0];
    cell.backgroundView = backgroundView;
    for ( UIView* view in cell.contentView.subviews )
    {
        
        view.backgroundColor = [ UIColor clearColor ];
    }
   

    return cell;
}

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
