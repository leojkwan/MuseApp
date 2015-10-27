//
//  MUSDetailEntryViewController.m
//  MuseApp
// Categories


#import "UIFont+MUSFonts.h"
#import "NSAttributedString+MUSExtraMethods.h"
#import "NSDate+ExtraMethods.h"
#import "Entry+ExtraMethods.h"
#import "NSSet+MUSExtraMethod.h"
#import <UIScrollView+APParallaxHeader.h>
#import "UIImagePickerController+ExtraMethods.h"

#import "MUSDetailEntryViewController.h"
#import "MUSAllEntriesViewController.h"
#import "MUSDataStore.h"
#import "Entry.h"
#import <Masonry/Masonry.h>
#import "Song.h"
#import "Song+MUSExtraMethods.h"
#import "MUSPlaylistViewController.h"
#import "MUSKeyboardTopBar.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "MUSKeyboardTopBar.h"
#import "MUSAlertView.h"
#import <CWStatusBarNotification.h>
#import <MBProgressHUD.h>
#import "MUSAutoPlayManager.h"
#import "MUSMoodViewController.h"
#import "MUSNotificationManager.h"
#import  "MUSTagManager.h"
#import "UIColor+MUSColors.h"
#import "MUSShareManager.h"
#import "MUSiPhoneSizeManager.h"
#import "MUSMusicPlayerDataStore.h"


#define iPHONE_SIZE [[UIScreen mainScreen] bounds].size
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define TEXT_LIMIT ((int) 35)
#define TOOLBAR_COLOR [UIColor MUSBigStone] //COLOR OF BAR BUTTON ITEMS

@interface MUSDetailEntryViewController ()<APParallaxViewDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, MUSKeyboardInputDelegate, MPMediaPickerControllerDelegate, UITextFieldDelegate, UpdateMoodProtocol, UIGestureRecognizerDelegate>

@property (nonatomic, strong) MUSPlaylistViewController *dvc;
@property (nonatomic, strong) MUSDataStore *store;
@property (nonatomic, assign) AutoPlay autoplayStatus;
@property (nonatomic,assign) PlayerStatus musicPlayerStatus;
@property (nonatomic, strong) MUSKeyboardTopBar *keyboardTopBar;
@property (nonatomic, strong) MUSKeyboardTopBar *MUSToolBar;

@property (weak, nonatomic) IBOutlet UIButton *moodButton;
@property (weak, nonatomic) IBOutlet UILabel* timeOfDayEntryLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateOfEntryLabel;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) NSMutableArray *formattedPlaylistForThisEntry;
@property (weak, nonatomic) IBOutlet UITextField *entryTitleTextField;
@property (weak, nonatomic) IBOutlet UILabel *titleCharacterLimitLabel;
@property (weak, nonatomic) IBOutlet UIView *titleView;

@property (strong, nonatomic) UITapGestureRecognizer *entryTextViewTap;
@property (strong, nonatomic) UITapGestureRecognizer *titleTap;
@property(strong ,nonatomic) UIImagePickerController *imagePicker;
@property (nonatomic, strong) MUSMusicPlayerDataStore *sharedMusicDataStore;
@property (nonatomic, strong) MPMusicPlayerController *player;


@end

@implementation MUSDetailEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Reference Data Store
    self.store = [MUSDataStore sharedDataStore];
    self.sharedMusicDataStore = [MUSMusicPlayerDataStore sharedMusicPlayerDataStore];
    
    // make it easier to call
    self.player = self.sharedMusicDataStore.musicPlayer.myPlayer;

    
    // this method should only be called in didLoad, otherwise playlist collection will keep restarting on dvc dismissals
    [self setUpPlaylistForThisEntryAndPlay];

    [self setUpTitleTextField];
    [self setUpTextView];
    [self checkSizeOfContentForTextView:self.textView];
    
    [self setUpImagePicker];
    [self setUpParallaxView];
    [self setUpTagLabel];
    [self setUpKeyboardAvoiding];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
