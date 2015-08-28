//
//  MUSPlaylistViewController.h
//  
//
//  Created by Leo Kwan on 8/24/15.
//
//

#import <UIKit/UIKit.h>
#import "Entry.h"
#import "MUSCircleGradient.h"

@interface MUSPlaylistViewController : UIViewController

@property (nonatomic, strong) Entry *destinationEntry;
@property (nonatomic, strong) NSArray *playlistForThisEntry;
@property MUSCircleGradient* gradientView;
@property (nonatomic, strong) NSMutableArray *artworkImagesForThisEntry;

@end
