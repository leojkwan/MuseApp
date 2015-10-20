//
//  MUSMusicPlayerDataStore.m
//  Muse
//
//  Created by Leo Kwan on 10/19/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "MUSMusicPlayerDataStore.h"

@implementation MUSMusicPlayerDataStore

+ (instancetype)sharedMusicPlayerDataStore {
    static MUSMusicPlayerDataStore *_sharedMusicPlayerDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedMusicPlayerDataStore = [[MUSMusicPlayerDataStore alloc] init];
    });
    
    return _sharedMusicPlayerDataStore;
}


-(instancetype)init {
    self = [super init];
    if (self) {
        _musicPlayer = [[MUSMusicPlayer alloc] init];
        [_musicPlayer.myPlayer prepareToPlay]; ;
    }
    return self;
}




@end
