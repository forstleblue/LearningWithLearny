//
//  ListOfSequencesViewController.m
//  LearningWithLenny
//
//  Created by snow on 7/25/13.
//  Copyright (c) 2013 JinHong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ListOfSequencesViewController.h"
#import "SettingsViewController.h"
#import "NameConstant.h"
#import "LWLSAppDelegate.h"
#import "AddyourOwnSequenceViewController.h"

#define TABLECELL_HEIGHT 30

@interface ListOfSequencesViewController ()

@end

@implementation ListOfSequencesViewController

@synthesize pointer;
@synthesize tableSequece;
@synthesize backgroundScrollView, sequencesTableView;
@synthesize sequenceListArray, selectStatusArray;
@synthesize homeButton, addOwnButton, onSettingButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [backgroundScrollView release];
    [sequencesTableView release];
    [sequenceListArray release];
    [selectStatusArray release];
    
    [homeButton release];
    [addOwnButton release];
    [onSettingButton release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selectCount = 0;
    self.pointer = [[ ReadData alloc] init];
    self.backgroundScrollView.delegate = self;
    self.backgroundScrollView.scrollEnabled = YES;
    
    beforeRandonNumber = -1;
    deselectAllData = NO;
    preTableCount = 0;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    LWLSAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [self.randomSwitch setOn:NO];
    
    self.sequenceListArray = [[NSMutableArray alloc] initWithCapacity:0];
    int dataCount = [self.pointer getDataCount];
    int rndNumber = [defaults integerForKey:RandomNumber];
    
    //Get the entire talbe item data
    appDelegate.sequenceTitle = [[NSMutableArray alloc] init];
    BOOL threePic = [defaults boolForKey:ThreePicKey];
    BOOL fourPic = [defaults boolForKey:FourPicKey];
    if(threePic == YES)
    {
        for(int i = 0 ; i < dataCount ; i++)
        {
            
            NSString* sequenceLabel = [self.pointer getSequenceLabelName:i];
            [appDelegate.sequenceTitle addObject:sequenceLabel];
        }
    }
    
    anotherData =[[DataManager sharedInstance] m_Data];
    for(int i = 0; i < [anotherData count]; i++)
    {
        NSMutableDictionary* dict = [anotherData objectAtIndex:i];
        NSMutableArray* item = [dict objectForKey:THIRD_KEY];
        NSString* sequenceLabel = [dict objectForKey:FIRST_KEY];
        int imageCount = [item count];
        if(imageCount == 3)
        {
            if(threePic == YES)
                [appDelegate.sequenceTitle  addObject:sequenceLabel];
            
        }
        if(imageCount == 4)
        {
            if(fourPic == YES)
            {
                [appDelegate.sequenceTitle  addObject:sequenceLabel];
                
            }
        }
    }
    
    totalCount = [appDelegate.sequenceTitle count];
    if(totalCount == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please Select Picture Item " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    if(totalCount != appDelegate.totalCount)
    {
        appDelegate.totalCount = totalCount;
        appDelegate.globalTableSequence = [self.pointer entireTableSequence:totalCount];
    }
    self.tableRandomArray = appDelegate.globalTableSequence;
    
    NSMutableArray* randArray = [[NSMutableArray alloc] initWithCapacity:0];
    if (totalCount != 1) {
        randArray = [appDelegate.globalTableSequence objectAtIndex:rndNumber];
        appDelegate.tableArray = [appDelegate.globalTableSequence objectAtIndex:rndNumber];
    }
    
    for(int i = 0 ; i < [appDelegate.sequenceTitle count]; i++)
    {
        if ([appDelegate.sequenceTitle count]== 1) {
            [self.sequenceListArray addObject:[appDelegate.sequenceTitle objectAtIndex:0]];
        }
        else if (i == [randArray count]) {
            [self.sequenceListArray addObject:[appDelegate.sequenceTitle objectAtIndex:i]];
        }
        else
        {
            NSString* title = [appDelegate.sequenceTitle objectAtIndex:[[randArray objectAtIndex:i] intValue]];
            [self.sequenceListArray addObject:title];
        }
        
    }
    totalCount = [self.sequenceListArray count];
    
    BOOL isSelectData = NO;
    BOOL cellState[totalCount];
    for (int i = 0; i < totalCount; i++) {
        cellState[i] = [defaults boolForKey:[NSString stringWithFormat:@"%@%d",CellNumber,i]];
        if(cellState[i] == YES)
        {
            isSelectData = YES;
        }
    }
    
    self.selectStatusArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < totalCount ; i++) {
        BOOL curStatus = [defaults boolForKey:[NSString stringWithFormat:@"%@%d",CellNumber,i]];
        [selectStatusArray addObject:[NSNumber numberWithBool:curStatus]];
    }
    
    [sequencesTableView reloadData];
    if (R_WIDTH == 1) {
        int tableOffset = (totalCount - preTableCount) * TABLECELL_HEIGHT * R_WIDTH;
        preTableCount = [sequenceListArray count];
        backgroundScrollView.contentSize = CGSizeMake(backgroundScrollView.frame.size.width , 330  + totalCount * TABLECELL_HEIGHT * R_WIDTH);
        NSLog(@"%f",homeButton.center.x);
        NSLog(@"%f",homeButton.center.y + tableOffset);
        
        homeButton.center = CGPointMake(homeButton.center.x, homeButton.center.y + tableOffset);
        addOwnButton.center = CGPointMake(addOwnButton.center.x, addOwnButton.center.y + tableOffset);
        onSettingButton.center = CGPointMake(onSettingButton.center.x, onSettingButton.center.y + tableOffset);
        sequencesTableView.frame = CGRectMake(sequencesTableView.frame.origin.x, sequencesTableView.frame.origin.y, sequencesTableView.frame.size.width, totalCount * TABLECELL_HEIGHT * R_WIDTH);

    }
    else
    {
        int tableOffset = (totalCount - preTableCount) * TABLECELL_HEIGHT * R_WIDTH;
        preTableCount = [sequenceListArray count];
        backgroundScrollView.contentSize = CGSizeMake(backgroundScrollView.frame.size.width , 800  + totalCount * TABLECELL_HEIGHT * R_WIDTH);
        NSLog(@"%f",homeButton.center.x);
        NSLog(@"%f",homeButton.center.y + tableOffset);
        
        homeButton.center = CGPointMake(homeButton.center.x, homeButton.center.y );
        addOwnButton.center = CGPointMake(addOwnButton.center.x, addOwnButton.center.y) ;
        onSettingButton.center = CGPointMake(onSettingButton.center.x, onSettingButton.center.y );
        sequencesTableView.frame = CGRectMake(sequencesTableView.frame.origin.x, sequencesTableView.frame.origin.y,sequencesTableView.frame.size.width, totalCount * TABLECELL_HEIGHT * R_HEIGHT);
    }
    
    
    if(R_WIDTH == 1)
        self.randomSwitch.transform = CGAffineTransformMakeScale(1.1, 1.1);
    else
        self.randomSwitch.transform = CGAffineTransformMakeScale(2.2  ,2.2);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 && deselectAllData != YES)
    {
        UINavigationController* nav = self.navigationController;
        SettingsViewController* viewController;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            viewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController_iPhone" bundle:nil];
        else
            viewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController_iPad" bundle:nil];
        
        [nav popToRootViewControllerAnimated:NO];
        [nav pushViewController:viewController animated:YES];
    }
}

