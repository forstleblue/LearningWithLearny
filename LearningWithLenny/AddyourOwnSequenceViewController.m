//
//  AddyourOwnSequenceViewController.m
//  LearningWithLenny
//
//  Created by MiniMac on 9/17/13.
//  Copyright (c) 2013 JinHong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "AddyourOwnSequenceViewController.h"
#import "NameConstant.h"
#import "DataManager.h"
#import "SaveVoiceViewController.h"

@interface AddyourOwnSequenceViewController ()

@end

@implementation AddyourOwnSequenceViewController
@synthesize thirdImageLabel;
@synthesize fourthImageLabel;
@synthesize firstImageLabel,secondImageLabel;
@synthesize addText;
@synthesize sequenceTitle;

 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        selectStage = 0;
        imageArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.backgroundScrollView.scrollEnabled = YES;
    tapTakePic = NO;
    sharedInstance = [[AddOwnData sharedAddData] init];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkVoiceMethod:) userInfo:nil repeats:YES];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        self.backgroundScrollView.contentSize = CGSizeMake(480,710);
    else
        self.backgroundScrollView.contentSize = CGSizeMake(480, 1060);
    
    UIColor *unSelBackColor = [UIColor colorWithRed:60.0/255.0 green:161.0/255.0 blue:119.0/255.0 alpha:1];
    self.imageViewOne.backgroundColor = unSelBackColor;
    self.imageViewThree.backgroundColor = unSelBackColor;
    self.imageViewTwo.backgroundColor = unSelBackColor;
    self.imageViewFour.backgroundColor = unSelBackColor;
    for (int i = 0; i < 4; i++)
        valideData[i] = NO;
    
    self.imageLabelFour = @"";
    self.imageLabelThree = @"";
    self.imageLabelTwo = @"";
    self.imageLabelOne = @"";
    sequenceTitle = @"";
    
    self.addSequenceTitle.layer.cornerRadius = 5.0;
    self.addTextFirst.layer.cornerRadius = 5.0;
    self.addTextSecond.layer.cornerRadius = 5.0;
    self.addTextThird.layer.cornerRadius = 5.0;
    self.addTextFourth.layer.cornerRadius = 5.0;
    self.addSequenceTitle.layer.cornerRadius = 5.0;
    self.addTakePicFirst.layer.cornerRadius = 5.0;
    self.adddTakePicSec.layer.cornerRadius = 5.0;
    self.addTakePicThird.layer.cornerRadius = 5.0;
    self.addTakePicFourth.layer.cornerRadius = 5.0;
    self.AddPicFileOne.layer.cornerRadius = 5.0;
    self.addPicFileTwo.layer.cornerRadius = 5.0;
    self.addPicFileThree.layer.cornerRadius = 5.0;
    self.addPicFileFour.layer.cornerRadius = 5.0;
    self.addAudioOne.layer.cornerRadius = 5.0;
    self.addAudioTwo.layer.cornerRadius = 5.0;
    self.addAudioThree.layer.cornerRadius = 5.0;
    self.addAudioFour.layer.cornerRadius = 5.0;
    self.addAudioFive.layer.cornerRadius = 5.0;
    
    takePic = -1;
    addAudio = -1;
    addPic = -1;
    addText = -1;
    
    [imageArray addObject:self.imageViewOne];
    [imageArray addObject:self.imageViewTwo];
    [imageArray addObject:self.imageViewThree];
    [imageArray addObject:self.imageViewFour];

    // Do any additional setup after loading the view from its nib.
}

-(void) checkVoiceMethod:(NSTimer*)interval
{
    if(sharedInstance.firstVoice == YES)
        self.addAudioOne.backgroundColor = [UIColor blueColor];
    if(sharedInstance.secondVoice == YES)
        self.addAudioTwo.backgroundColor = [UIColor blueColor];
    if(sharedInstance.thirdVoice == YES)
        self.addAudioThree.backgroundColor = [UIColor blueColor];
    if(sharedInstance.fourthVoice == YES)
        self.addAudioFour.backgroundColor = [UIColor blueColor];
    if(sharedInstance.fifthVoice == YES)
        self.addAudioFive.backgroundColor = [UIColor blueColor];
}

- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (void)saveImage:(UIImage *)imageData withName:(NSString *)name {
//    UIImage* image = [self ImageResize:imageData];
//    CGSize rect = self.imageViewOne.bounds.size;
    CGSize rect = CGSizeMake(40, 40);
    UIImage* image = [self imageWithImage:imageData scaledToSize:rect];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:name];
    [fileManager createFileAtPath:fullPath contents:data attributes:nil];
}

