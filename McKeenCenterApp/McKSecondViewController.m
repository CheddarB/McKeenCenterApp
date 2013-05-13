//
//  McKSecondViewController.m
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 5/6/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

#import "McKSecondViewController.h"
#import "McKFileRetriever.h"

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
    [self buildArraysOfJobsAndConferences];
    
}
- (void)buildArraysOfJobsAndConferences
{
    
    if ([toggleButtonOutlet.title isEqual:@"conferences"]){
        self.navigationItem.title = @"Jobs Opportunities";

        //contruct file location on server
		NSString * serverDirectory = @"http://mobileapps.bowdoin.edu/hoyt_daniels_2013";
		NSString * fileName = @"jobs.txt";
		NSString * fileOnServer = [serverDirectory stringByAppendingPathComponent:fileName];
		
		//retrieve the file and get its path
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		NSString * path = [McKFileRetriever getDataFrom:fileOnServer forFile:fileName];
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		
		//grab the contents of the file
		NSString *content = [NSString stringWithContentsOfFile:path
													  encoding:NSUTF8StringEncoding
														 error:NULL];
        
		NSArray *nonMutableArrayOfJobs = [content componentsSeparatedByString:@"~"];
        
		//make arrayOfEvents a 2D array
        arrayOfObjects = [nonMutableArrayOfJobs mutableCopy];
        for (int i = 0; i < [arrayOfObjects count]; i++){
            NSString *eventInfo = [arrayOfObjects objectAtIndex:i];
            NSArray *subArray = [eventInfo componentsSeparatedByString:@"\n"];
            [arrayOfObjects replaceObjectAtIndex:i withObject:subArray];
        }
        
        printf("JOBS:\n");
        for (int i = 0; i < [arrayOfObjects count]; i++){
            for (int j = 0; j < [[arrayOfObjects objectAtIndex:i] count]; j++){
                printf("(%d, %d) %s\n",i,j, [[[arrayOfObjects objectAtIndex:i] objectAtIndex:j ] UTF8String]);
            }
            printf("\n");
        }
         
    } else {
        self.navigationItem.title = @"Conferences";
		NSString * serverDirectory = @"http://mobileapps.bowdoin.edu/hoyt_daniels_2013";
		NSString * fileName = @"conferences.txt";
		NSString * fileOnServer = [serverDirectory stringByAppendingPathComponent:fileName];
		
		//retrieve the file and get its path
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		NSString * path = [McKFileRetriever getDataFrom:fileOnServer forFile:fileName];
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		
		//grab the contents of the file
		NSString *content = [NSString stringWithContentsOfFile:path
													  encoding:NSUTF8StringEncoding
														 error:NULL];
		//put conferences into array
        NSArray *nonMutableArrayOfJobs = [content componentsSeparatedByString:@"~"];
        //make arrayOfEvents a 2D array
        arrayOfObjects = [nonMutableArrayOfJobs mutableCopy];
        for (int i = 0; i < [arrayOfObjects count]; i++){
            NSString *eventInfo = [arrayOfObjects objectAtIndex:i];
            NSArray *subArray = [eventInfo componentsSeparatedByString:@"\n"];
            [arrayOfObjects replaceObjectAtIndex:i withObject:subArray];
        }
        /*
        printf("CONFERENCES:\n");
        for (int i = 0; i < [arrayOfObjects count]; i++){
            for (int j = 0; j < [[arrayOfObjects objectAtIndex:i] count]; j++){
                printf("(%d, %d) %s\n",i,j, [[[arrayOfObjects objectAtIndex:i] objectAtIndex:j ] UTF8String]);
            }
            printf("\n");
        }
         */
        
    }
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
    if ([toggleButtonOutlet.title isEqual:@"conferences"]){
        toggleButtonOutlet.title = @"job opps";
        self.navigationItem.leftBarButtonItem = toggleButtonOutlet;
        self.navigationItem.rightBarButtonItem = nil;
    } else {
    toggleButtonOutlet.title = @"conferences";
        self.navigationItem.rightBarButtonItem = toggleButtonOutlet;
        self.navigationItem.leftBarButtonItem = nil;
    }

    [self buildArraysOfJobsAndConferences];
    [self.tableView reloadData];
    

}
@end
