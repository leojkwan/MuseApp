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
#import "MUSMusicPlayer.h"
#import "MUSKeyboardTopBar.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "MUSKeyboardTopBar.h"
#import <IHKeyboardAvoiding.h>
#import "MUSAlertView.h"
#import <CWStatusBarNotification.h>
#import <MBProgressHUD.h>
#import "MUSAutoPlayManager.h"
#import "MUSMoodViewController.h"
#import "MUSNotificationManager.h"
#import  "MUSTagManager.h"


#define TEXT_LIMIT ((int) 35)

typedef enum{
    Playing,
    NotPlaying,
    Invalid,
    AlreadyPinned
}PlayerStatus;

@interface MUSDetailEntryViewController ()<APParallaxViewDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, MUSKeyboardInputDelegate, MPMediaPickerControllerDelegate, UITextFieldDelegate, UpdateMoodProtocol>




@property (nonatomic, strong) MUSPlaylistViewController *dvc;
@property (nonatomic, strong) MUSDataStore *store;
@property (nonatomic, assign) AutoPlay autoplayStatus;
@property (nonatomic,assign) PlayerStatus musicPlayerStatus;
@property (nonatomic, strong) MUSMusicPlayer *musicPlayer;
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


@end

@implementation MUSDetailEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.store = [MUSDataStore sharedDataStore];
    
    
    [self setUpTagLabel];
    [self setUpMusicPlayer];
    [self setUpParallaxForExistingEntries];
    [self setUpTitleTextField];
    [self setUpTextView];
    [self setUpToolbarAndKeyboard];
    
    // set bottom contraints
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.textView.mas_bottom);
    }];
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
    self.timeOfDayEntryLabel.text = items[1]; // 6:40 pm..
    
    
    // set character limit text
    [self.titleCharacterLimitLabel setHidden:YES];
    self.titleCharacterLimitLabel.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithInt:TEXT_LIMIT - (int)self.destinationEntry.titleOfEntry.length]];
    
}

-(void)setUpTextView {
    
    self.textView.delegate = self;
    self.textView.textContainerInset = UIEdgeInsetsMake(30, 15, 200, 15);     // padding for text view
    
    // add tap to container view to first repond text view
    self.entryTextViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showKeyboard:)];
    [self.containerView addGestureRecognizer:self.entryTextViewTap];
    
    
    
    // set up placeholder text for nil entries or entries with no text
    if (self.destinationEntry.content == nil || [self.destinationEntry.content isEqualToString:@""]) {
        self.textView.attributedText = [NSAttributedString returnMarkDownStringFromString:@"Begin writing here..."];
        self.textView.textColor = [UIColor lightGrayColor];
    } else{
        // this is an existing entry
        self.textView.attributedText = [NSAttributedString returnMarkDownStringFromString:self.destinationEntry.content];
    }
    
    // adjust size of text view
    [self checkSizeOfContentForTextView:self.textView];
}


-(void)setUpMusicPlayer {
    //Convert entry NSSet into appropriate MutableArray
    self.formattedPlaylistForThisEntry = [NSSet convertPlaylistArrayFromSet:self.destinationEntry.songs];
    
    // set up music player
    self.musicPlayer = [[MUSMusicPlayer alloc] init];
    [self playPlaylistForThisEntry];
}