-(void) getData
{
    NSString* sequenceLabel = @"kim";
    NSString* sound = @"12345";
    NSMutableArray* data = [[NSMutableArray alloc] init];
    for(int i = 0; i  < TABLECOUNT; i++)
    {
        NSDictionary* dict = [[NSDictionary alloc] init];
        NSString* title = @"title";
        NSString* imageName = @"title.png";
        dict  = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:title,imageName,nil] forKeys:[NSArray arrayWithObjects:
                                                                                                            @"title",@"imageName", nil]];
        [data addObject:dict];
    }
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:
                               [NSArray arrayWithObjects: sequenceLabel, sound,data, nil]
                                                          forKeys:[NSArray arrayWithObjects: @"Sequence Label", @"Sound",@"Data", nil]];
    
    NSString* fileName = [[NSBundle mainBundle] pathForResource:@"LearningLearny" ofType:@"plist"];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:fileName];
    [array addObject:plistDict];
    
    int count = [array count];
    
    //    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    BOOL writeResult =  [array writeToFile:fileName atomically: YES];
    NSMutableArray* iswriteData = [[NSMutableArray alloc] initWithContentsOfFile:fileName];
    count = [iswriteData count];
    NSDictionary* dict;
    for(int i = 0; i < [iswriteData count]; i++)
    {
        dict = [iswriteData objectAtIndex:i];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    BOOL state = [self.randomSwitch isOn ] ? YES: NO;
    [defaults setBool:state forKey:RandomSwitch];
    
    [defaults setInteger:randomNumber forKey:RandomNumber];
    LWLSAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;

    appDelegate.tableArray = [appDelegate.globalTableSequence objectAtIndex:randomNumber];
    for (int i = 0; i < totalCount; i++) {
        BOOL curStatus = [[selectStatusArray objectAtIndex:i] intValue];
        if(curStatus == YES)
            selectCount ++;
        [defaults setBool:curStatus forKey:[NSString stringWithFormat:@"%@%d",CellNumber,i]];
    }
    [defaults setInteger:selectCount forKey:SELECTED_COUNT];
    [defaults synchronize];
}

