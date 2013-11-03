//
//  beatcoinAPI.h
//  iOSplayer
//
//  Created by franck on 10/26/13.
//  Copyright (c) 2013 franck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface beatcoinAPI : NSObject <NSURLConnectionDelegate> {
        NSMutableData *_responseData;
}

#define ENGINE_URL @"http://ec2-54-229-112-27.eu-west-1.compute.amazonaws.com"


-(NSNumber *) getPlay;
-(NSString *) getPlayByName;
-(void) postLibrary:(MPMediaItemCollection *)songs;

@end