-(void)setUpToolbarAndKeyboard {
    
    // Set up textview keyboard accessory view
    self.MUSToolBar = [[MUSKeyboardTopBar alloc] initWithToolbar];
    self.MUSToolBar.delegate = self;
    [self.MUSToolBar setFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    [self.navigationController.view addSubview:self.MUSToolBar];
    
    // Set up textview toolbar input
    self.keyboardTopBar = [[MUSKeyboardTopBar alloc] initWithKeyboard];
    self.keyboardTopBar.delegate = self;
    [self.keyboardTopBar setFrame:CGRectMake(0, 0, 0, 50)];
    self.textView.inputAccessoryView = self.keyboardTopBar;
    self.entryTitleTextField.inputAccessoryView = self.keyboardTopBar;
    
    
}

-(void)setUpParallaxForExistingEntries {
    self.coverImageView = [[UIImageView alloc] init];
    [self.scrollView.parallaxView setDelegate:self];
    
    if (self.destinationEntry != nil && self.destinationEntry.coverImage != nil) {
        // Set Image For This Entry with Parallax
        UIImage *entryCoverImage = [UIImage imageWithData:self.destinationEntry.coverImage];
        self.coverImageView.image = entryCoverImage;
        [self.scrollView addParallaxWithImage:self.coverImageView.image andHeight:350 andShadow:YES];
        // there are the magic two lines here
        [self.scrollView.parallaxView.imageView setBounds:CGRectMake(0, 0, self.view.frame.size.width, 350)];
        [self.scrollView.parallaxView.imageView setCenter:CGPointMake(self.view.frame.size.width/2, 175)];
        
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
//[NSAttributedString returnAttrTagWithTitle:self.destinationEntry.tag color:[UIColor grayColor] undelineColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
}

-(void)setUpTagLabel {
    if (self.destinationEntry.tag != nil && ![self.destinationEntry.tag isEqualToString:@""]) {
        NSLog(@"This is the destination tag: %@", self.destinationEntry.tag);
    [self.moodButton setAttributedTitle:[MUSTagManager returnAttributedStringForTag:self.destinationEntry.tag] forState:UIControlStateNormal];
    }    else
        [self.moodButton setAttributedTitle:[MUSTagManager returnAttributedStringForTag:@"Set Mood"] forState:UIControlStateNormal];
}


#pragma mark  - Keyboard delegate methods
-(void)didSelectCameraButton {
    [self selectPhoto];
}

-(void)enableTextViewInteraction:(BOOL)on {
    self.entryTextViewTap.enabled = on;
    [self.textView setUserInteractionEnabled:on];
}

-(void)enableTextFieldInteraction:(BOOL)on {
    self.titleTap.enabled = on;
    [self.entryTitleTextField setUserInteractionEnabled:on];
}

-(void)didSelectDoneButton:(id)sender {
    [self checkSizeOfContentForTextView:self.textView];
    [self enableTextViewInteraction:YES];
    [self enableTextFieldInteraction:YES];
    
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
}
-(void)didSelectTitleButton:(id)sender {
    if ([self.textView isFirstResponder]){ // append pount to content view
        [self.textView insertText:@"#"];
    } else { // notify user this button does't work for title view
        [MUSNotificationManager displayNotificationWithMessage:@"markdown only for entry content." backgroundColor:[UIColor yellowColor] textColor:[UIColor blackColor]];
    }
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

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self.titleCharacterLimitLabel setHidden:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textView setUserInteractionEnabled:YES];
    self.entryTextViewTap.enabled = YES;
    
    
    if ([self.textView respondsToSelector:@selector(becomeFirstResponder)]) {
        [self.textView becomeFirstResponder];
        return NO;
    }
    
    [self saveTitle];
    return YES;
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



-(void)textViewDidBeginEditing:(UITextView *)textView {
    
    self.textView.font = [UIFont returnParagraphFont];
    [self.entryTitleTextField setUserInteractionEnabled:NO];
    self.entryTextViewTap.enabled = NO;
    
    
    // FOR NEW ENTRY
    if (self.textView.textColor == [UIColor lightGrayColor]) {
        self.textView.textColor = [UIColor blackColor];
        self.textView.text = @"";
    } else {
        self.textView.text = self.destinationEntry.content;
    }
}

- (IBAction)textFieldDidChange:(id)sender {
    
    //DISPLAY CHANGES OR CHARACTER LIMIT
    self.titleCharacterLimitLabel.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithInt:TEXT_LIMIT - (int)self.entryTitleTextField.text.length]];
}

-(void)textViewDidChange:(UITextView *)textView {
    [self checkSizeOfContentForTextView:self.textView];
}

-(void)checkSizeOfContentForTextView:(UITextView *)textView{
    
    [textView sizeToFit];
    [textView layoutIfNeeded];

}

#pragma mark - music controls

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [self.navigationController popViewControllerAnimated:YES];
    [self.MUSToolBar setHidden:NO];
}


- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    // this collection will have one mpmedia item and we need to put it in
    MPMediaItem *selectedItem = mediaItemCollection.items[0];
    Song *pickedSong = [Song initWithTitle:selectedItem.title artist:selectedItem.artist genre:selectedItem.genre album:selectedItem.albumTitle inManagedObjectContext:self.store.managedObjectContext];
    [self.destinationEntry addSongsObject:pickedSong];
    [self.store save];
    
    [self.navigationController popViewControllerAnimated:YES];
    [self playPlaylistForThisEntry];
}



