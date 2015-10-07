//
//  MUSITunesClient.h
//  
//
//  Created by Leo Kwan on 10/6/15.
//
//

#import <Foundation/Foundation.h>

@interface MUSITunesClient : NSObject

+(void)getAlbumLinkWithAlbum:(NSString *)album artist:(NSString *)artist completionBlock:(void (^)(NSString *))completionBlock;
+(void)getArtistWithName:(NSString *)artistName completionBlock:(void (^)(NSString *))completionBlock;

@end
