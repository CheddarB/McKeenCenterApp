//
//  McKPartnershipsTableView.m
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 4/14/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

// helpful tutorial http://www.iosdevnotes.com/2011/10/uitableview-tutorial/

#import "McKPartnershipsTableView.h"


@interface McKPartnershipsTableView ()

@end

@implementation McKPartnershipsTableView

@synthesize selectPrograms;
@synthesize allPrograms;
@synthesize socialIssues;
@synthesize browseAllMode;
@synthesize locations;

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
    browseAllMode = YES;
    selectPrograms =[[NSMutableDictionary alloc]init];
    allPrograms = [[NSDictionary alloc]init];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"partnerships"
                                                     ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    NSArray *forDictionary = [content componentsSeparatedByString:@"\n"];
    
    NSMutableArray *keys = [[NSMutableArray alloc]init];
    NSMutableArray *objects = [[NSMutableArray alloc]init];
    
    NSMutableArray * objectsForOneKey = [[NSMutableArray alloc]init];
    
    
    
    path = [[NSBundle mainBundle] pathForResource:@"social_issues"
                                           ofType:@"txt"];
    content = [NSString stringWithContentsOfFile:path
                                        encoding:NSUTF8StringEncoding
                                           error:NULL];
    socialIssues = [content componentsSeparatedByString:@"\n"];
    path = [[NSBundle mainBundle] pathForResource:@"locations"
                                           ofType:@"txt"];
    content = [NSString stringWithContentsOfFile:path
                                        encoding:NSUTF8StringEncoding
                                           error:NULL];
    locations = [content componentsSeparatedByString:@"\n"];
    // iterate through NSArray to make dictionary with first letter as Key
    for (int i = 0; i < forDictionary.count; i++){
        if (i){
            if (![[[forDictionary objectAtIndex:i] substringToIndex: 1] isEqualToString:[[forDictionary objectAtIndex:i-1] substringToIndex: 1]]){
                [keys addObject:[[forDictionary objectAtIndex:i] substringToIndex: 1]];
                NSArray * arrayForObject = [objectsForOneKey copy];
                [objects addObject:arrayForObject];
                [objectsForOneKey removeAllObjects];
            }
            [objectsForOneKey addObject:[forDictionary objectAtIndex:i]];
            if (i == forDictionary.count -1){
                NSArray * arrayForObject = [objectsForOneKey copy];
                [objects addObject:arrayForObject];            }
        } else {
            [keys addObject:[[forDictionary objectAtIndex:i] substringToIndex: 1]];
            [objectsForOneKey addObject:[forDictionary objectAtIndex:i]];
        }
    }
    NSArray *nonMutableKeys = [keys copy];
    NSArray *nonMutableObjecs = [objects copy];
    allPrograms = [NSDictionary dictionaryWithObjects:nonMutableObjecs
                                        forKeys:nonMutableKeys];
    //dictionary made with first letter as Key and array of strings as objects


    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (browseAllMode)
        return [allPrograms count];
    else return 0;
    //returned the number of keys in the dictionary (max 26)
        
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (browseAllMode){
        return [[[allPrograms allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]objectAtIndex:section];
    } else return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[allPrograms objectForKey:[[[allPrograms allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
    //returned the number of objects in an array for a certain key

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProgramCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...

    NSString * headerTitle = [self tableView:tableView titleForHeaderInSection:indexPath.section];
    NSString * programName = [[allPrograms valueForKey:headerTitle] objectAtIndex:indexPath.row];

    int socialIdentifier = [[programName substringWithRange:NSMakeRange(programName.length-5, 2)] intValue];
    int locationIdentifier = [[programName substringWithRange:NSMakeRange(programName.length-2, 2)] intValue];

    
    NSString *socialIssue = [socialIssues objectAtIndex:socialIdentifier];
    NSString *location = [locations objectAtIndex:locationIdentifier];
    if ([programName characterAtIndex:programName.length-3] == ','){
        printf("YES\n");
        cell.detailTextLabel.text = [[socialIssue stringByAppendingString:@", "] stringByAppendingString:location];
    } else cell.detailTextLabel.text = @"";

    

    programName = [programName substringToIndex:(programName.length-6)];
    cell.textLabel.text = programName;

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;


    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * headerTitle = [self tableView:tableView titleForHeaderInSection:indexPath.section];
    NSString * programName = [[allPrograms valueForKey:headerTitle] objectAtIndex:indexPath.row];
    programName = [programName substringToIndex:(programName.length-6)];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"You selected %@!", programName] delegate:nil cancelButtonTitle:@"dismiss" otherButtonTitles:nil];
    [alert show];
    
    // Navigation logic may go here. Create and push another view controller.
    
    // UIViewController *detailViewController = [[UIViewController alloc] initWithNibName:@"programInfo" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    // [self.navigationController pushViewController:alert animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
