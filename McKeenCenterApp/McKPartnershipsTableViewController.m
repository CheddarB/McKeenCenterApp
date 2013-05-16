//
//  McKPartnershipsTableView.m
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 4/14/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

// helpful tutorial http://www.iosdevnotes.com/2011/10/uitableview-tutorial/

#import "McKPartnershipsTableViewController.h"
#import "PartnerInfoFetcher.h"
#import "McKFileRetriever.h"
#import "McKUtilities.h"


@interface McKPartnershipsTableViewController ()

@end

@implementation McKPartnershipsTableViewController

@synthesize actionSheetMode;
@synthesize numberOfButtons;

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
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	NSString * path = [McKFileRetriever getDataFrom:fileOnServer forFile:fileName];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
    //grab the contents of the file
	NSString *content = [NSString stringWithContentsOfFile:path
												  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
	programTitles = [content componentsSeparatedByString:@"\n"];
    
    
	
	//read social_issues into socialIssues
	//contruct file location on server
	fileName = @"social_issues.txt";
	fileOnServer = [serverDirectory stringByAppendingPathComponent:fileName];
	
	//retrieve the file and get its path
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	path = [McKFileRetriever getDataFrom:fileOnServer forFile:fileName];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
    //grab the contents of the file
	content = [NSString stringWithContentsOfFile:path
										encoding:NSUTF8StringEncoding
										   error:NULL];

    
	socialIssues = [content componentsSeparatedByString:@"\n"];
	
	
    
    //read locations in the array locations
	
	//contruct file location on server
	fileName = @"locations.txt";
	fileOnServer = [serverDirectory stringByAppendingPathComponent:fileName];
	
	//retrieve the file and get its path
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	path = [McKFileRetriever getDataFrom:fileOnServer forFile:fileName];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
    //grab the contents of the file
	content = [NSString stringWithContentsOfFile:path
										encoding:NSUTF8StringEncoding
										   error:NULL];
    
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
    for (int i = 0; i < programTitles.count-1; i++){
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


//make uiaction sheet for selected program
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * headerTitle = [self tableView:tableView titleForHeaderInSection:indexPath.section];
    
    
    NSString * programName = [[allPrograms valueForKey:headerTitle] objectAtIndex:indexPath.row];
    int urlID = [[programName substringFromIndex:[programName length]-3] intValue];
    if ([programName characterAtIndex:programName.length-4] == ',')
        programName = [programName substringToIndex:(programName.length-9)];
	
	PartnerInfoFetcher * infoFetcher = [[PartnerInfoFetcher alloc] initWithURLPath:@"http://flattop.bowdoin.edu/mckeen-bridges/partners/Agency.aspx?id=" andID:urlID];
	
    //reset number of buttons and actionsheet mode
	numberOfButtons = 0;
	actionSheetMode = 0;
    
    
    programEmail = infoFetcher.email;
    programEmail = [infoFetcher getEmail];
    [programEmail stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    programPhoneNumber = infoFetcher.phone;
    [programPhoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    programWebsite = infoFetcher.site;
    [programWebsite stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    programWebsite = [programWebsite stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    programWebsite = [programWebsite stringByReplacingOccurrencesOfString:@" " withString:@""];
    programWebsite = [infoFetcher getSite];
    
    
    printf("email, phone, web: \nE: %s\nP: %s\nWS: --%s--\n", [programEmail UTF8String], [programPhoneNumber UTF8String], [programWebsite UTF8String]);
    
    if ([programEmail length]){
        numberOfButtons ++;
        actionSheetMode = 1;
    }
	
	if ([programPhoneNumber length]){
        numberOfButtons ++;
        if (numberOfButtons == 1){
            actionSheetMode = 2;
        }else {
            actionSheetMode = 4;
        }
    }
	
	if ([programWebsite length]){
        numberOfButtons ++;
        if (numberOfButtons == 1){
            actionSheetMode = 3;
        } else if (numberOfButtons == 2){
            if ([programEmail length]){
                actionSheetMode = 5;
			} else{
				actionSheetMode = 6;
			}
        } else {
            actionSheetMode = 7;
        }
    }
    
    printf("number of button: %d in mode %d\n", numberOfButtons, actionSheetMode);
    
    UIActionSheet *actionSheet = [self buildActionSheetWithProgramTitle:programName];

    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    printf("button index: %d\n", buttonIndex);
	if (buttonIndex == numberOfButtons) {
		[actionSheet showInView:[self.view window]];
	}else if ((actionSheetMode > 0) && (actionSheetMode < 4)){
        if ([programEmail length]){
            //email
			[self sendEmail];
        } else if ([programPhoneNumber length]){
			//call
			[McKUtilities callPhoneNumber:programPhoneNumber];
        } else if ([programWebsite length]){
			//open site
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:programWebsite]];
        }
    } else if ((actionSheetMode > 3) && (actionSheetMode < 7)){
        if (![programEmail length]){
            if (buttonIndex == 0){
				//*phone*
				[McKUtilities callPhoneNumber:programPhoneNumber];
            } else{
				//open site
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:programWebsite]];
			}
        } else if (![programPhoneNumber length]){
            if (buttonIndex == 0){
				//email
				[self sendEmail];
            } else{
				//open site
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:programWebsite]];
			}
        } else if (![programWebsite length]){
            if (buttonIndex == 0){
				//email
				[self sendEmail];
            } else{
				//*phone*
				[McKUtilities callPhoneNumber:programPhoneNumber];
			}
        }
    } else if (actionSheetMode == 7){
        if (buttonIndex == 0){
			//email
			[self sendEmail];
        } else if (buttonIndex == 1){
			//*phone*
			[McKUtilities callPhoneNumber:programPhoneNumber];
        } else {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:programWebsite]];
		}
    }
}
-(UIActionSheet*) buildActionSheetWithProgramTitle:(NSString *)title
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:[title stringByAppendingString:@"\n\nContact the McKeen Center for More Information"]
                                  delegate:self
                                  cancelButtonTitle:@"dismiss"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles: nil];
    
    switch (actionSheetMode)
    {
        case 1:
            actionSheet = [[UIActionSheet alloc]
                           initWithTitle:title
                           delegate:self
                           cancelButtonTitle:@"dismiss"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"email", nil];
            return actionSheet;
        case 2:
            actionSheet = [[UIActionSheet alloc]
                           initWithTitle:title
                           delegate:self
                           cancelButtonTitle:@"dismiss"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"call", nil];
            return actionSheet;
        case 3:
            actionSheet = [[UIActionSheet alloc]
                           initWithTitle:title
                           delegate:self
                           cancelButtonTitle:@"dismiss"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"website", nil];
            return actionSheet;
            
        case 4:
            actionSheet = [[UIActionSheet alloc]
                           initWithTitle:title
                           delegate:self
                           cancelButtonTitle:@"dismiss"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"email",@"call", nil];
            return actionSheet;
        case 5:
            actionSheet = [[UIActionSheet alloc]
                           initWithTitle:title
                           delegate:self
                           cancelButtonTitle:@"dismiss"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"email",@"website", nil];
            return actionSheet;
        case 6:
            actionSheet = [[UIActionSheet alloc]
                           initWithTitle:title
                           delegate:self
                           cancelButtonTitle:@"dismiss"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"call",@"website", nil];
            return actionSheet;
        case 7:
            actionSheet = [[UIActionSheet alloc]
                           initWithTitle:title
                           delegate:self
                           cancelButtonTitle:@"dismiss"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"email",@"call",@"website", nil];
            return actionSheet;
            break;
    }
    return actionSheet;
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

//MFMailComposeViewControllerDelegate method
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
	if (result==MFMailComposeResultSent) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sent!"
														message:@"Your message was sent successfully"
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

//open window to send an email to programEmail
- (void)sendEmail{
	if ([MFMailComposeViewController canSendMail]) {
		//setup mailViewController
		MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
		mailViewController.mailComposeDelegate = self;
		
		//set fields of message
		NSArray *toRecipients = [[NSArray alloc]initWithObjects:programEmail, nil];
		[mailViewController setToRecipients:toRecipients];
		
		//present mail interface
		[self presentViewController:mailViewController animated:YES completion:nil];
	}else {
		NSLog(@"Device is unable to send email in its current state.");
	}
}


@end
