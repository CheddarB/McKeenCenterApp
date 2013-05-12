//
//  McKPartnershipsTableView.m
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 4/14/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

// helpful tutorial http://www.iosdevnotes.com/2011/10/uitableview-tutorial/

#import "McKPartnershipsTableView.h"
#import "PartnerInfoFetcher.h"
#import "McKFileRetriever.h"


@interface McKPartnershipsTableView ()

@end

@implementation McKPartnershipsTableView

@synthesize selectPrograms;
@synthesize allPrograms;
@synthesize socialIssues;
@synthesize locations;
@synthesize programTitles;

@synthesize programEmail;
@synthesize programWebsite;
@synthesize programPhoneNumber;

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

    selectPrograms =[[NSMutableDictionary alloc]init];
    allPrograms = [[NSDictionary alloc]init];
    //read parnerships file in programTitles
	
	//contruct file location on server
	NSString * serverDirectory = @"http://mobileapps.bowdoin.edu/hoyt_daniels_2013";
	NSString * fileName = @"partnerships.txt";
	NSString * fileOnServer = [serverDirectory stringByAppendingPathComponent:fileName];
	
	//retrieve the file and get its path
	NSString * path = [McKFileRetriever getDataFrom:fileOnServer forFile:fileName];
	
    //grab the contents of the file
	NSString *content = [NSString stringWithContentsOfFile:path
												  encoding:NSUTF8StringEncoding
                                                     error:NULL];
   /* NSString* path = [[NSBundle mainBundle] pathForResource:@"partnerships" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL]; */
    
	programTitles = [content componentsSeparatedByString:@"\n"];
    
    
	
	//read social_issues into socialIssues
	//contruct file location on server
	fileName = @"social_issues.txt";
	fileOnServer = [serverDirectory stringByAppendingPathComponent:fileName];
	
	//retrieve the file and get its path
	path = [McKFileRetriever getDataFrom:fileOnServer forFile:fileName];
	
    //grab the contents of the file
	content = [NSString stringWithContentsOfFile:path
										encoding:NSUTF8StringEncoding
										   error:NULL];
    /*path = [[NSBundle mainBundle] pathForResource:@"social_issues" ofType:@"txt"];
    content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];*/
    
	socialIssues = [content componentsSeparatedByString:@"\n"];
	
	
    
    //read locations in the array locations
	
	//contruct file location on server
	fileName = @"social_issues.txt";
	fileOnServer = [serverDirectory stringByAppendingPathComponent:fileName];
	
	//retrieve the file and get its path
	path = [McKFileRetriever getDataFrom:fileOnServer forFile:fileName];
	
    //grab the contents of the file
	content = [NSString stringWithContentsOfFile:path
										encoding:NSUTF8StringEncoding
										   error:NULL];
    /*path = [[NSBundle mainBundle] pathForResource:@"locations" ofType:@"txt"];
    content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];*/
    
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
    
    int socialIdentifier = [[programName substringWithRange:NSMakeRange(programName.length-9, 2)] intValue];
    int locationIdentifier = [[programName substringWithRange:NSMakeRange(programName.length-6, 2)] intValue];
    NSString *socialIssue = [[NSString alloc]init];
    NSString *location = [[NSString alloc]init];

    if ([programName characterAtIndex:programName.length-4] == ','){
    socialIssue = [socialIssues objectAtIndex:(socialIdentifier-1)];
    location = [locations objectAtIndex:locationIdentifier-1];
    }
    if ([programName characterAtIndex:programName.length-4] == ','){
        cell.detailTextLabel.text = [[socialIssue stringByAppendingString:@", "] stringByAppendingString:location];
    } else cell.detailTextLabel.text = @"";
    
    
    
    programName = [programName substringToIndex:(programName.length-10)];
    cell.textLabel.text = programName;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}

