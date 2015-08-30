//
//  MUSPlaylistViewController.h
//  
//
//  Created by Leo Kwan on 8/24/15.
//
//

#import <UIKit/UIKit.h>
#import "Entry.h"
#import "MUSMusicPlayer.h"
#import "MUSCircleGradient.h"

@interface MUSPlaylistViewController : UIViewController

@property (nonatomic, strong) Entry *destinationEntry;
@property (nonatomic, strong) NSMutableArray *playlistForThisEntry;
@property MUSCircleGradient* gradientView;
@property (nonatomic, strong) NSMutableArray *artworkImagesForThisEntry;
@property (nonatomic, strong) UIImage *artworkForNowPlayingSong;
@property (nonatomic, strong) MUSMusicPlayer *musicPlayer;

@end
