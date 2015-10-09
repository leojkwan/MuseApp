//
//  MUSDetailEntryViewController.m
//  MuseApp
// Categories


#import "UIFont+MUSFonts.h"
#import "NSDate+ExtraMethods.h"
#import "UIButton+ExtraMethods.h"
#import "Entry+ExtraMethods.h"
#import "NSSet+MUSExtraMethod.h"
#import "MUSDetailEntryViewController.h"
#import "MUSAllEntriesViewController.h"
#import "MUSDataStore.h"
#import "Entry.h"
#import <Masonry/Masonry.h>
#import "Song.h"
#import "Song+MUSExtraMethods.h"
#import "MUSPlaylistViewController.h"
#import "MUSMusicPlayer.h"
#import "UIImagePickerController+ExtraMethods.h"
#import <UIScrollView+APParallaxHeader.h>
#import "MUSKeyboardTopBar.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "MUSKeyboardTopBar.h"
#import <IHKeyboardAvoiding.h>
#import "MUSAlertView.h"
#import <CWStatusBarNotification.h>
#import "NSAttributedString+MUSExtraMethods.h"
#import <MBProgressHUD.h>
#import "MUSNotificationManager.h"


typedef enum{
    Playing,
    NotPlaying,
    Invalid,
    AlreadyPinned
}PlayerStatus;

@interface MUSDetailEntryViewController ()<APParallaxViewDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, MUSKeyboardInputDelegate, MPMediaPickerControllerDelegate, UITextFieldDelegate>

@property (nonatomic,assign) PlayerStatus musicPlayerStatus;

@property (nonatomic, strong) MUSPlaylistViewController *dvc;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) MUSDataStore *store;
@property (nonatomic, strong) NSMutableArray *formattedPlaylistForThisEntry;
@property (nonatomic, strong) MUSMusicPlayer *musicPlayer;
@property (nonatomic, strong) MUSKeyboardTopBar *keyboardTopBar;
@property (nonatomic, strong) MUSKeyboardTopBar *MUSToolBar;
@property (weak, nonatomic) IBOutlet UITextField *entryTitleTextField;
@property (weak, nonatomic) IBOutlet UILabel *titleCharacterLimitLabel;
@property (strong, nonatomic) UITapGestureRecognizer *entryTextViewTap;

@end

@implementation MUSDetailEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.store = [MUSDataStore sharedDataStore];
    self.entryTitleTextField.delegate = self;
    
    
    [self setUpTagLabel];
    [self setUpMusicPlayer];
    [self setUpParallaxForExistingEntries];
    [self setUpTextView];
    [self setUpToolbarAndKeyboard];
    [self setUpTitleTextField];
    // set bottom contraints
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.textView.mas_bottom);
    }];
    
    NSLog(@"%lu" , self.destinationEntry.titleOfEntry.length);
}

-(void)setUpTagLabel {
    NSString *text = @"Set Mood";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc ]initWithString:text];
    [attrString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:(NSUnderlineStyleThick)] range:NSMakeRange(0, [attrString length])];
    [attrString addAttribute:NSUnderlineColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, [attrString length])];
    self.tagLabel.attributedText=attrString;
}

-(void)showKeyboard {
    [self.textView becomeFirstResponder];
}

-(void)setUpTitleTextField {
    
    if (self.destinationEntry.titleOfEntry == nil || [self.destinationEntry.titleOfEntry isEqualToString:@""]) {
        self.entryTitleTextField.textColor = [UIColor lightGrayColor];
        self.entryTitleTextField.text = @"Title";
    } else {
        self.entryTitleTextField.text = self.destinationEntry.titleOfEntry;
    }
    [self.titleCharacterLimitLabel setHidden:YES];
    self.titleCharacterLimitLabel.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithInt:40 - (int)self.destinationEntry.titleOfEntry.length]];
    
}

