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
#import <AssetsLibrary/AssetsLibrary.h>
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
#import <Photos/Photos.h>

typedef enum{
    Playing,
    NotPlaying,
    Invalid,
    AlreadyPinned
}PlayerStatus;

@interface MUSDetailEntryViewController ()<APParallaxViewDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, MUSKeyboardInputDelegate, MPMediaPickerControllerDelegate>

@property (nonatomic,assign) PlayerStatus musicPlayerStatus;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) MUSDataStore *store;
@property (nonatomic, strong) NSMutableArray *formattedPlaylistForThisEntry;
@property (nonatomic, strong) MUSMusicPlayer *musicPlayer;
@property (nonatomic, strong) MUSKeyboardTopBar *keyboardTopBar;
@property (nonatomic, strong) MUSKeyboardTopBar *MUSToolBar;

@end

@implementation MUSDetailEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.store = [MUSDataStore sharedDataStore];
    
    //Convert entry NSSet into appropriate MutableArray
    self.formattedPlaylistForThisEntry = [NSSet convertPlaylistArrayFromSet:self.destinationEntry.songs];
    
    [self setUpMusicPlayer];
    [self setUpParallaxForExistingEntries];
    [self setUpTextView];
    [self setUpToolbarAndKeyboard];
    
    // set bottom contraints
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.textView.mas_bottom);
    }];
    
}

-(void)setUpTextView {
    self.textView.delegate = self;
    self.textView.textContainerInset = UIEdgeInsetsMake(30, 15, 40, 15);     // padding for text view
    NSLog(@"%@", self.textView.text);
    if (self.destinationEntry == nil) {
        self.textView.attributedText = [NSAttributedString returnMarkDownStringFromString:@"####Begin writing here..."];
        self.textView.textColor = [UIColor lightGrayColor];
    } else{
        self.textView.attributedText = [NSAttributedString returnMarkDownStringFromString:self.destinationEntry.content];
    }
    [self checkSizeOfContentForTextView:self.textView];
    
    
    NSLog(@"%@", self.textView.attributedText);
}

-(BOOL)shouldAutorotate {
    return NO;
}


-(void)setUpMusicPlayer {
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
-(void)didSelectCameraButton:(id)sender {
    [self selectPhoto:sender];
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
    [self.textView insertText:@"#"];
}


-(void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.textView.textColor == [UIColor lightGrayColor]) {
        self.textView.textColor = [UIColor blackColor];
    }
    self.textView.text = self.destinationEntry.content;
    self.textView.font = [UIFont returnFontsForDefaultString];
    self.textView.textColor = [UIColor darkGrayColor];
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    self.textView.attributedText = [NSAttributedString returnMarkDownStringFromString:self.destinationEntry.content];
}




-(void)checkSizeOfContentForTextView:(UITextView *)textView{
    if ([textView.text length] < 700) {
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@700);
        }];
    } else {
        [textView sizeToFit];
        [textView layoutIfNeeded];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            // add bottom space between between text view and scrolling content view
            make.height.equalTo(self.textView.mas_height).with.offset(200);
        }];
    }
}

- (void)parallaxView:(APParallaxView *)view didChangeFrame:(CGRect)frame {
    //    NSLog(@"%f" , frame.size.height);
}


- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [self.navigationController popViewControllerAnimated:YES];
    [self.MUSToolBar setHidden:NO];
    
    NSLog(@"dismiss media picker");
}


//
//
//
//- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
//    // this collection will have one mpmedia item and we need to put it in
//    MPMediaItem *selectedItem = mediaItemCollection.items[0];
//    Song *pickedSong = [Song initWithTitle:selectedItem.title artist:selectedItem.artist genre:selectedItem.genre album:selectedItem.albumTitle inManagedObjectContext:self.store.managedObjectContext];
//    [self.destinationEntry addSongsObject:pickedSong];
//    [self.store save];
//    //    [self.MUSToolBar setHidden:NO];
//    
//    [self.navigationController popViewControllerAnimated:YES];
//    [self playPlaylistForThisEntry];
//}
//