//    [self setUpTitleTextField];
//    [self setUpTextView];
//    [self checkSizeOfContentForTextView:self.textView];
//    [self setUpTagLabel];
//    [self setUpParallaxView];
//    [self setUpKeyboardAvoiding];
    [self setUpToolbarAndKeyboard];
//    [self setUpImagePicker];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)showKeyboard:(UITapGestureRecognizer*)tap {
    if (tap == self.entryTextViewTap)
        [self.textView becomeFirstResponder];
    else
        [self.entryTitleTextField becomeFirstResponder];
}

-(void)setUpTitlePlaceHolderText {
    if (self.destinationEntry.titleOfEntry == nil || [self.destinationEntry.titleOfEntry isEqualToString:@""]) {
        self.entryTitleTextField.textColor = [UIColor lightGrayColor];
        self.entryTitleTextField.text = @"Title";
    } else {
        self.entryTitleTextField.text = self.destinationEntry.titleOfEntry;
    }
}

-(void)setUpTitleTextField {
    self.entryTitleTextField.delegate = self;
    
    // add tap to container view to first repond text view
    self.titleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showKeyboard:)];
    [self.titleView addGestureRecognizer:self.titleTap];
    
    [self setUpTitlePlaceHolderText];
    
    // set time stamp of entry once instantiated
    self.dateOfEntryLabel.text = [self.destinationEntry.createdAt numericMonthDateAndYearString];
    NSString *date = [self.destinationEntry.createdAt returnEntryDateStringForDate:self.destinationEntry.epochTime];
    NSArray *items = [date componentsSeparatedByString:@","];
    self.timeOfDayEntryLabel.text = items[0]; // saturday afternoon
    
    
    // set character limit text
    [self.titleCharacterLimitLabel setHidden:YES];
    self.titleCharacterLimitLabel.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithInt:TEXT_LIMIT - (int)self.destinationEntry.titleOfEntry.length]];
    
}

-(void)setUpTextView {
    
    self.textView.delegate = self;
    self.textView.textContainerInset = UIEdgeInsetsMake(30, 15, 100, 15);     // padding for text view
    
    // add tap gesture to container view to make text view first responder
    self.entryTextViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showKeyboard:)];
    [self.containerView addGestureRecognizer:self.entryTextViewTap];
    
    // NEW ENTRY SET TEXT
    if (self.destinationEntry.content == nil || [self.destinationEntry.content isEqualToString:@""]) {
        self.textView.attributedText = [NSAttributedString returnMarkDownStringFromString:@"Begin writing here..."];
        self.textView.textColor = [UIColor lightGrayColor];
    } else{
        // EXISTING ENTRY SET TEXT
        self.textView.attributedText = [NSAttributedString returnMarkDownStringFromString:self.destinationEntry.content];
    }
}


-(void)setUpPlaylistForThisEntryAndPlay {
    //Convert entry NSSet into appropriate MutableArray
    self.formattedPlaylistForThisEntry = [NSSet convertPlaylistArrayFromSet:self.destinationEntry.songs];
    [self playPlaylistForThisEntry];
}

-(void)setUpToolbarAndKeyboard {

    if (self.MUSToolBar == nil) {
        // Set up textview keyboard accessory view
        self.MUSToolBar = [[MUSKeyboardTopBar alloc] initWithToolbarWithBackgroundColor:TOOLBAR_COLOR];
        self.MUSToolBar.delegate = self;
        [self.MUSToolBar setFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
        [self.navigationController.view addSubview:self.MUSToolBar];
        
        // Set up textview toolbar input
        self.keyboardTopBar = [[MUSKeyboardTopBar alloc] initWithKeyboardWithBackgroundColor:TOOLBAR_COLOR];
        self.keyboardTopBar.delegate = self;
        [self.keyboardTopBar setFrame:CGRectMake(0, 0, 0, 50)];
        self.textView.inputAccessoryView = self.keyboardTopBar;
        self.entryTitleTextField.inputAccessoryView = self.keyboardTopBar;
    }
}

-(void)setUpParallaxView {
    
    self.coverImageView = [[UIImageView alloc] init];
    
    if(iPHONE_SIZE.height <= 480 || IS_IPAD) {
        return;    // iPhone Classic NO AP IMAGE
    }
    
    else {
        [self.scrollView.parallaxView setDelegate:self];
        
        if (self.destinationEntry != nil && self.destinationEntry.coverImage != nil) {
            // Set Image For This Entry with Parallax
            UIImage *entryCoverImage = [UIImage imageWithData:self.destinationEntry.coverImage];
            self.coverImageView.image = entryCoverImage;
            [self.scrollView addParallaxWithImage:self.coverImageView.image andHeight:self.view.frame.size.width*3/5 andShadow:YES];
            
            // there are the magic two lines here
            [self.scrollView.parallaxView.imageView setBounds:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*3/5)];
            [self.scrollView.parallaxView.imageView setCenter:CGPointMake(self.view.frame.size.width/2,  self.view.frame.size.width*3/10)];
        }
    }
}

