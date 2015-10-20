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

@protocol ArtworkLoaderProtocol
-(void)artWorkDidFinishLoading;

@end

@interface MUSPlaylistViewController : UIViewController

@property (nonatomic, strong) Entry *destinationEntry;
@property (nonatomic, strong) NSMutableArray *playlistForThisEntry;
//@property (nonatomic, strong) MUSMusicPlayer *musicPlayer;
@property (nonatomic, assign) id <ArtworkLoaderProtocol> delegate;

@end
