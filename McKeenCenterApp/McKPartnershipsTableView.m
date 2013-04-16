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
@synthesize locations;
@synthesize programTitles;

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
        
    printf("specific social issue: %s.\nspecific location: %s.\n", [specificSocialIssue UTF8String], [specificLocation UTF8String]);
    selectPrograms =[[NSMutableDictionary alloc]init];
    allPrograms = [[NSDictionary alloc]init];
    //read parnerships file in programTitles
    NSString* path = [[NSBundle mainBundle] pathForResource:@"partnerships" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    programTitles = [content componentsSeparatedByString:@"\n"];
    
    //read social_issues into socailIssues
    path = [[NSBundle mainBundle] pathForResource:@"social_issues" ofType:@"txt"];
    
    content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    socialIssues = [content componentsSeparatedByString:@"\n"];
    
    //read locations in the array locations
    path = [[NSBundle mainBundle] pathForResource:@"locations" ofType:@"txt"];
    content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    locations = [content componentsSeparatedByString:@"\n"];
    [self initDictionaryAndFinishInit];
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)initDictionaryAndFinishInit
{
    NSMutableArray *keys = [[NSMutableArray alloc]init];
    NSMutableArray *objects = [[NSMutableArray alloc]init];
    NSMutableArray * objectsForOneKey = [[NSMutableArray alloc]init];

    //sdfsdf
    int specificLocationKey = 0;
    int specificSocialIssueKey = 0;
    
    //figure out which social issue display (if only one)
    for (int i = 0; i < socialIssues.count; i++){
        NSString *socialIssuesIteration = [socialIssues objectAtIndex:i];
        if ([socialIssuesIteration isEqualToString:specificSocialIssue]){
            specificSocialIssueKey = i + 1;     // +1 b/c of the "any" button
        }
    }
    
    //figure out which location to display (if only one)
    for (int i = 0; i < locations.count; i++){
        NSString *locationsIteration = [locations objectAtIndex:i];
        if ([locationsIteration isEqualToString:specificLocation]){
            specificLocationKey = i + 1;                 }
    }
    printf("specific social issue key: %d.\nspecific location key: %d.\n", specificSocialIssueKey, specificLocationKey);
    
    // iterate through NSArray to make dictionary with first letter as Key
    NSString * mostRecentlyAddedProgramTitle = NULL;
    for (int i = 0; i < programTitles.count; i++){
        if (([self socialIssueShouldBeDisplayedFor:specificSocialIssueKey forString:
              [programTitles objectAtIndex:i]] && [self locationShouldBeDisplayedFor:specificLocationKey forString:[programTitles objectAtIndex: i]])){
            if (mostRecentlyAddedProgramTitle){
                if (![[[programTitles objectAtIndex:i] substringToIndex: 1] isEqualToString:[mostRecentlyAddedProgramTitle substringToIndex:1]]){
                    [keys addObject:[[programTitles objectAtIndex:i] substringToIndex: 1]];
                    NSArray * arrayForObject = [objectsForOneKey copy];
                    [objects addObject: arrayForObject];
                    [objectsForOneKey removeAllObjects];
                }
                mostRecentlyAddedProgramTitle = [programTitles objectAtIndex:i];
                [objectsForOneKey addObject:[programTitles objectAtIndex:i]];
            } else {
                [keys addObject:[[programTitles objectAtIndex:i] substringToIndex: 1]];
                mostRecentlyAddedProgramTitle = [programTitles objectAtIndex:i];
                [objectsForOneKey addObject:[programTitles objectAtIndex:i]];
            }
        }
    }
    if ([objectsForOneKey count]){
        NSArray * arrayForObject = [objectsForOneKey copy];
        [objects addObject:arrayForObject];
    }
    // in case it is empty
    if (![keys count]){
        [keys addObject:@""];
        NSMutableArray * forEmptyDictionary = [[NSMutableArray alloc]init];
        [forEmptyDictionary addObject:@"No Programs Match Your Search"];
        [objects addObject: forEmptyDictionary];
    }
    //make the dictionary
    NSArray *nonMutableKeys = [keys copy];
    NSArray *nonMutableObjecs = [objects copy];
    allPrograms = [NSDictionary dictionaryWithObjects:nonMutableObjecs
                                              forKeys:nonMutableKeys];
    //dictionary made with first letter as Key and array of strings as each Object

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [allPrograms count];
    //returned the number of keys in the dictionary (max 26 if file is alphabetical)
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return [[[allPrograms allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]objectAtIndex:section];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[allPrograms objectForKey:[[[allPrograms allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
    
    // number of objects in allprograms object at (sectionth key)
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
    NSString *socialIssue = [[NSString alloc]init];
    NSString *location = [[NSString alloc]init];

    if ([programName characterAtIndex:programName.length-3] == ','){
    socialIssue = [socialIssues objectAtIndex:(socialIdentifier-1)];
    location = [locations objectAtIndex:locationIdentifier-1];
    }
    if ([programName characterAtIndex:programName.length-3] == ','){
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
    if ([programName characterAtIndex:programName.length-3] == ',')
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
- (BOOL) socialIssueShouldBeDisplayedFor: (int)socialIssueIdentifier forString:(NSString *)theProgram
{
    if (socialIssueIdentifier){
        int leangthTest = [theProgram length];
        theProgram = [theProgram substringWithRange:NSMakeRange(leangthTest-5, 2)];
        int testInt = [theProgram intValue];
        if (socialIssueIdentifier){
            if (testInt == socialIssueIdentifier){
                return true;
            }
        } else return true;
        return false;
    } else return true;
}
- (BOOL) locationShouldBeDisplayedFor: (int)locationIdentifier forString:(NSString *)theProgram
{
    if (locationIdentifier){
        int leangthTest = [theProgram length];
        theProgram = [theProgram substringWithRange:NSMakeRange(leangthTest-2, 2)];
        int testInt = [theProgram intValue];
        if (locationIdentifier){
            if (testInt == locationIdentifier){
                return true;
            }
        } else return true;
        return false;
    }else return true;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    McKProgramInfoViewController *programInfoDestinataion;
    if ([segue.identifier isEqualToString:@"programInfo"]){
        programInfoDestinataion = (McKProgramInfoViewController*)segue.destinationViewController;
        programInfoDestinataion->title = @"title";
    }
}
@end