#pragma delegate method for Mood View Controller
-(void)updateMoodLabelWithText:(NSString *)moodText {
    
    // if this is a new entry, create one before saving the tag
    if(self.destinationEntry == nil){
        [self createNewEntry];
    }
    self.destinationEntry.tag = moodText;
    [self.store save];
    [self.moodButton setAttributedTitle:[MUSTagManager returnAttributedStringForTag:moodText] forState:UIControlStateNormal];
}

-(void)setUpTagLabel {
    if (self.destinationEntry.tag != nil && ![self.destinationEntry.tag isEqualToString:@""]) {
        NSLog(@"This is the destination tag: %@", self.destinationEntry.tag);
        [self.moodButton setAttributedTitle:[MUSTagManager returnAttributedStringForTag:self.destinationEntry.tag] forState:UIControlStateNormal];
    }    else
        [self.moodButton setAttributedTitle:[MUSTagManager returnAttributedStringForTag:@"Set Mood"] forState:UIControlStateNormal];
}


#pragma mark  - Keyboard delegate methods

-(void)didSelectMoreOptionsButton {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //    [self addCameraRollActionToController:actionSheet picker:self.imagePicker];
    //    [self addTakePhotoActionToController:actionSheet picker:self.imagePicker];
    
    // Share
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Set Cover Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self selectPhoto];
    }]];
    
    // Share
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Share Entry" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self presentViewController: [MUSShareManager returnShareSheetWithEntry:self.destinationEntry] animated:YES completion:nil];
    }]];
    // CANCEL
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    // FOR IPAD
    actionSheet.popoverPresentationController.barButtonItem = self.MUSToolBar.moreOptionsBarButtonItem;
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:^{
        [self enableTextFieldInteraction:YES];
    }];
}


-(void)didSelectShareButton:(id)sender {
    [self presentViewController: [MUSShareManager returnShareSheetWithEntry:self.destinationEntry] animated:YES completion:nil];
}

-(void)didSelectCameraButton {
    [self selectPhoto];
}

-(void)enableTextFieldInteraction:(BOOL)on {
    self.titleTap.enabled = on;
    [self.entryTitleTextField setUserInteractionEnabled:on];
}

-(void)didPickSongButtonPressed:(id)sender {
    MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
    picker.delegate = self;
    picker.allowsPickingMultipleItems= NO;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)didSelectDoneButton:(id)sender {
    // IF THERE IS AN IMAGE POP BACK TO TOP TO AVOID AP PARALLAX GLITCH
    if (self.destinationEntry.coverImage != nil) {
        [self.scrollView setContentOffset:CGPointZero animated:YES];
    }
    
    [self checkSizeOfContentForTextView:self.textView];
    [self saveButtonTapped:sender];
}


-(void)didSelectAddSongButton:(id)sender {
    [self pinSongButtonPressed:sender];
}
-(void)didSelectPlaylistButton:(id)sender {
    [self playlistButtonPressed:sender];
}

-(void)didSelectBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self.MUSToolBar setHidden:YES];
    
    // PAUSE SONG IF SETTING IS YES
    if ([MUSAutoPlayManager returnAutoPauseStatus] && self.formattedPlaylistForThisEntry.count > 0)
        [self.player pause];
    
   }

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];

}

