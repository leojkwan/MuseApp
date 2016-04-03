//
//  MUSITunesClient.m

#import "MUSITunesClient.h"
#import <AFNetworking/AFNetworking.h>
#import "MUSConstants.h"

NSString *const ITUNES_SEARCH_URL = @"https://itunes.apple.com/search";


@implementation MUSITunesClient

+(void)getAlbumLinkWithAlbum:(NSString *)album artist:(NSString *)artist completionBlock:(void (^)(NSString *))completionBlock {
  NSDictionary *iTunesParams = @{
                                 @"term": [NSString stringWithFormat:@"%@ %@",album, artist], // search query
                                 @"entity": @"album", // what I want returned
                                 @"limit": @1,
                                 @"media": @"music"};
  
  
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  [manager GET:ITUNES_SEARCH_URL parameters:iTunesParams success:^(NSURLSessionDataTask *task, id responseObject) {
    
    
    if ([(NSNumber *)responseObject[@"resultCount"] isEqual: @0]) {
      // make another request, this time for artist Name
      completionBlock(@"No Album URL");
    }
    else {
      completionBlock(responseObject[@"results"][0][@"collectionViewUrl"]);
    }
    
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"Fail: %@",error.localizedDescription);
  }];
}


+(void)getArtistWithName:(NSString *)artistName completionBlock:(void (^)(NSString *))completionBlock
{
  NSDictionary *iTunesParams = @{
                                 @"term": [NSString stringWithFormat:@"%@", artistName], // search query
                                 @"entity": @"allArtist", // what I want returned
                                 @"limit": @1,
                                 @"media": @"music"};
  
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    
    [manager GET:ITUNES_SEARCH_URL parameters:iTunesParams success:^(NSURLSessionDataTask *task, id responseObject) {
      
      if ([(NSNumber *)responseObject[@"resultCount"] isEqual: @0]) {
        completionBlock(@"No Artist URL");
      } else {
        completionBlock(responseObject[@"results"][0][@"artistLinkUrl"]);
      }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
      NSLog(@"Fail: %@",error.localizedDescription);
    }];
  }];
  
}



@end
