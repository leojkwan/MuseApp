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

@property (weak, nonatomic) IBOutlet UIImageView *testImageView;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (weak, nonatomic) IBOutlet PSPDFTextView *textView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) UIImageView *coverImage;
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
    
    // play playlist
    [self playPlaylistForThisEntry];
    
    self.textView.text = self.destinationEntry.titleOfEntry;
    
    
    
    // Set up parallax image
    self.coverImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drink"]];
    self.coverImage.contentMode = UIViewContentModeCenter;

    [self.coverImage setFrame:CGRectMake(0, 0, 1000, 300)];
    
    [self.scrollView addParallaxWithImage:self.coverImage.image andHeight:300];
    [self.scrollView.parallaxView setDelegate:self];
    
    
    
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.contentView.mas_height);
        self.textView.scrollEnabled = NO;
        self.textView.backgroundColor = [UIColor orangeColor];
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);

        make.bottom.equalTo(self.textView.mas_bottom);
    }];
    
}

- (void)parallaxView:(APParallaxView *)view didChangeFrame:(CGRect)frame {
    NSLog(@"%f" , frame.size.height);
}


-(void)playPlaylistForThisEntry {
    self.musicPlayer = [[MUSMusicPlayer alloc] init];
//    MPMediaItemCollection *playlistCollectionForThisEntry = [self.musicPlayer loadMPCollectionFromFormattedMusicPlaylist:self.formattedPlaylistForThisEntry];
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
    
    Entry *newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"MUSEntry" inManagedObjectContext:self.store.managedObjectContext];
    newEntry.content = self.textView.text;
    
    // get title of entry
    newEntry.titleOfEntry = [newEntry getTitleOfContent];
    
    [self.store save];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUpRightNavBar {
    UIButton *pinSongButton = [UIButton createPinSongButton];
    [pinSongButton addTarget:self action:@selector(pinSongButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *pinSongBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:pinSongButton];
    
    UIButton *playlistButton = [UIButton createPlaylistButton];
    [playlistButton addTarget:self action:@selector(playlistButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *playlistBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:playlistButton];
    
    UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonTapped:)];
    
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
    self.coverImage.image =  [info objectForKey:UIImagePickerControllerEditedImage];

    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // reset parallax image

    [self.scrollView addParallaxWithImage:self.coverImage.image andHeight:300];
}



//- (void)CRMediaPickerController:(CRMediaPickerController *)mediaPickerController didFinishPickingAsset:(ALAsset *)asset error:(NSError *)error {
//    
//    NSLog(@"CHOSE A PHOTO");
//    // Tells the delegate that the picking process is done and the media file is ready to use.
//    ALAssetRepresentation *representation = asset.defaultRepresentation;
//    UIImage *image = [UIImage imageWithCGImage:representation.fullScreenImage];
//    self.coverImage.image = image;
////    [self.scrollView addParallaxWithView:self.coverImage andHeight:300];
//    [self.scrollView addParallaxWithImage:self.coverImage.image andHeight:300];
//
//}


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