-(void)didSelectTitleButton:(id)sender {
    [self performSegueWithIdentifier:@"markdownSegue" sender:nil];
}


-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self.titleCharacterLimitLabel setHidden:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.entryTextViewTap.enabled = YES;
    
    
    if ([self.textView respondsToSelector:@selector(becomeFirstResponder)]) {
        [self.textView becomeFirstResponder];
        return NO;
    }
    
    [self saveTitle];
    return YES;
}


- (IBAction)textFieldDidChange:(id)sender {
    
    //DISPLAY CHANGES OR CHARACTER LIMIT
    self.titleCharacterLimitLabel.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithInt:TEXT_LIMIT - (int)self.entryTitleTextField.text.length]];
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // add to seperate class
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    return newLength <= TEXT_LIMIT || returnKey;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.titleCharacterLimitLabel setHidden:NO];
    
    // IF ITS A NEW ENTRY TITLE
    if (self.entryTitleTextField.textColor == [UIColor lightGrayColor]) {
        self.entryTitleTextField.textColor = [UIColor blackColor];
        self.entryTitleTextField.text = @"";
        return;
    }
    
    // set title field to entry title
    self.entryTitleTextField.text = self.destinationEntry.titleOfEntry;
    self.entryTextViewTap.enabled = NO;
}


-(void)textViewDidBeginEditing:(UITextView *)textView {
    self.textView.font = [UIFont returnParagraphFont];
    [self.entryTitleTextField setUserInteractionEnabled:NO];
    
    // FOR NEW ENTRY
    if (self.textView.textColor == [UIColor lightGrayColor]) {
        self.textView.textColor = [UIColor blackColor];
        self.textView.text = @"";
    } else {
        self.textView.text = self.destinationEntry.content;
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    [self enableTextFieldInteraction:YES];
}




-(void)checkSizeOfContentForTextView:(UITextView *)textView{

    //     set bottom contraints
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.textView.mas_bottom);
    }];
}

#pragma mark - music controls

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
    
    [self.player setQueueWithItemCollection:mediaItemCollection];
    [self.player play];
}


- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
    [self.MUSToolBar setHidden:NO];
}

-(void)playPlaylistForThisEntry {
    
    if (self.entryType == ExistingEntry && self.destinationEntry.songs != nil ) {
        
        //  condition for null objects
        [self.sharedMusicDataStore.musicPlayer loadMPCollectionFromFormattedMusicPlaylist: [NSSet convertPlaylistArrayFromSet:self.destinationEntry.songs] completionBlock:^(MPMediaItemCollection *currentCollection) {
            
            // array of mp media items
            // loop through playlist collection and track the index so we can reference formatted playlist with song names in it
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                int i = 0;
                
                for (MPMediaItem *MPSong in currentCollection.items) {
                    Song *songForThisIndex = self.formattedPlaylistForThisEntry[i];
                    if (MPSong == [NSNull null]) {
                        UIAlertController *alertController = [UIAlertController
                                                              alertControllerWithTitle:@"Oops!"
                                                              message: [NSString stringWithFormat: @"We can't find '%@' by %@ in your library!", songForThisIndex.songName, songForThisIndex.artistName]
                                                              preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *okAction = [UIAlertAction
                                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                   style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action)
                                                   {
                                                   }];
                        [alertController addAction:okAction];
                        // present alert if there are null songs
                        [self presentViewController:alertController animated:YES completion:nil];
                        
                        // delete null song from core data
                        [self.destinationEntry removeSongsObject:self.formattedPlaylistForThisEntry[i]];
                        [self.store save];
                    } //  end of if statment
                    
                    i++; // next song
                } // end of for loop
                
                if ([MUSAutoPlayManager returnAutoPlayStatus] && self.formattedPlaylistForThisEntry.count > 0) {
                    
                    // rerue method to get updated playlist count for playlist player vc
                    [self.sharedMusicDataStore.musicPlayer loadMPCollectionFromFormattedMusicPlaylist: [NSSet convertPlaylistArrayFromSet:self.destinationEntry.songs] completionBlock:^(MPMediaItemCollection *filteredCollection) {
                        [self.player setQueueWithItemCollection:filteredCollection];
                        
                        [self.player play];
                    }];
                }
            }]; // end of main thread ns operation
        }];
    }
    
    // IF AUTOPLAY IS ON AND THIS ENTRY HAS A PLAYLIST... PLAY!
    
    // RANDOM SONG
    else if (self.entryType == RandomSong) {
        
        [self.sharedMusicDataStore.musicPlayer returnRandomSongInLibraryWithCompletionBlock:^(MPMediaItemCollection *randomSong) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                if (randomSong != nil) {
                    [self.player setQueueWithItemCollection:randomSong];
                    [self.player play];
                    NSString *message = [NSString stringWithFormat:@"Now Playing: %@", [self.player nowPlayingItem].title];
                    [MUSNotificationManager displayNotificationWithMessage:message backgroundColor:[UIColor MUSGreenMachine] textColor:[UIColor blackColor]];
                }
            }];
        }];
    }
}