#pragma mark - Table view delegate
//make popover viewcontroller
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * headerTitle = [self tableView:tableView titleForHeaderInSection:indexPath.section];
    
    
    NSString * programName = [[allPrograms valueForKey:headerTitle] objectAtIndex:indexPath.row];
    int urlID = [[programName substringFromIndex:[programName length]-3] intValue];
    if ([programName characterAtIndex:programName.length-4] == ',')
        programName = [programName substringToIndex:(programName.length-9)];


    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	PartnerInfoFetcher * infoFetcher = [[PartnerInfoFetcher alloc] initWithURLPath:@"http://flattop.bowdoin.edu/mckeen-bridges/partners/Agency.aspx?id=" andID:urlID];
	
    
    
	//alert 
    int numberOfButtons = 0;
    NSString *buttonOne = nil;
    NSString *buttonTwo = nil;
    NSString *buttonThree = nil;
    
    programEmail = nil;
   programPhoneNumber = @"2345";
   programWebsite = @"sadfasdf.com";
    
    if (programEmail){
        numberOfButtons ++;
        buttonOne = @"email";
    }if (programWebsite){
        numberOfButtons ++;
        if (!buttonOne)
            buttonOne = @"go to website";
        else {
            buttonTwo = @"go to website";
        }
    }if (programPhoneNumber){
        numberOfButtons ++;
        if (!buttonOne)
            buttonOne = @"call";
        else if (!buttonTwo){
            buttonTwo = @"call";
        } else {
            buttonThree = @"call";
        }
    }
    if (numberOfButtons == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:[infoFetcher getAllInfo]
                                                       delegate:self cancelButtonTitle:@"dismiss" otherButtonTitles: nil];
        [alert show];
    }else if (numberOfButtons == 1){
    	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:[infoFetcher getAllInfo]
                                                       delegate:self cancelButtonTitle:@"dismiss" otherButtonTitles:buttonOne, nil];
        [alert show];
    }else if (numberOfButtons == 2){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:[infoFetcher getAllInfo]
                                                       delegate:self cancelButtonTitle:@"dismiss" otherButtonTitles:buttonOne, buttonTwo, nil];
        [alert show];
    }else if (numberOfButtons == 3){
    	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:[infoFetcher getAllInfo]
                                                       delegate:self cancelButtonTitle:@"dismiss" otherButtonTitles:buttonOne, buttonTwo, buttonThree, nil];
        [alert show];
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //u need to change 0 to other value(,1,2,3) if u have more buttons.then u can check which button was pressed.
    
    printf("%s\n", [programEmail UTF8String]);
    int numberOfButtons = alertView.numberOfButtons;
    if (buttonIndex != 0){
        if (numberOfButtons == 1){
            if (programWebsite)
            {
             //link to website
                printf("- >going to website\n");
            }
            if (programPhoneNumber)
            {
                //button to call
                printf("- >making call\n");

            }
            if (programEmail)
            {
                //button to email
                printf("-> sending email\n");

            }
        } else if (numberOfButtons == 2){
            if (!programPhoneNumber){
                if (buttonIndex == 1){
                    //send email
                    printf("1-> sending email\n");

                } else {
                    // go to website
                    printf("- >going to website\n");

                }
            } else if (!programWebsite){
                if (buttonIndex == 1){
                    //send email
                    printf("2-> sending email\n");

                } else {
                    // make phone call
                    printf("- >making call\n");

                }
            } else if (programEmail == ( NSString *) [ NSNull null ]){
                if (buttonIndex == 1){
                    // go to webite
                    printf("- >going to website\n");

                } else {
                    // make phone call
                    printf("- >making call\n");

                }
            }
        } else {
            if (buttonIndex == 1){
                //send email
                printf("3-> sending email\n");

            } else if (buttonIndex == 2){
                //go to website
                printf("- >going to website\n");

            } else {
                //make phone call
                printf("-> making call\n");

            }
        }
    }
    return;
}
- (BOOL) socialIssueShouldBeDisplayedFor: (int)socialIssueIdentifier forString:(NSString *)theProgram
{
    if (socialIssueIdentifier){
        int leangthTest = [theProgram length];
        theProgram = [theProgram substringWithRange:NSMakeRange(leangthTest-9, 2)];
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
        theProgram = [theProgram substringWithRange:NSMakeRange(leangthTest-6, 2)];
        int testInt = [theProgram intValue];
        if (locationIdentifier){
            if (testInt == locationIdentifier){
                return true;
            }
        } else return true;
        return false;
    }else return true;
}
@end