- (UIImage *)loadImage:(NSString *)name {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:name];
    UIImage *img = [UIImage imageWithContentsOfFile:fullPath];
    
    return img;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSave:(id)sender
{
    imageLabel[0] = self.firstImageLabel;
    imageLabel[1] = self.secondImageLabel;
    imageLabel[2] = self.thirdImageLabel;
    imageLabel[3] = self.fourthImageLabel;
    
    int emptyLabelCount = 0;
    int imageCnt = 0;
    imageArray = [[NSMutableArray alloc] initWithCapacity:0];
    [imageArray addObject:self.imageViewOne];
    [imageArray addObject:self.imageViewTwo];
    [imageArray addObject:self.imageViewThree];
    [imageArray addObject:self.imageViewFour];
    
    for(int i = 0; i < 4 ; i++)
    {
        UIImageView* imageView = [imageArray objectAtIndex:i];
        
        if(imageView.image != nil && [imageLabel[i] length] != 0)
        {
            imageCnt++;
            valideData[i] = YES;
        }
        NSLog(@"%@",imageLabel[i]);
        if([imageLabel[i] length] == 0)
            emptyLabelCount++;
    }
    
    NSLog(@"%@",self.sequenceTitle);
    if([self.sequenceTitle length] == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please input Sequence Title" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        addText = -1;
        return;
    }
    
    if(emptyLabelCount > 1)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please enter Image Text." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        addText = -1;
        [alert show];
        return;
        
    }
    
    if(imageCnt < 3)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please select Image or enter text." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        addText = -1;
        [alert show];
        return;
    }
    
    BOOL sameText = NO;
    for(int i = 0 ; i <3; i++)
    {
        for(int j = i + 1; j < 4; j++ )
        {
            if([imageLabel[i] isEqualToString:imageLabel[j]] == YES)
            {
                sameText = YES;
            }
        }
    }
    
    if(sameText == YES)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please input another text." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        addText = -1;
        [alert show];
        return;
        
    }
    
    int dataCount = 0;
    for (int i = 0; i < 4; i++) {
        if(i == 0 && valideData[i] == YES && sharedInstance.firstVoice == YES)
        {
            dataCount++;
        }
        if (i == 1 && valideData[i] == YES && sharedInstance.secondVoice == YES) {
            dataCount++;
        }
        if(i == 2 && valideData[i] == YES && sharedInstance.thirdVoice == YES)
            dataCount++;
        if (i == 3 && valideData[i] == YES && sharedInstance.fourthVoice == YES) {
            dataCount++;
        }
    }
    
    if(dataCount < 3 )
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please record voice." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        addText = -1;
        [alert show];
        return;
    }
    
    stageNumber = dataCount;
    [self writeData];
    for(int i = 0 ; i < imageCnt; i++)
    {
        UIImageView* imageView = [imageArray objectAtIndex:i];
        UIImage* imageChange = imageView.image;
        CGSize rect = CGSizeMake(self.imageViewOne.bounds.size.width, self.imageViewOne.bounds.size.height);
        UIImage* image = [self imageWithImage:imageChange scaledToSize:rect];
        
        NSData *imageData = UIImagePNGRepresentation(image);
        NSString* path  = [NSString stringWithFormat:@"/Documents/%@.png",imageLabel[i]];
        NSString *cachedImagePath = [NSHomeDirectory() stringByAppendingString:path];
        if (![imageData writeToFile:cachedImagePath atomically:NO]) {
            NSLog(@"Failed to cache image data to disk");
        }
        
    }
    
    if(imageCnt == 3)
    {
        for(int i = 0; i < 4 ; i++)
        {
            UIImageView* imageView = [imageArray objectAtIndex:i];
            imageView.image = nil;
        }
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@" You Saved Three Picture Data " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        addText = -1;
        [alert show];
    }
    else
    {

    }
    
    for(int i = 0; i < 4 ; i++)
    {
        UIImageView* imageView = [imageArray objectAtIndex:i];
        
        imageView.image = nil;
        imageLabel[i] = @"";
        valideData[i] = NO;
        
    }
    
    self.sequenceTitle = @"";
    saveDataSuccess = YES;

    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void) writeData
{
    // create dictionary with values in UITextFields
    NSString* sequenceLabel = sequenceTitle;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    int recordNumber = [defaults integerForKey:RECORD_NUMBER];
    
    NSString* sound = [NSString stringWithFormat:@"Title%d",recordNumber];//question
    
    //    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]  init];
    [dict setObject:sequenceLabel forKey:FIRST_KEY];
    [dict setObject:sound forKey:SECOND_KEY];//quetions
    
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < stageNumber; i++)
    {
        NSMutableDictionary* itemDict = [[NSMutableDictionary alloc] init];
        
        NSString* string = imageLabel[i];
        NSString* imagePath = [NSString stringWithFormat:@"%@.png",imageLabel[i]];
        NSString* voicePath;
        if (i == 0) 
            voicePath = [NSString stringWithFormat:@"First%d",recordNumber];
        else if(i == 1)
            voicePath = [NSString stringWithFormat:@"Second%d",recordNumber];
        else if(i == 2)
            voicePath = [NSString stringWithFormat:@"Third%d",recordNumber];
        else
            voicePath = [NSString stringWithFormat:@"Fourth%d",recordNumber];
        [itemDict setObject:string forKey:SUB_KEY1];
        [itemDict setObject:imagePath forKey:SUB_KEY2];
        [itemDict setObject:voicePath forKey:SUB_KEY3];
        [dataArray addObject:itemDict];
    }
    [dict setObject:dataArray forKey:THIRD_KEY];
    [[DataManager sharedInstance] addNewProjects:sequenceLabel sound:sound data:dataArray];
    [[DataManager sharedInstance] addNewItem];
    recordNumber++;
    [defaults setInteger:recordNumber forKey:RECORD_NUMBER];
    
}