-(void)setUpKeyboardAvoiding{
    [IHKeyboardAvoiding setAvoidingView:self.scrollView];
    [IHKeyboardAvoiding setPadding:20];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.MUSToolBar setHidden:NO];
}


- (void)saveButtonTapped:(id)sender {
    if (self.entryTitleTextField.isFirstResponder)
        // SAVE JUST THE TITLE ON DONE BUTTON PRESS... THIS PRESERVES THE ATTRIBUTED TEXT ON SAVE.... BLOW AWAY ALL MARKDOWN OTHERWISE
        [self saveTitle];
    else
        [self saveEntry];
}


-(void)saveEntry {
    // NEW ENTRIES MUST BE CREATED
    if (self.destinationEntry == nil) {
        Entry *newEntry = [self createNewEntry];
        newEntry.coverImage = nil;
    }
    
    // FOR EXISTING ENTRIES
    self.destinationEntry.content = self.textView.text;
    self.destinationEntry.titleOfEntry = self.entryTitleTextField.text;
    
    
    if ([self.textView.text isEqualToString:@"Begin writing here..." ])
        self.destinationEntry.content = @"";
    
    else if ([self.entryTitleTextField.text isEqualToString:@"Title" ])
        self.destinationEntry.titleOfEntry = @"";
    
    // SAVE TO CORE DATA
    [self.store save];
    
    // dismiss keyboard
    [self.view endEditing:YES];
    
    // display content as attributed string
    self.textView.attributedText = [NSAttributedString returnMarkDownStringFromString:self.destinationEntry.content];
}

-(void)saveTitle {
    if (self.destinationEntry == nil) {
        Entry *newEntry = [self createNewEntry];
        newEntry.coverImage = nil;
        
    } else {
        self.destinationEntry.titleOfEntry = self.entryTitleTextField.text;
    }
    // save to core data
    [self.store save];
    
    // dismiss keyboard
    [self.view endEditing:YES];
}


-(Entry *)createNewEntry {
    Entry *newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"MUSEntry" inManagedObjectContext:self.store.managedObjectContext];
    self.destinationEntry = newEntry;
    if ([self.textView.text isEqualToString:@"Begin writing here..."])
        newEntry.content = @"";
    else if ([self.entryTitleTextField.text isEqualToString:@"Title"])
        newEntry.titleOfEntry = @""; // wipe attributed placeholder text
    else
        newEntry.content = self.textView.text;
    newEntry.tag = @"";
    newEntry.titleOfEntry = self.entryTitleTextField.text;
    
    NSDate *currentDate = [NSDate date];
    newEntry.createdAt = [currentDate monthDateYearDate];     // month day and year
    newEntry.epochTime = currentDate; // month day and year and seconds

    newEntry.tag = @"";
    newEntry.dateInString = [currentDate monthDateAndYearString];
    return newEntry;
}

