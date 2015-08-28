//
//  MUSDetailEntryViewController.m
//  MuseApp
//
//  Created by Leo Kwan on 8/23/15.
//  Copyright (c) 2015 Leo Kwan. All rights reserved.
//

#import "MUSDetailEntryViewController.h"
#import "MUSDataStore.h"
#import "Entry.h"
#import <Masonry/Masonry.h>
#import "Song.h"
#import "UIImage+Resize.h"
#import <TPKeyboardAvoidingScrollView.h>
#import "NSSet+MUSExtraMethod.h"
#import <PSPDFTextView.h>
#import "UIButton+ExtraMethods.h"
#import "MUSPlaylistViewController.h"
#import "MUSMusicPlayer.h"
#import <CRMediaPickerController.h>
#import <UIScrollView+APParallaxHeader.h>
#import "MUSKeyboardTopBar.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "MUSKeyboardTopBar.h"


@interface MUSDetailEntryViewController ()<APParallaxViewDelegate, UITextViewDelegate, APParallaxViewDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, MUSKeyboardInputDelegate>

//@property (weak, nonatomic) IBOutlet UIImageView *testImageView;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (weak, nonatomic) IBOutlet PSPDFTextView *textView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) MUSDataStore *store;
@property (nonatomic, strong) CRMediaPickerController *mediaPickerController;
@property (nonatomic, strong) NSMutableArray *formattedPlaylistForThisEntry;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;
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
    
    
    // play playlist
    [self playPlaylistForThisEntry];
    
    
    [self setUpParallaxForExistingEntries];
    
    
    self.textView.delegate = self;
    self.textView.text = self.destinationEntry.titleOfEntry;
    [self checkSizeOfContentForTextView:self.textView];
    
    
    
    // Set up textview toolbar input
    self.keyboardTopBar = [[MUSKeyboardTopBar alloc] initWithKeyboard];
    [self.keyboardTopBar setFrame:CGRectMake(0, 0, 0, 50)];
    self.textView.inputAccessoryView = self.keyboardTopBar;
    self.keyboardTopBar.delegate = self;
    
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.textView.mas_bottom);
    }];
    
    
    [self MUStoolbar];
}

-(void)MUStoolbar {
    // hacky as shit
    self.MUSToolBar = [[MUSKeyboardTopBar alloc] initWithToolbar];
    self.MUSToolBar.delegate = self;
    [self.MUSToolBar setFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    [self.navigationController.view addSubview:self.MUSToolBar];
    
}


-(void)setUpParallaxForExistingEntries {
    
    if (self.destinationEntry != nil) {
        
        // Set Image For This Entry with Parallax
        [self.scrollView.parallaxView setDelegate:self];
        UIImage *entryCoverImage = [UIImage imageWithData:self.destinationEntry.coverImage];
        self.coverImageView = [[UIImageView alloc] init];
        self.coverImageView.image = entryCoverImage;
        [self.scrollView addParallaxWithImage:self.coverImageView.image andHeight:500 andShadow:YES];
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
}

-(void)checkSizeOfContentForTextView:(UITextView *)textView{
    if ([textView.text length] < 700) {
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@750);
        }];
    } else {
        [textView sizeToFit];
        [textView layoutIfNeeded];
    }
}

- (void)parallaxView:(APParallaxView *)view didChangeFrame:(CGRect)frame {
    //    NSLog(@"%f" , frame.size.height);
}


-(void)playPlaylistForThisEntry {
    if (self.destinationEntry != nil) {
        
        self.musicPlayer = [[MUSMusicPlayer alloc] init];
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
    [self.navigationController setNavigationBarHidden:YES];
    [self.MUSToolBar setHidden:NO];
}

- (void)saveButtonTapped:(id)sender {
    
    if (self.destinationEntry == nil && self.coverImageView == nil) {
        Entry *newEntry = [self createNewEntry];
        newEntry.coverImage = nil;
        
    } else {
        // FOR OLD ENTRIES
        self.destinationEntry.content = self.textView.text;
        self.destinationEntry.titleOfEntry = [self.destinationEntry getTitleOfContent];
    }
    [self.store save];
    
    // dismiss view controller
    [self.textView endEditing:YES];
}


-(Entry *)createNewEntry {
    Entry *newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"MUSEntry" inManagedObjectContext:self.store.managedObjectContext];
    if (self.textView.text == nil) {
        newEntry.content = @"";
    } else {
        newEntry.content = self.textView.text;
    }
    newEntry.titleOfEntry = [newEntry getTitleOfContent];
    
    newEntry.createdAt = [NSDate date];
    return newEntry;
}

-(void)selectPhoto:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
    [actionSheet addButtonWithTitle:@"Take Photo"];
    [actionSheet addButtonWithTitle:@"Select photo from camera"];
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
    actionSheet.cancelButtonIndex = 2;
    [actionSheet showInView:self.view];
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.textView resignFirstResponder];
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    };
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    imagePicker.allowsEditing = YES;
    if (buttonIndex == 0 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if (buttonIndex == 1 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    self.coverImageView = [[UIImageView alloc] init];
    [self.coverImageView setContentMode:UIViewContentModeCenter];
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
    

        [self.scrollView addParallaxWithImage:self.coverImageView.image andHeight:200 andShadow:YES];
    
    
    
    // SAVE TO CORE DATA!!
    [self.store save];
}


-(void)playlistButtonPressed:id {
    [self performSegueWithIdentifier:@"playlistSegue" sender:self];
}

-(void)pinSongButtonPressed:id {
    
    // Create managed object on CoreData
    Song *pinnedSong = [NSEntityDescription insertNewObjectForEntityForName:@"MUSSong" inManagedObjectContext:self.store.managedObjectContext];
    pinnedSong.artistName = self.musicPlayer.currentlyPlayingSong.artist;
    pinnedSong.songName = self.musicPlayer.currentlyPlayingSong.title;
    
    pinnedSong.pinnedAt = [NSDate date];
    pinnedSong.entry = self.destinationEntry;
    
    // create 2D array for this song
    NSMutableArray *arrayForThisSong = [[NSMutableArray alloc] init];
    [arrayForThisSong addObject:pinnedSong.artistName];
    [arrayForThisSong addObject:pinnedSong.songName];
    [self.formattedPlaylistForThisEntry addObject:arrayForThisSong];
    
    // Add song array to playlist
    [self.destinationEntry addSongsObject:pinnedSong];
    
    NSLog(@"%@" , self.destinationEntry.songs);
    
    [self.store save];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"playlistSegue"]) {
        MUSPlaylistViewController *dvc = segue.destinationViewController;
        dvc.destinationEntry = self.destinationEntry;
        dvc.playlistForThisEntry = self.formattedPlaylistForThisEntry;
    }
    
    
}


@end