-(BOOL) isAllDeselect
{
    for (int i = 0; i < totalCount; i++) {
        BOOL curStatus = [[selectStatusArray objectAtIndex:i] intValue];
        if(curStatus == YES)
            return NO;
    }
    
    return YES;
}

#pragma mark - button actions
- (IBAction)clickHomeButton:(id)sender
{
    if([self isAllDeselect ] == YES)
    {
        UIAlertView* myAlertView =[ [UIAlertView alloc] initWithTitle:@"Error" message:@"Please select table item" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [myAlertView show];
        deselectAllData = YES;
        return;
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)highlightButton:(UIButton*)btn
{
    btn.backgroundColor = [UIColor blueColor];
}

- (void)releaseHighlightButton:(UIButton*)btn
{
    btn.backgroundColor = [UIColor lightGrayColor];
}

- (IBAction)checkOneSequence:(id)sender
{
    UIButton *checkBtn = (UIButton*)sender;
    BOOL curStatus = [[selectStatusArray objectAtIndex:checkBtn.tag] intValue];
    if (!curStatus) {
        curStatus = YES;
        [self performSelector:@selector(highlightButton:) withObject:sender afterDelay:0.0];
    }
    else {
        curStatus = NO;
        [self performSelector:@selector(releaseHighlightButton:) withObject:sender afterDelay:0.0];
    }
    
    [selectStatusArray replaceObjectAtIndex:checkBtn.tag withObject:[NSNumber numberWithBool:curStatus]];
}

- (IBAction)selectAllSequences:(id)sender
{
    BOOL curStatus = YES;
    for (int idx = 0; idx < [selectStatusArray count]; idx++) {
        [selectStatusArray replaceObjectAtIndex:idx withObject:[NSNumber numberWithBool:curStatus]];
    }
    
    [self.sequencesTableView reloadData];
}

- (IBAction)deselectAllSequences:(id)sender
{
    BOOL curStatus = NO;
    for (int idx = 0; idx < [selectStatusArray count]; idx++) {
        [selectStatusArray replaceObjectAtIndex:idx withObject:[NSNumber numberWithBool:curStatus]];
    }
    
    [self.sequencesTableView reloadData];
}

- (IBAction)onSetting:(id)sender {
    if([self isAllDeselect ] == YES)
    {
        deselectAllData = YES;
        UIAlertView* myAlertView =[ [UIAlertView alloc] initWithTitle:@"Error" message:@"Please select table item" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [myAlertView show];
        return;
        
    }

    UINavigationController* nav = self.navigationController;
    SettingsViewController* viewController;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        viewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController_iPhone" bundle:nil];
    else
        viewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController_iPad" bundle:nil];

    [nav popToRootViewControllerAnimated:NO];
    [nav pushViewController:viewController animated:YES];
}

- (IBAction)addOwnSequence:(id)sender
{
    UINavigationController* nav = self.navigationController;
    AddyourOwnSequenceViewController* viewController;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        viewController = [[AddyourOwnSequenceViewController alloc] initWithNibName:@"AddyourOwnSequenceViewController_iPhone" bundle:nil];
    else
        viewController = [[AddyourOwnSequenceViewController alloc] initWithNibName:@"AddyourOwnSequenceViewController_iPad" bundle:nil];
    
    [nav pushViewController:viewController animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (sequenceListArray)
        return [sequenceListArray count];
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil){
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}
    
    NSArray* views = [cell.contentView subviews];
	for (UIView* subView in views) {
		[subView removeFromSuperview];
	}
    
    // add checkbox button
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.backgroundColor = [UIColor lightGrayColor];
    if (R_WIDTH == 1)
    {
        checkBtn.frame = CGRectMake(5, 2, 20, 20);
        checkBtn.layer.cornerRadius = 10.0;
    }
    else
    {
        checkBtn.frame = CGRectMake(10, 5, 50, 50);
        checkBtn.layer.cornerRadius = 20.0;
    }
    
    [checkBtn addTarget:self action:@selector(checkOneSequence:) forControlEvents:UIControlEventTouchUpInside];
    checkBtn.tag = indexPath.row;
    BOOL curStatus = [[selectStatusArray objectAtIndex:checkBtn.tag] intValue];
    if (curStatus) {
        [self performSelector:@selector(highlightButton:) withObject:checkBtn afterDelay:0.0];
    }
    else {
        [self performSelector:@selector(releaseHighlightButton:) withObject:checkBtn afterDelay:0.0];
    }
    [cell.contentView addSubview:checkBtn];    
    
    // add textLabel for title
    UILabel *title = [[UILabel alloc]init];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor blackColor];
    title.frame=CGRectMake(40 * R_HEIGHT, 0, 240 * R_HEIGHT,  80 * R_HEIGHT);
    title.font = [UIFont systemFontOfSize:18 * R_HEIGHT];
    title.numberOfLines = 0;
    title.lineBreakMode = UILineBreakModeWordWrap;
    
    title.text = [sequenceListArray objectAtIndex:indexPath.row];
    [title sizeToFit];
    [cell.contentView addSubview:title];
    [title release];

        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
     [detailViewController release];
     */
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return TABLECELL_HEIGHT * R_HEIGHT;
}

- (IBAction)randomSwitch:(id)sender {
    UISwitch* ranSwitch =(UISwitch*)sender;
    
    BOOL state = ranSwitch.isOn;
    if ([self.sequenceListArray count] == 1) {
        return;
    }
    if(state == YES)
    {
        randomNumber = arc4random() % 5;
        if(randomNumber == beforeRandonNumber)
            randomNumber = arc4random() % 5;
        NSMutableArray* randArray = [self.tableRandomArray objectAtIndex:randomNumber];

        [sequenceListArray removeAllObjects];
        LWLSAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;

        for(int i = 0; i < totalCount ; i++)
        {
            NSString* tableItemName = [appDelegate.sequenceTitle objectAtIndex:[[randArray objectAtIndex:i] intValue]];
            [self.sequenceListArray addObject:tableItemName];
        }
        
        [self.sequencesTableView reloadData];
        beforeRandonNumber = randomNumber;
    }

}

@end