#pragma mark- photo selection methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // ALLOW INTERACTION FOR TEXT FIELD
    [self enableTextFieldInteraction:YES];
    
    
    // SET COVER IMAGE AS SELECTED IMAGE
    self.coverImageView.image = info[UIImagePickerControllerEditedImage];
    
    
    //SAVE TO CORE DATA
    if (self.destinationEntry == nil) {
        Entry *newEntryWithImage = [self createNewEntry];
        newEntryWithImage.coverImage = UIImageJPEGRepresentation(self.coverImageView.image, .5);
    } else {
        self.destinationEntry.coverImage = UIImageJPEGRepresentation(self.coverImageView.image, .5);
    }
    
    [self saveEntry];
    
    // SAVE TO CORE DATA!!
    [self.store save];
    
    
    if(iPHONE_SIZE.height <= 480 || IS_IPAD)
    {
        return;    // iPhone Classic...  NO AP IMAGE
    } else {
        
        // add reset parallax image
        [self.scrollView addParallaxWithImage:self.coverImageView.image andHeight:self.view.frame.size.width*3/5 andShadow:YES];
        
        //     fixes glitch with parallax, new parallax image does not fit into position without first responder
        CGPoint scrollPoint = self.scrollView.contentOffset; // initial and after update
        scrollPoint = CGPointMake(scrollPoint.x, scrollPoint.y + 1); // makes scroll
        [self.scrollView setContentOffset:scrollPoint animated:YES];
        
    }
}

#pragma mark - button pressed methods


-(void)selectPhoto{
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Set Cover Photo" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // CANCEL
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [self addCameraRollActionToController:actionSheet picker:self.imagePicker];
    [self addTakePhotoActionToController:actionSheet picker:self.imagePicker];
    
    // present action sheet/ POPover for ipads
    actionSheet.popoverPresentationController.barButtonItem = self.keyboardTopBar.cameraBarButtonItem;
    [self presentViewController:actionSheet animated:YES completion:nil];
    [self.view bringSubviewToFront:self.contentView];
}




-(void)addCameraRollActionToController:(UIAlertController *)actionSheet picker:(UIImagePickerController *)imagePicker {
    
    // CAMERA ROLL
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Select from Camera Roll" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [UIImagePickerController obtainPermissionForMediaSourceType:UIImagePickerControllerSourceTypePhotoLibrary withSuccessHandler:^{
            [self presentViewController:imagePicker animated:YES completion:nil];
        } andFailure:^{
            UIAlertController *alertController= [UIAlertController
                                                 alertControllerWithTitle:nil
                                                 message:NSLocalizedString(@"You have disabled Photos access", nil)
                                                 preferredStyle:UIAlertControllerStyleActionSheet];
            [alertController addAction:[UIAlertAction
                                        actionWithTitle:NSLocalizedString(@"Open Settings", @"Photos access denied: open the settings app to change privacy settings")
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction *action) {
                                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                        }]
             ];
            [alertController addAction:[UIAlertAction
                                        actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                        style:UIAlertActionStyleDefault
                                        handler:NULL]
             ];
            
            alertController.popoverPresentationController.barButtonItem = self.MUSToolBar.cameraBarButtonItem;
            [self presentViewController:alertController animated:YES completion:nil];
        }];
    }]];
}

-(void)addTakePhotoActionToController:(UIAlertController *)actionSheet picker:(UIImagePickerController *)imagePicker {
    // TAKE PHOTO
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take a Picture" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // ask for permission
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [UIImagePickerController obtainPermissionForMediaSourceType:UIImagePickerControllerSourceTypeCamera withSuccessHandler:^{
            
            // add a check if there is a camera...
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        } andFailure:^{
            UIAlertController *alertController= [UIAlertController
                                                 alertControllerWithTitle:nil
                                                 message:NSLocalizedString(@"You have disabled Camera access", nil)
                                                 preferredStyle:UIAlertControllerStyleActionSheet];
            [alertController addAction:[UIAlertAction
                                        actionWithTitle:NSLocalizedString(@"Open Settings", @"Camera access denied: open the settings app to change privacy settings")
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction *action) {
                                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                        }]
             ];
            [alertController addAction:[UIAlertAction
                                        actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                        style:UIAlertActionStyleDefault
                                        handler:NULL]
             ];
            alertController.popoverPresentationController.barButtonItem = self.MUSToolBar.cameraBarButtonItem;
            [self presentViewController:alertController animated:YES completion:nil];
        }];
    }]];
}