-(void)playPlaylistForThisEntry {
    
    if (self.entryType == ExistingEntry ) {
        
//         condition for null objects
        
        [self.musicPlayer loadMPCollectionFromFormattedMusicPlaylist:self.formattedPlaylistForThisEntry withCompletionBlock:^(MPMediaItemCollection *response) {
            // array of mp media items
            MPMediaItemCollection *playlistCollectionForThisEntry = response;
            
            
            
//            // loop through playlist collection and track the index so we can reference formatted playlist with song names in it
//            int i = 0;
//            for (MPMediaItem *MPSong in playlistCollectionForThisEntry.items) {
//                Song *songForThisIndex = self.formattedPlaylistForThisEntry[i];
//                if (MPSong == [NSNull null]) {
//                    UIAlertController *alertController = [UIAlertController
//                                                          alertControllerWithTitle:@"Oops!"
//                                                          message: [NSString stringWithFormat: @"We can't find '%@' by %@ in your library!", songForThisIndex.songName, songForThisIndex.artistName]
//                                                          preferredStyle:UIAlertControllerStyleAlert];
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
//                    
//                    UIAlertAction *okAction = [UIAlertAction
//                                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
//                                               style:UIAlertActionStyleDefault
//                                               handler:^(UIAlertAction *action)
//                                               {
//                                                   NSLog(@"OK action");
//                                                   [self playPlaylistForThisEntry];
//                                               }];
//                    
//                    [alertController addAction:findSongAction];
//                    [alertController addAction:okAction];
//                    // present alert if there are null songs
//                    [self presentViewController:alertController animated:YES completion:nil];
//                    // delete null song from core data
//                    [self.destinationEntry removeSongsObject:self.formattedPlaylistForThisEntry[i]];
//                    [self.store save];
//                } //  end of if statment
//                i++; // next song
//            } // end of for loop
            
            [self.musicPlayer.myPlayer setQueueWithItemCollection:playlistCollectionForThisEntry];
            [self.musicPlayer.myPlayer play];
            
            
            
        }];
        
        
        
    }

    // RANDOM SONG
    else if (self.entryType == RandomSong) {
        [self.musicPlayer returnRandomSongInLibraryWithCompletionBlock:^(MPMediaItemCollection *randomSong) {
            [self.musicPlayer.myPlayer setQueueWithItemCollection:randomSong];
            [self.musicPlayer.myPlayer play];
        }];
    }
}


-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated {
    [IHKeyboardAvoiding setAvoidingView:(UIView *)self.scrollView];
    [IHKeyboardAvoiding setPaddingForCurrentAvoidingView:50];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.MUSToolBar setHidden:NO];
}

- (void)saveButtonTapped:(id)sender {
    if (self.destinationEntry == nil) {
        Entry *newEntry = [self createNewEntry];
        newEntry.coverImage = nil;
        
    } else {
        // FOR OLD ENTRIES
        self.destinationEntry.content = self.textView.text;
        self.destinationEntry.titleOfEntry = [Entry getTitleOfContentFromText:self.destinationEntry.content];
    }
    
    // save to core data
    [self.store save];
    
    // dismiss keyboard
    [self.textView endEditing:YES];
}


-(Entry *)createNewEntry {
    Entry *newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"MUSEntry" inManagedObjectContext:self.store.managedObjectContext];
    
    self.destinationEntry = newEntry;
    if (self.textView.text == nil) {
        newEntry.content = @"";
    } else if (self.textView.textColor == [UIColor lightGrayColor]){
        newEntry.content = @""; // wipe attributed placeholder text because text it not nil despite new entry
    }
    else {
        newEntry.content = self.textView.text;
    }
    newEntry.titleOfEntry = [Entry getTitleOfContentFromText:newEntry.content];
    NSDate *currentDate = [NSDate date];
    newEntry.createdAt = currentDate;
    newEntry.tag = @"";
    newEntry.dateInString = [currentDate returnMonthAndYear];
    return newEntry;
}


#pragma mark- photo selection methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.coverImageView.image = info[UIImagePickerControllerEditedImage];
    [self.textView becomeFirstResponder];
    
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