-(void)playPlaylistForThisEntry {
    
    if (self.entryType == ExistingEntry && self.destinationEntry.songs != nil ) {
        
        //         condition for null objects
        
        MPMediaItemCollection *collection = [self.musicPlayer loadMPCollectionFromFormattedMusicPlaylist:self.formattedPlaylistForThisEntry];
        // array of mp media items
        
        
        // loop through playlist collection and track the index so we can reference formatted playlist with song names in it
        int i = 0;
        //
        
        for (MPMediaItem *MPSong in collection.items) {
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
        
        MPMediaItemCollection *filteredCollection =   [self.musicPlayer loadMPCollectionFromFormattedMusicPlaylist: [NSSet convertPlaylistArrayFromSet:self.destinationEntry.songs]];
        [self.musicPlayer.myPlayer setQueueWithItemCollection:filteredCollection];
        //        BOOL autoplayStatus = [[NSUserDefaults standardUserDefaults] boolForKey:@"autoplay"];
        
        // IF AUTOPLAY IS ON AND THIS ENTRY HAS A PLAYLIST... PLAY!
        if ([MUSAutoPlayManager returnAutoPlayStatus] && self.formattedPlaylistForThisEntry.count > 0) {
            [self.musicPlayer.myPlayer play];
        }
    }
    
    // RANDOM SONG
    else if (self.entryType == RandomSong) {
        [self.musicPlayer returnRandomSongInLibraryWithCompletionBlock:^(MPMediaItemCollection *randomSong) {
            [self.musicPlayer.myPlayer setQueueWithItemCollection:randomSong];
            [self.musicPlayer.myPlayer play];
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [IHKeyboardAvoiding setAvoidingView:self.scrollView];
    [IHKeyboardAvoiding setPadding:20];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.MUSToolBar setHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    if ([self isMovingFromParentViewController] && [MUSAutoPlayManager returnAutoPlayStatus]) {
        [self.musicPlayer.myPlayer pause];
    }
    //    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)saveButtonTapped:(id)sender {
    
    if (self.entryTitleTextField.isFirstResponder) {
        // SAVE JUST THE TITLE ON DONE BUTTON PRESS... THIS PRESERVES THE ATTRIBUTED TEXT ON SAVE.... BLOW AWAY ALL MARKDOWN OTHERWISE
        [self saveTitle];
    } else {
        [self saveEntry];
    }
    //    [self.view bringSubviewToFront:self.containerView];
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
    
    //        // check future
    //    NSDate *today = [[NSDate alloc] init];
    //    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    //    [offsetComponents setYear:0];
    //    [offsetComponents setMonth:-3];
    //    [offsetComponents setDay:-16];
    //    NSDate *timeWarp = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
    
    
    // month day and year
    newEntry.createdAt = [currentDate monthDateYearDate];
    // month day and year and seconds
    newEntry.epochTime = currentDate;
    newEntry.tag = @"";
    newEntry.dateInString = [currentDate monthDateAndYearString];
    return newEntry;
}

#pragma mark- photo selection methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.coverImageView.image = info[UIImagePickerControllerEditedImage];
    
    // fixes glitch with parallax, new parallax image does not fit into position without first responder
    [self showKeyboard:self.titleTap];
    
    //IF THIS IS A NEW ENTRY...
    if (self.destinationEntry == nil) {
        Entry *newEntryWithImage = [self createNewEntry];
        newEntryWithImage.coverImage = UIImageJPEGRepresentation(self.coverImageView.image, .5);
    }
    else {
        self.destinationEntry.coverImage = UIImageJPEGRepresentation(self.coverImageView.image, .5);
    }
    // add/ reset parallax image
    [self.scrollView addParallaxWithImage:self.coverImageView.image andHeight:350 andShadow:YES];
    
    // SAVE TO CORE DATA!!
    [self.store save];
}

#pragma mark - button pressed methods


-(void)selectPhoto{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    imagePicker.allowsEditing = YES;
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    // CANCEL
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    
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
            [self presentViewController:alertController animated:YES completion:nil];
        }];
        
    }]];
    
    
    // TAKE PHOTO
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // ask for permission
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [UIImagePickerController obtainPermissionForMediaSourceType:UIImagePickerControllerSourceTypeCamera withSuccessHandler:^{
            
            // add a check if there is a camera...
            [self presentViewController:imagePicker animated:YES completion:nil];
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
    
    // present action sheet
    actionSheet.popoverPresentationController.barButtonItem = self.MUSToolBar.cameraBarButtonItem;
    [self presentViewController:actionSheet animated:YES completion:nil];
}


-(void)playlistButtonPressed:id {
    [self performSegueWithIdentifier:@"playlistSegue" sender:self];
}

-(void)getSongPlayingStatusForSong:(Song *)currentSong {
    
    if (self.musicPlayer.myPlayer.playbackState == MPMusicPlaybackStatePlaying) {
        [self.musicPlayer checkIfSongIsInLocalLibrary:currentSong withCompletionBlock:^(BOOL local) {
            if (local) {
                for (Song *song in  [NSSet convertPlaylistArrayFromSet:self.destinationEntry.songs]) {
                    NSString *currentTrack = [self.musicPlayer.myPlayer nowPlayingItem].title;
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
    } else if (self.musicPlayer.myPlayer.playbackState == MPMusicPlaybackStatePaused || self.musicPlayer.myPlayer.playbackState == MPMusicPlaybackStateStopped) {
        self.musicPlayerStatus = NotPlaying;
    }
}


-(void)pinSongButtonPressed:id {
    
    // Create managed object on CoreData
    MPMediaItem *currentSong = [self.musicPlayer.myPlayer nowPlayingItem];
    Song *pinnedSong = [Song initWithTitle:currentSong.title artist:currentSong.artist genre:currentSong.genre album:currentSong.albumTitle inManagedObjectContext:self.store.managedObjectContext];
    
    [self getSongPlayingStatusForSong:pinnedSong];
    
    if (self.musicPlayerStatus == Playing) {
        if(self.destinationEntry == nil){
            // create new entry and init a playlist for it
            [self createNewEntry];
            self.formattedPlaylistForThisEntry = [[NSMutableArray alloc] init];
        }
        
        // convert long long to nsnumber
        NSNumber *songPersistentNumber = [NSNumber numberWithUnsignedLongLong:[self.musicPlayer.myPlayer nowPlayingItem].persistentID];
        
        pinnedSong.persistentID = songPersistentNumber;
        pinnedSong.pinnedAt = [NSDate date]; //current date
        pinnedSong.entry = self.destinationEntry;
        
        [self displayPinnedSongNotification];
        [self.formattedPlaylistForThisEntry addObject:pinnedSong];
        
        // Add song to Core Data
        [self.destinationEntry addSongsObject:pinnedSong];
        
        MPMediaItemCollection *playlistCollectionForThisEntry =  [self.musicPlayer loadMPCollectionFromFormattedMusicPlaylist:[NSSet convertPlaylistArrayFromSet:self.destinationEntry.songs]];
        
        [self.musicPlayer.myPlayer setQueueWithItemCollection:playlistCollectionForThisEntry];
        
        // Save to Core Data
        [self.store save];
    }
    [self displayPinnedSongNotification];
}


-(void)displayPinnedSongNotification{
    
    MPMediaItem *currentSong = self.musicPlayer.myPlayer.nowPlayingItem;
    
    if (self.musicPlayerStatus == NotPlaying){
        [MUSNotificationManager displayNotificationWithMessage:@"No Song Playing" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor]];
        
    } else if(self.musicPlayerStatus == Invalid) {
        
        [MUSNotificationManager displayNotificationWithMessage:@"Not a valid song in your iTunes library!" backgroundColor:[UIColor yellowColor] textColor:[UIColor blackColor]];
        
    } else if(self.musicPlayerStatus == Playing) {
        
        [MUSNotificationManager displayNotificationWithMessage:[NSString stringWithFormat:@"Successfully Pinned '%@'", currentSong.title] backgroundColor:[UIColor colorWithRed:0.21 green:0.72 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor]];
        
    } else if(self.musicPlayerStatus == AlreadyPinned) {
        [MUSNotificationManager displayNotificationWithMessage:[NSString stringWithFormat:@"%@ is already pinned!", currentSong.title] backgroundColor:[UIColor colorWithRed:0.98 green:0.21 blue:0.37 alpha:1]textColor:[UIColor whiteColor]];
    }
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    
    if ([segue.identifier isEqualToString:@"playlistSegue"]) {
        MUSPlaylistViewController *dvc = segue.destinationViewController;
        dvc.destinationEntry = self.destinationEntry;
        dvc.playlistForThisEntry =[NSSet convertPlaylistArrayFromSet:self.destinationEntry.songs];
        dvc.musicPlayer = self.musicPlayer;
        
    } else if ([segue.identifier isEqualToString:@"moodSegue"]) {
        MUSMoodViewController *dvc = segue.destinationViewController;
        dvc.delegate = self;
        dvc.destinationEntry = self.destinationEntry;
        dvc.destinationToolBar = self.MUSToolBar;
        //        [self.MUSToolBar setHidden:YES];
    }
}


@end