-(void)setUpTextView {
    
    // set up initial number count
    self.entryTextViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showKeyboard)];
    [self.containerView addGestureRecognizer:self.entryTextViewTap];
    
    self.textView.delegate = self;
    self.textView.textContainerInset = UIEdgeInsetsMake(30, 15, 40, 15);     // padding for text view
    
    
    if (self.destinationEntry.content == nil || [self.destinationEntry.content isEqualToString:@""]) {
        self.textView.attributedText = [NSAttributedString returnMarkDownStringFromString:@"Begin writing here..."];
        self.textView.textColor = [UIColor lightGrayColor];
    } else{
        // this is an existing entry
        self.textView.attributedText = [NSAttributedString returnMarkDownStringFromString:self.destinationEntry.content];
    }
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
    [self.keyboardTopBar setFrame:CGRectMake(0, 0, 0, 50)];
    self.textView.inputAccessoryView = self.keyboardTopBar;
    //    self.entryTitleLabel.inputAccessoryView = self.keyboardTopBar;
    self.keyboardTopBar.delegate = self;
    
}

-(void)setUpParallaxForExistingEntries {
    self.coverImageView = [[UIImageView alloc] init];
    if (self.destinationEntry != nil && self.destinationEntry.coverImage != nil) {
        // Set Image For This Entry with Parallax
        [self.scrollView.parallaxView setDelegate:self];
        UIImage *entryCoverImage = [UIImage imageWithData:self.destinationEntry.coverImage];
        self.coverImageView.image = entryCoverImage;
        [self.scrollView addParallaxWithImage:self.coverImageView.image andHeight:350 andShadow:YES];
        
        // there are the magic two lines here
        [self.scrollView.parallaxView.imageView setBounds:CGRectMake(0, 0, self.view.frame.size.width, 350)];
        [self.scrollView.parallaxView.imageView setCenter:CGPointMake(self.view.frame.size.width/2, 175)];
    }
    
}


#pragma mark  - Keyboard delegate methods
-(void)didSelectCameraButton {
    [self selectPhoto];
}
-(void)didSelectDoneButton:(id)sender {
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
    
    self.entryTitleTextField.text = self.destinationEntry.titleOfEntry;
    self.entryTextViewTap.enabled = NO;
    [self.textView setUserInteractionEnabled:NO];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self.titleCharacterLimitLabel setHidden:YES];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.textView setUserInteractionEnabled:YES];
    self.entryTextViewTap.enabled = YES;
    [self saveTitle];
    return YES;
}


- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    return newLength <= 40 || returnKey; // text limit for title
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
    // display attributed text when finished editing
        self.textView.attributedText = [NSAttributedString returnMarkDownStringFromString:self.destinationEntry.content];
}

- (IBAction)textFieldDidChange:(id)sender {
    self.titleCharacterLimitLabel.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithInt:40 - (int)self.entryTitleTextField.text.length]];
}

-(void)textViewDidChange:(UITextView *)textView {
    [self checkSizeOfContentForTextView:self.textView];
}



-(void)checkSizeOfContentForTextView:(UITextView *)textView{
    [textView sizeToFit];
    [textView layoutIfNeeded];
    
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
}


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
        
        
        //            // loop through playlist collection and track the index so we can reference formatted playlist with song names in it
        int i = 0;
        //
        
        for (MPMediaItem *MPSong in collection.items) {
            Song *songForThisIndex = self.formattedPlaylistForThisEntry[i];
            if (MPSong == [NSNull null]) {
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"Oops!"
                                                      message: [NSString stringWithFormat: @"We can't find '%@' by %@ in your library!", songForThisIndex.songName, songForThisIndex.artistName]
                                                      preferredStyle:UIAlertControllerStyleAlert];
                //
                //
                //                    UIAlertAction *findSongAction = [UIAlertAction
                //                                                     actionWithTitle:NSLocalizedString(@"Find Another Song", @"Find Song")
                //                                                     style:UIAlertActionStyleDefault
                //                                                     handler:^(UIAlertAction *action)
                //                                                     {
                //                                                         MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAnyAudio];
                //                                                         picker.delegate = self;
                //                                                         picker.allowsPickingMultipleItems= NO;
                //                                                         [self.navigationController pushViewController:picker animated:YES];
                //                                                     }];
                
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
        [self.musicPlayer.myPlayer play];
    }
    
    // RANDOM SONG
    else if (self.entryType == RandomSong) {
        [self.musicPlayer returnRandomSongInLibraryWithCompletionBlock:^(MPMediaItemCollection *randomSong) {
            [self.musicPlayer.myPlayer setQueueWithItemCollection:randomSong];
            [self.musicPlayer.myPlayer play];
        }];
    }
}


//-(BOOL)prefersStatusBarHidden{
//    return YES;
//}

