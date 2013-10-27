//
//  beatcoinAPI.h
//  iOSplayer
//
//  Created by franck on 10/26/13.
//  Copyright (c) 2013 franck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface beatcoinAPI : NSObject

#define ENGINE_URL @"http://engine.beatcoin.org"

+(NSNumber *) getPlay;
//+(NSArray *) getPlay;
+(NSString *) getPlayByName;

+(void) postLibrary:(MPMediaItemCollection *)songs;

@end
