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
#import <PSPDFTextView.h>
#import "UIBarButtonItem+MUSExtraMethods.h"
#import "MUSMusicPlayer.h"
#import <UIScrollView+APParallaxHeader.h>

@interface MUSDetailEntryViewController ()<APParallaxViewDelegate, UITextViewDelegate, MUSPlayerProtocol>

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (weak, nonatomic) IBOutlet PSPDFTextView *textView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;
@property (nonatomic, strong) MUSMusicPlayer *musicPlayer;
@end

@implementation MUSDetailEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set music player
    self.musicPlayer = [[MUSMusicPlayer alloc] init];
//    self.musicPlayer.delegate = self;
    [self setUpRightNavBar];
    
    Song *currentSong = [self.musicPlayer pinCurrentlyPlayingSong];
//    NSLog(@"%@", currentSong.songName);
    
    self.textView.text = self.destinationEntry.titleOfEntry;
    
    [self.scrollView addParallaxWithImage:[UIImage imageNamed:@"drink"] andHeight:300 andShadow:NO];
    
    
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


- (IBAction)saveButtonTapped:(id)sender {
    NSLog(@"ARE YOU GETTING CALLED?");
    MUSDataStore *store = [MUSDataStore sharedDataStore];
    
    Entry *newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"MUSEntry" inManagedObjectContext:store.managedObjectContext];
    newEntry.content = self.textView.text;
    
    // get title of entry
    newEntry.titleOfEntry = [newEntry getTitleOfContent];
//
//    
//    Song *song =  [NSEntityDescription insertNewObjectForEntityForName:@"MUSSong" inManagedObjectContext:store.managedObjectContext];
//    song.songName = self.secondary.text;

//    [newEntry addSongsObject:song];
    

    
    
    [store save];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUpRightNavBar {
    self.navigationItem.rightBarButtonItems = @[ [UIBarButtonItem returnPinSongBarButtonItem]];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
