#import "FlutterAudioQueryPlugin.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation FlutterAudioQueryPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_audio_query"
            binaryMessenger:[registrar messenger]];
  FlutterAudioQueryPlugin* instance = [[FlutterAudioQueryPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"getSongs" isEqualToString:call.method]) {
    NSArray *songs = [self fetchSongs];
    result(songs);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (NSArray *)fetchSongs {
  NSMutableArray *songList = [NSMutableArray array];
  MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
  NSArray<MPMediaItem *> *songs = [songsQuery items];

  for (MPMediaItem *song in songs) {
    NSString *title = [song valueForProperty:MPMediaItemPropertyTitle];
    NSString *artist = [song valueForProperty:MPMediaItemPropertyArtist];
    NSString *album = [song valueForProperty:MPMediaItemPropertyAlbumTitle];
    NSString *uri = [song valueForProperty:MPMediaItemPropertyAssetURL];

    if (title && artist && album && uri) {
      NSDictionary *songInfo = @{
        @"title": title,
        @"artist": artist,
        @"album": album,
        @"uri": uri
      };
      [songList addObject:songInfo];
    }
  }

  return songList;
}

@end
