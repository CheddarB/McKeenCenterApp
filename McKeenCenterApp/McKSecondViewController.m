//
//  McKSecondViewController.m
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 5/6/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

#import "McKSecondViewController.h"
#import "McKFileRetriever.h"

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
    toggleButtonOutlet.backgroundColor = [UIColor colorWithRed: 188.0/255.0 green: 233.0/255.0 blue:188.0/255.0 alpha: 1.0];
    //toggleSwitch.backgroundColor = [UIColor colorWithRed: 188.0/255.0 green: 233.0/255.0 blue:188.0/255.0 alpha: 1.0];
    [self buildArraysOfJobsAndConferences];
    
}
- (void)buildArraysOfJobsAndConferences
{
    NSLog(toggleButtonOutlet.currentTitle);
    if ([toggleButtonOutlet.currentTitle isEqual:@"view conferences"]){
        //contruct file location on server
		NSString * serverDirectory = @"http://mobileapps.bowdoin.edu/hoyt_daniels_2013";
		NSString * fileName = @"jobs.txt";
		NSString * fileOnServer = [serverDirectory stringByAppendingPathComponent:fileName];
		
		//retrieve the file and get its path
		NSString * path = [McKFileRetriever getDataFrom:fileOnServer forFile:fileName];
		
		//grab the contents of the file
		NSString *content = [NSString stringWithContentsOfFile:path
													  encoding:NSUTF8StringEncoding
														 error:NULL];
        
		NSArray *nonMutableArrayOfJobs = [content componentsSeparatedByString:@"~"];
        
        printf("###%d###", [nonMutableArrayOfJobs count]);
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
    
		NSString * serverDirectory = @"http://mobileapps.bowdoin.edu/hoyt_daniels_2013";
		NSString * fileName = @"conferences.txt";
		NSString * fileOnServer = [serverDirectory stringByAppendingPathComponent:fileName];
		
		//retrieve the file and get its path
		NSString * path = [McKFileRetriever getDataFrom:fileOnServer forFile:fileName];
		
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
    
    //set alternating grey backgrounds
    UIView* backgroundView = [[UIView alloc]initWithFrame:CGRectZero ];
    if (indexPath.row %2){
        backgroundView.backgroundColor = [UIColor colorWithRed: 160/255.0 green: 250/255.0 blue:160/255.0 alpha: 1.0];
    } else
        backgroundView.backgroundColor = [UIColor colorWithRed: 188.0/255.0 green: 233.0/255.0 blue:188.0/255.0 alpha: 1.0];
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
- (IBAction)toggleModeButton:(UIButton *)sender {
    if ([toggleButtonOutlet.currentTitle isEqual:@"view conferences"]){
        [toggleButtonOutlet setTitle:@"view jobs and opportunities" forState:UIControlStateNormal];
    } else [toggleButtonOutlet setTitle:@"view conferences" forState:UIControlStateNormal];
    [self buildArraysOfJobsAndConferences];
    [self.tableView reloadData];

}
@end
