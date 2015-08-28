//
//  MUSPlaylistViewController.h
//  
//
//  Created by Leo Kwan on 8/24/15.
//
//

#import <UIKit/UIKit.h>
#import "Entry.h"

@interface MUSPlaylistViewController : UIViewController

@property (nonatomic, strong) Entry *destinationEntry;
@property (nonatomic, strong) NSArray *playlistForThisEntry;
@property (nonatomic, strong) NSMutableArray *artworkImagesForThisEntry;

@end
