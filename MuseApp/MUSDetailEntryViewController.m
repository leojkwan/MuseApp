//
//  MUSDetailEntryViewController.m
//  MuseApp

// Categories
#import "NSDate+ExtraMethods.h"
#import "UIButton+ExtraMethods.h"
#import "UIImage+Resize.h"
#import "Entry+ExtraMethods.h"
#import "NSSet+MUSExtraMethod.h"

#import "MUSDetailEntryViewController.h"
#import "MUSDataStore.h"
#import "Entry.h"
#import <Masonry/Masonry.h>
#import "Song.h"
#import "MUSPlaylistViewController.h"
#import "MUSMusicPlayer.h"
#import <CRMediaPickerController.h>
#import <UIScrollView+APParallaxHeader.h>
#import "MUSKeyboardTopBar.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "MUSKeyboardTopBar.h"
#import <IHKeyboardAvoiding.h>
#import <CWStatusBarNotification.h>


@interface MUSDetailEntryViewController ()<APParallaxViewDelegate, UITextViewDelegate, APParallaxViewDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, MUSKeyboardInputDelegate>

//@property (weak, nonatomic) IBOutlet UIImageView *testImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) MUSDataStore *store;
@property (nonatomic, strong) CRMediaPickerController *mediaPickerController;
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
    
    self.textView.delegate = self;
    self.textView.text = self.destinationEntry.content;
    [self checkSizeOfContentForTextView:self.textView];
    
    
    
    // Set up textview toolbar input
    self.keyboardTopBar = [[MUSKeyboardTopBar alloc] initWithKeyboard];
    [self.keyboardTopBar setFrame:CGRectMake(0, 0, 0, 50)];
    self.textView.inputAccessoryView = self.keyboardTopBar;
    self.keyboardTopBar.delegate = self;
    [self MUStoolbar];

    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.textView.mas_bottom);
    }];
    
    
}

-(void)setUpMusicPlayer {
    // set up music player
    self.musicPlayer = [[MUSMusicPlayer alloc] init];
    [self playPlaylistForThisEntry];
}

-(void)MUStoolbar {
    self.MUSToolBar = [[MUSKeyboardTopBar alloc] initWithToolbar];
    self.MUSToolBar.delegate = self;
    [self.MUSToolBar setFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    [self.navigationController.view addSubview:self.MUSToolBar];
    
}

-(void)setUpParallaxForExistingEntries {
    self.coverImageView = [[UIImageView alloc] init];
    if (self.destinationEntry != nil) {
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
}



-(void)textViewDidChange:(UITextView *)textView
{
    [self checkSizeOfContentForTextView:textView];
    NSLog(@"%ld", textView.text.length);
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


-(void)playPlaylistForThisEntry {
    if (self.destinationEntry != nil) {
        [self.musicPlayer loadMPCollectionFromFormattedMusicPlaylist:self.formattedPlaylistForThisEntry withCompletionBlock:^(MPMediaItemCollection *response) {
            MPMediaItemCollection *playlistCollectionForThisEntry = response;
            
            // WHEN WE FINISH THE SORTING AND FILTERING, ADD MUSIC TO QUEUE AND PLAY THAT DAMN THING!!!
            [self.musicPlayer.myPlayer setQueueWithItemCollection:playlistCollectionForThisEntry];
            [self.musicPlayer.myPlayer play];
        }];
    }
}


-(void)viewWillDisappear:(BOOL)animated {
    //    [self.musicPlayer removeMusicNotifications];
    [self.MUSToolBar setHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [IHKeyboardAvoiding setAvoidingView:(UIView *)self.scrollView];
    [IHKeyboardAvoiding setPaddingForCurrentAvoidingView:20];
    //    [self.scrollView setContentSize:[self.scrollView frame].size];
    
    
    [self.navigationController setNavigationBarHidden:YES];
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
    
    // dismiss view controller
    [self.textView endEditing:YES];
}


-(Entry *)createNewEntry {
    Entry *newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"MUSEntry" inManagedObjectContext:self.store.managedObjectContext];
    self.destinationEntry = newEntry;
    if (self.textView.text == nil) {
        newEntry.content = @"";
    } else {
        newEntry.content = self.textView.text;
    }
    newEntry.titleOfEntry = [Entry getTitleOfContentFromText:newEntry.content];
    NSDate *currentDate = [NSDate date];
    newEntry.createdAt = currentDate;
    newEntry.dateInString = [currentDate returnFormattedDateString];
    NSLog(@"%@", newEntry.createdAt);
    return newEntry;
}


#pragma mark- photo selection methods
//
//
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    [self.textView resignFirstResponder];
//    if (buttonIndex == actionSheet.cancelButtonIndex) {
//        return;
//    };
//    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//    imagePicker.delegate = self;
//    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
//    imagePicker.allowsEditing = YES;
//    if (buttonIndex == 0 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    } else if (buttonIndex == 1 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
//        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    }
//    [self presentViewController:imagePicker animated:YES completion:nil];
//}
//
//

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
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }]];
    // TAKE PHOTO
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}