- (void) pickerAndPictureSetting
{
    addPic = -1;
    takePic = -1;
}

- (IBAction)takePicture:(id)sender {
    
    NSString *model = [[UIDevice currentDevice] model];
    if ([model isEqualToString:@"iPhone Simulator"]) {
        UIAlertView* view =[ [UIAlertView alloc] initWithTitle:@"Message" message:@"You should not use this camera in simulator" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [view show];
        tapTakePic = YES;
        return;
        
    }
    [self pickerAndPictureSetting];
    takePic = [sender tag];
    
   
    selectStage = 1;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController: picker animated:YES completion:NULL];

}

- (IBAction)addPicture:(id)sender {
    [self pickerAndPictureSetting];
    selectStage = 0;
    addPic = [sender tag];
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIPopoverController *popOverController = [[UIPopoverController alloc] initWithContentViewController:ipc];
        popOverController.delegate = self;
        
        ipc.delegate = self;
        ipc.editing = NO;
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:ipc.sourceType];
        
        [popOverController presentPopoverFromRect:CGRectMake(200, 200, 100, 100) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }

}


-(UIImage*)ImageResize:(UIImage*)image
{
    if(image==NULL)
    {
        return NULL;
    }
    else
    {
        float actualHeight = image.size.height;
        float actualWidth = image.size.width;
        float imgRatio = actualWidth/actualHeight;
        float maxRatio = 130.0/160.0;
        
        if(imgRatio!=maxRatio)
        {
            if(imgRatio < maxRatio)
            {
                imgRatio = 160.0 / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = 160.0;
            }
            else
            {
                imgRatio = 130.0 / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = 130.0;
            }
        }
        CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
        UIGraphicsBeginImageContext(rect.size);
        [image drawInRect:rect];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
    }
}
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
//    int selectImageNumber;
    UIImage* chosenImage;
    //    NSURL *imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    
    if(selectStage == 1)
    {
        chosenImage = (UIImage*) [info objectForKey:UIImagePickerControllerEditedImage];
        
    }
    else
    {
        chosenImage = (UIImage*) [ info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    for (int i = 0; i < 4; i++) {
        UIImageView* imageView = [imageArray objectAtIndex:i];
        UIImage *img1 = chosenImage;
        UIImage *img2 = imageView.image;
        if(img2 == nil)
            continue;
        
        NSData *imgdata1 = UIImagePNGRepresentation(img1);
        
        NSData *imgdata2 = UIImagePNGRepresentation(img2);
        
        if ([imgdata1 isEqualToData:imgdata2]) {
            [self imagePickerControllerDidCancel:picker];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please select other image" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            addText = -1;;
            return;
        }
        
    }
    NSMutableString *ImageName = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
    
    CFUUIDRef theUUID = CFUUIDCreate(kCFAllocatorDefault);
    if (theUUID) {
        [ImageName appendString:NSMakeCollectable(CFUUIDCreateString(kCFAllocatorDefault, theUUID))];
        CFRelease(theUUID);
    }
    [ImageName appendString:@".png"];
    if(addPic == 0 || takePic == 0)
    {
        self.imageViewOne.image = chosenImage;
        selectImage[0] = YES;
        imageName[0] = ImageName;
        if(addPic == 0)
            self.AddPicFileOne.backgroundColor = [UIColor blueColor];
        else
            self.addTakePicFirst.backgroundColor = [UIColor blueColor];
            NSLog(@"%@",ImageName);
    }
    else if(addPic == 1  || takePic == 1)
    {
        self.imageViewTwo.image = chosenImage;
        imageName[1] = ImageName;
        selectImage[1] = YES;
        if (addPic == 1) 
           [self.addPicFileTwo setBackgroundColor:[UIColor blueColor]];
        else
            self.adddTakePicSec.backgroundColor = [UIColor blueColor];
        
                
    }
    else if(addPic == 2 || takePic == 2)
    {
        self.imageViewThree.image = chosenImage;
        imageName[2] = ImageName;
        selectImage[2] = YES;
        if(addPic == 2)
            self.addPicFileThree.backgroundColor = [UIColor blueColor];
        else
            self.addTakePicThird.backgroundColor = [UIColor blueColor];
        
    }
    else if(addPic == 3 || takePic == 3)

    {
        self.imageViewFour.image = chosenImage;
        imageName[3] = ImageName;
        selectImage[3] = YES;
        if (addPic == 3) {
            self.addPicFileFour.backgroundColor = [UIColor blueColor];
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)addAudio:(id)sender {
    
    addAudio = [ sender tag];
    sharedInstance.saveVoiceId = addAudio;
    
    SaveVoiceViewController* viewController;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        viewController = [[SaveVoiceViewController alloc] initWithNibName:@"SaveVoiceViewController_iPad" bundle:nil];
        
    }
    else
    {
        viewController = [[SaveVoiceViewController alloc] initWithNibName:@"SaveVoiceViewController_iPhone" bundle:nil];
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        viewController.view.frame = CGRectMake(0, 0, screenRect.size.height, screenRect.size.width);
        
    }
    [self.view addSubview:viewController.view];

}


-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point  = [touch locationInView:self.view];
    for (int i = 0 ; i < 4; i++) {
        UIImageView* imageView = [imageArray objectAtIndex:i];
        if (CGRectContainsPoint([imageView frame], point)) {
            if (selectImage[i] == YES) {
                imageView.image = nil;
                selectImage[i] = NO;
            }
        }
    }
}

- (IBAction)addText:(id)sender {
    addText =[sender tag];
    sharedInstance.addText = addText;
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please input title" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d", buttonIndex);
    NSString *model = [[UIDevice currentDevice] model];
    if ([model isEqualToString:@"iPhone Simulator"] && tapTakePic == YES) {
        tapTakePic = NO;
        return;
    }
    if(buttonIndex == 0 && addText != -1)
    {
        
        NSString *keyString = @"";
        if(addText != 5)
        {
            keyString = [alertView textFieldAtIndex:0].text;
            if ([keyString length] == 0) {
                return;
            }
        }
        if(addText == 0)
        {
            self.firstImageLabel = keyString;
             self.addTextFirst.backgroundColor = [UIColor blueColor];
        }
        if(addText == 1)
        {
            self.secondImageLabel = keyString;
            self.addTextSecond.backgroundColor = [UIColor blueColor];
        }
        else if (addText == 2)
        {
            self.thirdImageLabel =keyString;
            self.addTextThird.backgroundColor = [UIColor blueColor];

        }
        else if (addText == 3)
        {
            self.fourthImageLabel = keyString;
            self.addTextFourth.backgroundColor = [UIColor blueColor];
        }

        else if( addText == 4)
        {
            self.sequenceTitle = keyString;
            self.addSequenceTitle.backgroundColor = [UIColor blueColor];

            NSLog(@"%@",sequenceTitle);
        }       
    }
}

- (IBAction)onBack:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [_imageViewOne release];
    [_imageViewTwo release];
    [_imageViewThree release];
    [_imageViewFour release];
    [_backgroundScrollView release];
    [_addTextFirst release];
    [_addTextSecond release];
    [_addTextThird release];
    [_addTextFourth release];
    [_addSequenceTitle release];
    [_addTakePicFirst release];
    [_adddTakePicSec release];
    [_addTakePicThird release];
    [_addTakePicFourth release];
    [_AddPicFileOne release];
    [_addPicFileTwo release];
    [_addPicFileThree release];
    [_addPicFileFour release];
    [_addAudioOne release];
    [_addAudioTwo release];
    [_addAudioThree release];
    [_addAudioFour release];
    [_addAudioFive release];
    
    [super dealloc];
}


@end
