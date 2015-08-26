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
#import <TPKeyboardAvoidingScrollView.h>
#import "NSSet+MUSExtraMethod.h"
#import <PSPDFTextView.h>
#import "UIButton+ExtraMethods.h"
#import "MUSPlaylistViewController.h"
#import "MUSMusicPlayer.h"
#import <CRMediaPickerController.h>
#import <UIScrollView+APParallaxHeader.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface MUSDetailEntryViewController ()<APParallaxViewDelegate, UITextViewDelegate, APParallaxViewDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate>

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
@end

@implementation MUSDetailEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.store = [MUSDataStore sharedDataStore];
    
    //Set up nav bar
    [self setUpRightNavBar];
    
    
    //Convert entry NSSet into appropriate MutableArray
    self.formattedPlaylistForThisEntry = [NSSet convertPlaylistArrayFromSet:self.destinationEntry.songs];
    
    
    if (self.destinationEntry != nil) {
    // play playlist
    [self playPlaylistForThisEntry];
    
    
    // Set Text For This Entry
    self.textView.text = self.destinationEntry.titleOfEntry;
    
    // Set Image For This Entry with Parallax


    UIImage *entryCoverImage = [UIImage imageWithData:self.destinationEntry.coverImage];
    self.coverImageView = [[UIImageView alloc] initWithImage:entryCoverImage];
    [self.scrollView addParallaxWithImage:self.coverImageView.image andHeight:350];
    [self.scrollView.parallaxView setDelegate:self];
    }
    
    
//        [self.textView sizeToFit]; //added
//        [self.textView layoutIfNeeded]; //added
//        
//        self.textView.scrollEnabled = NO;
//        [self.textView sizeToFit];
//    
    self.textView.delegate = self;
    self.textView.text = self.destinationEntry.titleOfEntry;
    [self checkSizeOfContentForTextView:self.textView];
    

    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.textView.mas_bottom);
    }];
    NSLog(@"THIS IS HOW BIG I AM %f", self.textView.bounds.size.height);
    
    
    
    
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"text view is changing with %ld", [textView.text length]);
    [self checkSizeOfContentForTextView:textView];
}

-(void)checkSizeOfContentForTextView:(UITextView *)textView{
    if ([textView.text length] < 700) {
        
        NSLog(@"DO YOU EVER GET CALLED IN VIEW DID CHANGE TEXT VIEW?");
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@500);
        }];
    } else {
        [textView sizeToFit];
        [textView layoutIfNeeded];
    }
}

- (void)parallaxView:(APParallaxView *)view didChangeFrame:(CGRect)frame {
    NSLog(@"%f" , frame.size.height);
}


-(void)playPlaylistForThisEntry {
    self.musicPlayer = [[MUSMusicPlayer alloc] init];
    [self.musicPlayer loadMPCollectionFromFormattedMusicPlaylist:self.formattedPlaylistForThisEntry withCompletionBlock:^(MPMediaItemCollection *response) {
        MPMediaItemCollection *playlistCollectionForThisEntry = response;
        
        // WHEN WE FINISH THE SORTING AND FILTERING, ADD MUSIC TO QUEUE AND PLAY THAT DAMN THING!!!
        [self.musicPlayer.myPlayer setQueueWithItemCollection:playlistCollectionForThisEntry];
        [self.musicPlayer.myPlayer play];
    }];
    

}


-(void)viewWillDisappear:(BOOL)animated {
    [self.musicPlayer removeMusicNotifications];
}

- (IBAction)saveButtonTapped:(id)sender {
    NSLog(@"ARE YOU GETTING CALLED?");
    
    if (self.destinationEntry == nil) {
        
        // FOR NEW ENTRIES
        Entry *newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"MUSEntry" inManagedObjectContext:self.store.managedObjectContext];
        newEntry.content = self.textView.text;
        newEntry.createdAt = [NSDate date];
        newEntry.titleOfEntry = [newEntry getTitleOfContent];
        [self.navigationController popViewControllerAnimated:YES];

    } else {
        // FOR OLD ENTRIES
        self.destinationEntry.content = self.textView.text;
        self.destinationEntry.titleOfEntry = [self.destinationEntry getTitleOfContent];
    }
      [self.store save];
    
    // dismiss view controller
      [self.textView endEditing:YES];
}

-(void)setUpRightNavBar {
    UIButton *pinSongButton = [UIButton createPinSongButton];
    [pinSongButton addTarget:self action:@selector(pinSongButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *pinSongBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:pinSongButton];
    
    UIButton *playlistButton = [UIButton createPlaylistButton];
    [playlistButton addTarget:self action:@selector(playlistButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *playlistBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:playlistButton];
    
    UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonTapped:)];
    
    UIBarButtonItem *uploadImageBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(selectPhoto:)];
    
    self.navigationItem.rightBarButtonItems = @[saveBarButtonItem, playlistBarButtonItem, pinSongBarButtonItem, uploadImageBarButtonItem];
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
    self.coverImageView.image = info[UIImagePickerControllerOriginalImage];

    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // update parallax image
    [self.scrollView addParallaxWithImage:self.coverImageView.image andHeight:350];
    
    
    // SAVE TO CORE DATA!!
    self.destinationEntry.coverImage = UIImageJPEGRepresentation(self.coverImageView.image, .7);
    [self.store save];
}


-(void)playlistButtonPressed:id {
    NSLog(@"playlist button tapped");
    [self performSegueWithIdentifier:@"playlistSegue" sender:self];
}

-(void)pinSongButtonPressed:id {
    NSLog(@"pin song button tapped");
    
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
