//
//  McKSecondViewController.m
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 5/6/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

#import "McKSecondViewController.h"

@interface McKSecondViewController ()

@end

@implementation McKSecondViewController

@synthesize arrayOfObjects;
@synthesize oppInfoVC;

@synthesize toggleSwitch;

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
    toggleSwitch.backgroundColor = [UIColor colorWithRed: 188.0/255.0 green: 233.0/255.0 blue:188.0/255.0 alpha: 1.0];
    [self buildArraysOfJobsAndConferences];
    
}
- (void)buildArraysOfJobsAndConferences
{
    if (toggleSwitch.selectedSegmentIndex == 0){
        //read from events file
        NSString* path = [[NSBundle mainBundle] pathForResource:@"jobs"
                                                         ofType:@"txt"];
        NSString *content = [NSString stringWithContentsOfFile:path
                                                      encoding:NSUTF8StringEncoding
                                                         error:NULL];
        NSArray *nonMutableArrayOfJobs = [content componentsSeparatedByString:@"\n\n"];
        //make arrayOfEvents a 2D array
        arrayOfObjects = [nonMutableArrayOfJobs mutableCopy];
        for (int i = 0; i < [arrayOfObjects count]; i++){
            NSString *eventInfo = [arrayOfObjects objectAtIndex:i];
            NSArray *subArray = [eventInfo componentsSeparatedByString:@"\n"];
            [arrayOfObjects replaceObjectAtIndex:i withObject:subArray];
        }
        /*
        printf("JOBS:\n");
        for (int i = 0; i < [arrayOfObjects count]; i++){
            for (int j = 0; j < [[arrayOfObjects objectAtIndex:i] count]; j++){
                printf("(%d, %d) %s\n",i,j, [[[arrayOfObjects objectAtIndex:i] objectAtIndex:j ] UTF8String]);
            }
            printf("\n");
        }
         */
    } else {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"conferences"
                                                         ofType:@"txt"];
        NSString *content = [NSString stringWithContentsOfFile:path
                                                      encoding:NSUTF8StringEncoding
                                                         error:NULL];
        NSArray *nonMutableArrayOfJobs = [content componentsSeparatedByString:@"\n\n"];
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
        backgroundView.backgroundColor = [UIColor colorWithRed: 122/255.0 green: 200/255.0 blue:122/255.0 alpha: 1.0];
    } else
        backgroundView.backgroundColor = [UIColor colorWithRed: 188.0/255.0 green: 233.0/255.0 blue:188.0/255.0 alpha: 1.0];
    cell.backgroundView = backgroundView;
    for ( UIView* view in cell.contentView.subviews )
    {
        
        view.backgroundColor = [ UIColor clearColor ];
    }
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)switchToggled:(id)sender {
    [self buildArraysOfJobsAndConferences];
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"opportunityInfo"]){
        //pass the new VC the array and what row is currently selected
        oppInfoVC = (McKOpportunityInfo *)segue.destinationViewController;
        oppInfoVC.oppInfo = arrayOfObjects;
        oppInfoVC.cellSelected = self.tableView.indexPathForSelectedRow.row;
    }
}
@end