-(void)setUpImagePicker {
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    self.imagePicker.allowsEditing = YES;
}



-(void)playlistButtonPressed:id {
    [self performSegueWithIdentifier:@"playlistSegue" sender:self];
}

-(void)getStatusForSong:(Song *)currentSong {
    
    if (self.player.playbackState == MPMusicPlaybackStatePlaying) {
        [self.sharedMusicDataStore.musicPlayer checkIfSongIsInLocalLibrary:currentSong withCompletionBlock:^(BOOL local) {
            if (local) {
                for (Song *song in  [NSSet convertPlaylistArrayFromSet:self.destinationEntry.songs]) {
                    NSString *currentTrack = [self.player nowPlayingItem].title;
                    if ([currentTrack isEqualToString: song.songName]) {
                        self.musicPlayerStatus = AlreadyPinned;
                        return;
                    }
                }
                self.musicPlayerStatus = Playing;
            } else {
                self.musicPlayerStatus = Invalid;
            }
        }];
    } else if (self.player.playbackState == MPMusicPlaybackStatePaused || self.player.playbackState == MPMusicPlaybackStateStopped) {
        self.musicPlayerStatus = NotPlaying;
    }
}


-(void)pinSongButtonPressed:id {
    
    // Create managed object on CoreData
    MPMediaItem *currentSong = [self.player nowPlayingItem];
    Song *pinnedSong = [Song initWithTitle:currentSong.title artist:currentSong.artist genre:currentSong.genre album:currentSong.albumTitle inManagedObjectContext:self.store.managedObjectContext];
    
    
    [self getStatusForSong:pinnedSong];
    
    if (self.musicPlayerStatus == Playing) {
        if(self.destinationEntry == nil){
            // create new entry and init a playlist for it
            [self createNewEntry];
            self.formattedPlaylistForThisEntry = [[NSMutableArray alloc] init];
        }
        
        // convert long long to nsnumber
        NSNumber *songPersistentNumber = [NSNumber numberWithUnsignedLongLong:[self.player nowPlayingItem].persistentID];
        
        pinnedSong.persistentID = songPersistentNumber;
        pinnedSong.pinnedAt = [NSDate date]; //current date
        pinnedSong.entry = self.destinationEntry;
        
        [self displayPinnedSongNotification];
        [self.formattedPlaylistForThisEntry addObject:pinnedSong];
        
        // Add song to Core Data
        [self.destinationEntry addSongsObject:pinnedSong];
        
        
        [self.sharedMusicDataStore.musicPlayer loadMPCollectionFromFormattedMusicPlaylist: [NSSet convertPlaylistArrayFromSet:self.destinationEntry.songs] completionBlock:^(MPMediaItemCollection *newPlaylistCollection) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                [self.player setQueueWithItemCollection:newPlaylistCollection];
            }];
        }];
        
        // Save to Core Data
        [self.store save];
    }
    [self displayPinnedSongNotification];
}


-(void)displayPinnedSongNotification{
    NSString *currentSongTitle = self.player.nowPlayingItem.title;
    [MUSNotificationManager selectNotificationForSong:currentSongTitle musicStatus:self.musicPlayerStatus];
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"playlistSegue"]) {
        MUSPlaylistViewController *dvc = segue.destinationViewController;
        dvc.destinationEntry = self.destinationEntry;
        dvc.playlistForThisEntry =[NSSet convertPlaylistArrayFromSet:self.destinationEntry.songs];
        
    } else if ([segue.identifier isEqualToString:@"moodSegue"]) {
        MUSMoodViewController *dvc = segue.destinationViewController;
        dvc.delegate = self;
        dvc.destinationEntry = self.destinationEntry;
        dvc.destinationToolBar = self.MUSToolBar;
        [self.MUSToolBar setHidden:YES];
    }
}

@end