-(void)playlistButtonPressed:id {
    [self performSegueWithIdentifier:@"playlistSegue" sender:self];
}

-(void)pinSongButtonPressed:id {
    
    if(self.destinationEntry == nil){
        [self createNewEntry];
    }
    // check if song is pinnable
    //....
    // Create managed object on CoreData
    Song *pinnedSong = [NSEntityDescription insertNewObjectForEntityForName:@"MUSSong" inManagedObjectContext:self.store.managedObjectContext];
    pinnedSong.artistName = [self.musicPlayer.myPlayer nowPlayingItem].artist;
    pinnedSong.songName = [self.musicPlayer.myPlayer nowPlayingItem].title;
    pinnedSong.pinnedAt = [NSDate date];
    pinnedSong.entry = self.destinationEntry;
    
    
    // give notification
    
    CWStatusBarNotification *pinSuccessNotification = [CWStatusBarNotification new];
    pinSuccessNotification.notificationStyle = CWNotificationStyleStatusBarNotification;
    pinSuccessNotification.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
    pinSuccessNotification.notificationAnimationOutStyle = CWNotificationAnimationStyleBottom;
    NSString *successMessage = [NSString stringWithFormat:@"Successfully Pinned '%@'", pinnedSong.songName];
    pinSuccessNotification.notificationLabelBackgroundColor = [UIColor colorWithRed:0.21 green:0.72 blue:0.00 alpha:1.0];
    pinSuccessNotification.notificationLabelTextColor = [UIColor whiteColor];
    pinSuccessNotification.notificationLabel.textAlignment = NSTextAlignmentCenter;
    pinSuccessNotification.notificationLabelHeight = 30;
    pinSuccessNotification.notificationLabelFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:17];
    [pinSuccessNotification displayNotificationWithMessage:successMessage forDuration:0.7];
    
    
    
    // Format this song and add to array
    NSMutableArray *arrayForThisSong = [[NSMutableArray alloc] init];
    [arrayForThisSong addObject:pinnedSong.artistName];
    [arrayForThisSong addObject:pinnedSong.songName];
    [self.formattedPlaylistForThisEntry addObject:arrayForThisSong];
    
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"playlistSegue"]) {
        MUSPlaylistViewController *dvc = segue.destinationViewController;
        dvc.destinationEntry = self.destinationEntry;
        dvc.playlistForThisEntry = self.formattedPlaylistForThisEntry;
        dvc.musicPlayer = self.musicPlayer;
        //        dvc.artworkForNowPlayingSong = [[self.musicPlayer.myPlayer nowPlayingItem].artwork imageWithSize:CGSizeMake(500, 500)];
        [self.musicPlayer loadPlaylistArtworkForThisEntryWithCompletionBlock:^(NSMutableArray *artworkImages) {
            dvc.artworkImagesForThisEntry = artworkImages;
        }];
    }
    
    
}


@end