-(void)selectPhoto:(id)sender {
    
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
            NSLog(@"success!");
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
            alertController.popoverPresentationController.sourceView = sender;
            alertController.popoverPresentationController.sourceRect = [sender bounds];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
        
    }]];
    
    
    // TAKE PHOTO
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // ask for permission
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [UIImagePickerController obtainPermissionForMediaSourceType:UIImagePickerControllerSourceTypeCamera withSuccessHandler:^{
            [self presentViewController:imagePicker animated:YES completion:nil];
            NSLog(@"success!");
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
            alertController.popoverPresentationController.sourceView = sender;
            alertController.popoverPresentationController.sourceRect = [sender bounds];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
    }]];
    
    // present action sheet
    actionSheet.popoverPresentationController.sourceView = sender;
    actionSheet.popoverPresentationController.sourceRect = [sender bounds];
    [self presentViewController:actionSheet animated:YES completion:nil];
}


-(void)playlistButtonPressed:id {
    [self performSegueWithIdentifier:@"playlistSegue" sender:self];
}

-(void)getSongPlayingStatusForSong:(Song *)currentSong {
    
    if (self.musicPlayer.myPlayer.playbackState == MPMusicPlaybackStatePlaying) {
        [self.musicPlayer checkIfSongIsInLocalLibrary:currentSong withCompletionBlock:^(BOOL local) {
            if (local) {
                for (Song *song in self.formattedPlaylistForThisEntry) {
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
        NSLog(@"%@" , songPersistentNumber) ;
        pinnedSong.persistentID = songPersistentNumber;
        
        pinnedSong.pinnedAt = [NSDate date];
        pinnedSong.entry = self.destinationEntry;
        
        [self displayPinnedSongNotification];
        [self.formattedPlaylistForThisEntry addObject:pinnedSong];
        // Add song to Core Data
        [self.destinationEntry addSongsObject:pinnedSong];
        
        // reset the collection array
        [self.musicPlayer loadMPCollectionFromFormattedMusicPlaylist:self.formattedPlaylistForThisEntry withCompletionBlock:^(MPMediaItemCollection *response) {
            MPMediaItemCollection *playlistCollectionForThisEntry = response;
            [self.musicPlayer.myPlayer setQueueWithItemCollection:playlistCollectionForThisEntry];
        }];
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
        _message = @"No Song Playing.";
        pinSuccessNotification.notificationLabelBackgroundColor = [UIColor grayColor];
        
    } else if(self.musicPlayerStatus == Invalid) {
        _message = @"Not a valid song in your iTunes library!";
        pinSuccessNotification.notificationLabelBackgroundColor = [UIColor redColor];
        
    } else if(self.musicPlayerStatus == Playing) {
        _message = [NSString stringWithFormat:@"Successfully Pinned '%@", currentSong.title];
        pinSuccessNotification.notificationLabelBackgroundColor = [UIColor colorWithRed:0.21 green:0.72 blue:0.00 alpha:1.0];
        
    } else if(self.musicPlayerStatus == AlreadyPinned) {
        _message = [NSString stringWithFormat:@"%@ is already pinned!", currentSong.title];
        pinSuccessNotification.notificationLabelBackgroundColor = [UIColor colorWithRed:0.98 green:0.21 blue:0.37 alpha:1];
    }
    
    pinSuccessNotification.notificationLabelTextColor = [UIColor whiteColor];
    pinSuccessNotification.notificationLabel.textAlignment = NSTextAlignmentCenter;
    pinSuccessNotification.notificationLabelHeight = 30;
    pinSuccessNotification.notificationLabelFont = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
    [pinSuccessNotification displayNotificationWithMessage:_message forDuration:0.7];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"playlistSegue"]) {
        MUSPlaylistViewController *dvc = segue.destinationViewController;
        dvc.destinationEntry = self.destinationEntry;
        dvc.playlistForThisEntry =[NSSet convertPlaylistArrayFromSet:self.destinationEntry.songs];
        ;
        dvc.musicPlayer = self.musicPlayer;
        
        
    }
    NSLog(@"segue");
    
}


@end
