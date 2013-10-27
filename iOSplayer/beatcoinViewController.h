//
//  beatcoinViewController.h
//  iOSplayer
//
//  Created by franck on 10/26/13.
//  Copyright (c) 2013 franck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface beatcoinViewController : UIViewController <MPMediaPickerControllerDelegate> {
    MPMusicPlayerController *musicPlayer;
    
    __weak IBOutlet UILabel *_statusLine;
    
}

@property (nonatomic, retain) MPMusicPlayerController *musicPlayer;

- (IBAction)showMediaPicker:(id)sender;

- (IBAction)volumeChanged:(id)sender;
- (IBAction)previousSong:(id)sender;
- (IBAction)playPause:(id)sender;
- (IBAction)nextSong:(id)sender;
- (void) registerMediaPlayerNotifications;

@end