-(void)viewWillAppear:(BOOL)animated {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [IHKeyboardAvoiding setAvoidingView:(UIView *)self.scrollView];
    [IHKeyboardAvoiding setPaddingForCurrentAvoidingView:30];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.MUSToolBar setHidden:NO];
}

- (void)saveButtonTapped:(id)sender {
    self.entryTextViewTap.enabled = YES;
        [self.entryTitleTextField setUserInteractionEnabled:YES];
        [self.textView setUserInteractionEnabled:YES];
    [self saveEntry];
}

-(void)saveEntry {
    
    
    if (self.destinationEntry == nil) {
        Entry *newEntry = [self createNewEntry];
        newEntry.coverImage = nil;
        
    } else {
        // FOR EXISTING ENTRIES
        if ([self.textView.text isEqualToString:@"Begin writing here..." ]) {
            self.destinationEntry.content = @"";
        } else if ([self.entryTitleTextField.text isEqualToString:@"Title" ]){
        self.destinationEntry.titleOfEntry = @"";
        } else {
        NSLog(@"IN SAVE ENTRY METHOD %@", self.destinationEntry.content);
        self.destinationEntry.content = self.textView.text;
        self.destinationEntry.titleOfEntry = self.entryTitleTextField.text;
        }
    }
    // save to core data
    [self.store save];
    
    // dismiss keyboard
    [self.view endEditing:YES];
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
    if (self.textView.text == nil || [self.textView.text isEqualToString:@"Begin writing here..."])
        newEntry.content = @"";
    else if (self.textView.textColor == [UIColor lightGrayColor])
        newEntry.content = @""; // wipe attributed placeholder text because text it not nil despite new entry
    else if (self.entryTitleTextField.textColor == [UIColor lightGrayColor])
        newEntry.titleOfEntry = @""; // wipe attributed placeholder text
    else
        newEntry.content = self.textView.text;
    
    
    //    newEntry.titleOfEntry = [Entry getTitleOfContentFromText:newEntry.content];
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
    [self showKeyboard];
    
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
            [self createNewEntry];
            self.formattedPlaylistForThisEntry = [[NSMutableArray alloc] init];
        }
        
        // convert long long to nsnumber
        NSNumber *songPersistentNumber = [NSNumber numberWithUnsignedLongLong:[self.musicPlayer.myPlayer nowPlayingItem].persistentID];
        pinnedSong.persistentID = songPersistentNumber;
        
        pinnedSong.pinnedAt = [NSDate date];
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
    NSString *_message;
    
    CWStatusBarNotification *pinSuccessNotification = [CWStatusBarNotification new];
    pinSuccessNotification.notificationStyle = CWNotificationStyleStatusBarNotification;
    pinSuccessNotification.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
    pinSuccessNotification.notificationAnimationOutStyle = CWNotificationAnimationStyleBottom;
    
    
    if (self.musicPlayerStatus == NotPlaying){
        [MUSNotificationManager displayNotificationWithMessage:@"No Song Playing" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor]];
        
    } else if(self.musicPlayerStatus == Invalid) {
        _message = @"Not a valid song in your iTunes library!";
        [MUSNotificationManager displayNotificationWithMessage:@"Not a valid song in your iTunes library!" backgroundColor:[UIColor yellowColor] textColor:[UIColor blackColor]];
        pinSuccessNotification.notificationLabelBackgroundColor = [UIColor redColor];
        
    } else if(self.musicPlayerStatus == Playing) {
        NSString *message = [NSString stringWithFormat:@"Successfully Pinned '%@", currentSong.title];
        [MUSNotificationManager displayNotificationWithMessage:message backgroundColor:[UIColor colorWithRed:0.21 green:0.72 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor]];
        
    } else if(self.musicPlayerStatus == AlreadyPinned) {
        NSString *message  = [NSString stringWithFormat:@"%@ is already pinned!", currentSong.title];
        [MUSNotificationManager displayNotificationWithMessage:message backgroundColor:[UIColor colorWithRed:0.98 green:0.21 blue:0.37 alpha:1]textColor:[UIColor whiteColor]];
    }
}



#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"playlistSegue"]) {
        self.dvc = segue.destinationViewController;
        self.dvc.destinationEntry = self.destinationEntry;
        self.dvc.playlistForThisEntry =[NSSet convertPlaylistArrayFromSet:self.destinationEntry.songs];
        self.dvc.musicPlayer = self.musicPlayer;
    }
}


@end
